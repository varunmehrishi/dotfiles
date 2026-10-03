#!/usr/bin/env python3
"""Back up or restore portable Logi Options+ settings on macOS."""

import json
import os
import sqlite3
import sys
from pathlib import Path

DB = Path.home() / "Library/Application Support/LogiOptionsPlus/settings.db"
EXPORT = Path(__file__).with_name("settings.json")
PREFERENCES = (
    "battery_notify",
    "disable_backlight_on_load_settings",
    "low_battery_notifications_enabled",
    "options_swap_state_snapshot",
    "optionsplus_mouse_swap_setting_applied",
    "theme",
    "use_system_theme",
)


def read_settings(connection):
    row = connection.execute("SELECT _id, file FROM data ORDER BY _id DESC LIMIT 1").fetchone()
    if row is None:
        raise RuntimeError("Logi Options+ has not initialized its settings database")
    return row[0], json.loads(row[1])


def main():
    if len(sys.argv) != 2 or sys.argv[1] not in ("backup", "restore"):
        raise SystemExit("Usage: python3 sync.py backup|restore")
    if not DB.is_file():
        raise SystemExit(f"Install and launch Logi Options+ first: {DB} is missing")

    with sqlite3.connect(DB, timeout=5) as connection:
        row_id, current = read_settings(connection)
        if sys.argv[1] == "backup":
            keys = ["applications", "profile_keys", "schema_version", *PREFERENCES]
            keys += [key for key in current if key.startswith("profile-")]
            saved = {key: current[key] for key in keys if key in current}
            # App discovery metadata is machine specific; retain app identity and paths.
            for app in saved.get("applications", {}).get("applications", []):
                for key in ("installTime", "lastRunTime", "processId", "isInstalled"):
                    app.pop(key, None)
                for key in ("applicationPath", "applicationPathsList"):
                    if key in app:
                        value = app[key]
                        if isinstance(value, str):
                            app[key] = value.replace(str(Path.home()), "~")
                        elif isinstance(value, list):
                            app[key] = [item.replace(str(Path.home()), "~") if isinstance(item, str) else item for item in value]
            EXPORT.write_text(json.dumps(saved, indent=2, sort_keys=True) + "\n")
            print(f"Saved {EXPORT}")
            return

        saved = json.loads(EXPORT.read_text())
        if saved.get("schema_version") != current.get("schema_version"):
            raise SystemExit("Logi Options+ schema versions differ; update both installations first")
        for app in saved.get("applications", {}).get("applications", []):
            for key in ("applicationPath", "applicationPathsList"):
                if key in app:
                    value = app[key]
                    if isinstance(value, str):
                        app[key] = os.path.expanduser(value)
                    elif isinstance(value, list):
                        app[key] = [os.path.expanduser(item) if isinstance(item, str) else item for item in value]
        saved.pop("schema_version", None)
        with sqlite3.connect(DB.with_suffix(".pre-restore.db")) as previous:
            connection.backup(previous)
        current.update(saved)
        connection.execute("UPDATE data SET file = ? WHERE _id = ?", (json.dumps(current, indent=2), row_id))
        print(f"Restored settings; previous database: {DB.with_suffix('.pre-restore.db')}")


if __name__ == "__main__":
    main()
