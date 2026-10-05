#!/usr/bin/env python3
"""Detect automatic workspace label changes that have no Herdr plugin event."""

import argparse
import fcntl
import hashlib
import json
import os
from pathlib import Path
import socket
import subprocess
import sys
import time


SYNC = Path(__file__).with_name("sync.py")
INTERVAL_SECONDS = 1


def synchronize(adopt_matching=False):
    command = [sys.executable, str(SYNC)]
    if adopt_matching:
        command.append("--adopt-matching")
    subprocess.run(command, check=True, timeout=60)


def request(socket_path, method):
    # Ordinary Herdr API calls close the connection after one response.
    with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as connection:
        connection.settimeout(15)
        connection.connect(socket_path)
        message = {"id": "workspace-tab-names", "method": method, "params": {}}
        connection.sendall((json.dumps(message) + "\n").encode())
        with connection.makefile("rb") as reader:
            response = json.loads(reader.readline())
    if "error" in response:
        raise RuntimeError(response["error"])
    return response["result"]


def server_alive(pid):
    try:
        os.kill(pid, 0)
    except ProcessLookupError:
        return False
    return True


def watch(socket_path, lock_path, server_pid):
    with lock_path.open("a") as lock:
        try:
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError:
            return
        initial = os.stat(socket_path)
        identity = (initial.st_dev, initial.st_ino)
        print(f"Watching {socket_path} (server {server_pid})", flush=True)
        previous = None
        while server_alive(server_pid):
            try:
                current = os.stat(socket_path)
            except FileNotFoundError:
                return
            if (current.st_dev, current.st_ino) != identity:
                return
            plugins = request(socket_path, "plugin.list")["plugins"]
            plugin = next(
                (p for p in plugins if p["plugin_id"] == os.environ["HERDR_PLUGIN_ID"]),
                None,
            )
            if plugin is None:
                return
            if plugin["enabled"]:
                workspaces = request(socket_path, "workspace.list")["workspaces"]
                labels = {w["workspace_id"]: w["label"] for w in workspaces}
                if labels != previous:
                    synchronize()
                    previous = labels
            else:
                # Resume automatically when re-enabled, without a server restart.
                previous = None
            time.sleep(INTERVAL_SECONDS)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--adopt-matching", action="store_true")
    parser.add_argument("--worker", type=int, help="Herdr server PID supplied by its hook")
    args = parser.parse_args()
    if os.environ.get("HERDR_ENV") != "1":
        raise RuntimeError("Run through a Herdr plugin hook or action")
    socket_path = os.path.realpath(os.environ["HERDR_SOCKET_PATH"])
    key = hashlib.sha256(socket_path.encode()).hexdigest()
    directory = Path(os.environ["HERDR_PLUGIN_STATE_DIR"])
    if args.worker is not None:
        # Handoff may briefly leave the previous server's watcher alive.
        watch(socket_path, directory / f"{key}.watch-{args.worker}.lock", args.worker)
        return

    synchronize(args.adopt_matching)
    # Plugin hooks exit promptly; the singleton worker follows this server's lifetime.
    with (directory / f"{key}.watch.log").open("a") as log:
        subprocess.Popen(
            [sys.executable, "-u", str(Path(__file__).resolve()), "--worker", str(os.getppid())],
            stdin=subprocess.DEVNULL,
            stdout=log,
            stderr=subprocess.STDOUT,
            start_new_session=True,
        )


if __name__ == "__main__":
    main()
