"""Generate a PEP 739 build-details.json for the conda Windows layout.

Uses upstream's PC/layout generator (which does not need to run the target
interpreter, so it also works when cross-compiling) and adjusts the paths
for conda's unix-like Windows layout, where the file is installed into the
stdlib directory (%PREFIX%\\lib\\python) just like on unix.

Usage: python generate_build_details_win.py SRC_DIR OUTPUT_FILE
"""

import json
import os
import sys
import types


def main():
    src_dir, output = sys.argv[1:3]

    # Make PC/layout/support/constants.py read the version from the sources
    # rather than from the running interpreter.
    os.environ["PYTHONINCLUDE"] = os.path.join(src_dir, "Include")
    sys.path.insert(0, os.path.join(src_dir, "PC", "layout"))
    from support.builddetails import get_builddetails

    arch = {
        "win-64": "amd64",
        "win-32": "win32",
        "win-arm64": "arm64",
    }[os.environ["target_platform"]]

    ns = types.SimpleNamespace(
        include_builddetails_json=True,
        include_freethreaded=os.environ.get("PY_FREETHREADING") == "yes",
        debug=os.environ.get("PY_INTERP_DEBUG") == "yes",
        include_dev=True,
        arch=arch,
    )
    ((_, (_, content)),) = list(get_builddetails(ns))
    details = json.loads(content)

    # The file lives in %PREFIX%\lib\python; all other paths are relative
    # to base_prefix.
    details["base_prefix"] = "../.."
    # build_base.bat always installs python.exe (copied for debug and
    # free-threaded builds), whereas e.g. python_d.exe is not always there.
    details["base_interpreter"] = "./python.exe"
    for key in ("dynamic", "dynamic_stableabi"):
        details["libpython"][key] = "./" + details["libpython"][key]
    details["c_api"]["headers"] = "./include/python"

    with open(output, "w", encoding="utf-8") as f:
        json.dump(details, f, indent=2)
        f.write("\n")


if __name__ == "__main__":
    main()
