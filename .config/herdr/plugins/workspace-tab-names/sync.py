#!/usr/bin/env python3
"""Keep plugin-owned tab labels in sync; None records a manual override."""

import argparse
import fcntl
import hashlib
import json
import os
from pathlib import Path
import subprocess


def herdr(*args):
    result = subprocess.run(
        [os.environ["HERDR_BIN_PATH"], *args],
        check=True,
        stdout=subprocess.PIPE,
        text=True,
        timeout=15,
    )
    response = json.loads(result.stdout)
    if "error" in response:
        raise RuntimeError(response["error"])
    return response["result"]


def save(path, state):
    temporary = path.with_suffix(".tmp")
    temporary.write_text(json.dumps(state, ensure_ascii=False) + "\n", encoding="utf-8")
    temporary.replace(path)


def created_tabs(event, tabs):
    data = event.get("data", {})
    if event.get("event") == "tab_created":
        tab = data["tab"]
        return {tab["tab_id"]: tab["label"]} if tab["label"] == str(tab["number"]) else {}
    if event.get("event") == "workspace_created":
        workspace_id = data["workspace"]["workspace_id"]
        return {
            tab["tab_id"]: str(tab["number"])
            for tab in tabs
            if tab["workspace_id"] == workspace_id
        }
    return {}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--adopt-matching", action="store_true")
    args = parser.parse_args()
    if os.environ.get("HERDR_ENV") != "1":
        raise RuntimeError("Run through a Herdr plugin hook or action")

    # Plugin storage is global, but tab IDs are only unique within a session.
    socket_path = os.path.realpath(os.environ["HERDR_SOCKET_PATH"])
    session_key = hashlib.sha256(socket_path.encode()).hexdigest()
    directory = Path(os.environ["HERDR_PLUGIN_STATE_DIR"])
    path = directory / (session_key + ".json")
    event = json.loads(os.environ.get("HERDR_PLUGIN_EVENT_JSON", "{}"))

    # Hooks run concurrently, including events caused by our own renames.
    with (directory / (session_key + ".lock")).open("a") as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        state = json.loads(path.read_text(encoding="utf-8")) if path.exists() else {}
        snapshot = herdr("api", "snapshot")["snapshot"]
        workspaces = {w["workspace_id"]: w["label"] for w in snapshot["workspaces"]}
        tabs = snapshot["tabs"]
        live_ids = {tab["tab_id"] for tab in tabs}
        state = {key: value for key, value in state.items() if key in live_ids}
        created = created_tabs(event, tabs)

        for tab in tabs:
            tab_id, label = tab["tab_id"], tab["label"]
            desired = workspaces[tab["workspace_id"]]
            if tab_id not in state:
                if created.get(tab_id) == label or (args.adopt_matching and label == desired):
                    state[tab_id] = label
                else:
                    continue
            if state[tab_id] is None:
                continue
            if state[tab_id] != label:
                state[tab_id] = None
                print(f"Preserving manual name: {tab_id} = {label}")
                continue
            if label == desired:
                continue

            # Recheck just before mutation so a manual rename since the snapshot wins.
            current = herdr("tab", "get", tab_id)["tab"]
            if current["label"] != label:
                state[tab_id] = None
                continue
            herdr("tab", "rename", tab_id, desired)
            state[tab_id] = desired
            save(path, state)
            print(f"Named {tab_id}: {label} -> {desired}")

        save(path, state)


if __name__ == "__main__":
    main()
