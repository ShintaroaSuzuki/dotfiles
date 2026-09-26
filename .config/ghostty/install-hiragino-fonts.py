# /// script
# requires-python = ">=3.10"
# dependencies = ["fonttools==4.66.0"]
# ///
"""Install local W3/W6 aliases without changing or distributing macOS fonts."""

import io
import json
from pathlib import Path
import subprocess
import sys

from fontTools.ttLib import TTCollection

FAMILY = "Hiragino Sans Ghostty"
FACES = (("HiraginoSans-W3", "Regular", 400), ("HiraginoSans-W6", "Bold", 700))


def main():
    if sys.platform != "darwin":
        raise SystemExit("This installer requires macOS and its bundled Hiragino fonts.")

    discovery = subprocess.run(
        ["swift", "-e", r"""
import CoreText
import Foundation
var paths: [String: String] = [:]
for name in ["HiraginoSans-W3", "HiraginoSans-W6"] {
    let font = CTFontCreateWithName(name as CFString, 12, nil)
    guard CTFontCopyPostScriptName(font) as String == name,
          let url = CTFontCopyAttribute(font, kCTFontURLAttribute) as? URL else {
        fatalError("Required Hiragino face is unavailable: \(name)")
    }
    paths[name] = url.path
}
let data = try JSONSerialization.data(withJSONObject: paths)
print(String(data: data, encoding: .utf8)!)
"""],
        check=True, stdout=subprocess.PIPE, text=True,
    )
    sources = json.loads(discovery.stdout)
    destination = Path.home() / "Library" / "Fonts"
    destination.mkdir(parents=True, exist_ok=True)

    for source_name, style, weight in FACES:
        with TTCollection(sources[source_name]) as collection:
            font = next(f for f in collection.fonts if f["name"].getDebugName(6) == source_name)
            font.recalcTimestamp = False
            postscript = f"HiraginoSansGhostty-{style}"
            names = {
                1: FAMILY, 2: style, 3: postscript, 4: f"{FAMILY} {style}",
                6: postscript, 16: FAMILY, 17: style, 18: f"{FAMILY} {style}",
                21: FAMILY, 22: style,
            }
            table = font["name"]
            table.names = [record for record in table.names if record.nameID not in names]
            for name_id, value in names.items():
                table.setName(value, name_id, 3, 1, 0x409)
                table.setName(value, name_id, 1, 0, 0)

            font["OS/2"].usWeightClass = weight
            font["OS/2"].fsSelection = (font["OS/2"].fsSelection & ~0x60) | (0x20 if style == "Bold" else 0x40)
            font["head"].macStyle = (font["head"].macStyle & ~1) | int(style == "Bold")
            cff = font["CFF "].cff
            cff.fontNames[0] = postscript
            top = cff.topDictIndex[0]
            top.FamilyName = FAMILY
            top.FullName = f"{FAMILY} {style}"
            top.Weight = style

            output = io.BytesIO()
            font.save(output)
            path = destination / f"{postscript}.otf"
            data = output.getvalue()
            if path.exists():
                if path.read_bytes() != data:
                    raise SystemExit(f"Refusing to overwrite a different font: {path}")
            else:
                with path.open("xb") as installed:
                    installed.write(data)
            print(f"{source_name} -> {path}")


if __name__ == "__main__":
    main()
