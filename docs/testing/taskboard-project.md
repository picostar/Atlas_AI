# Runnable Taskboard project

Create a disposable project under your test root. This Python standard-library CLI has no network or package dependency. Its generated task data belongs in archive and must not overwrite another trial.

Create scripts/taskboard.py and scripts/smoke-taskboard.py with the following contents. These examples are documentation; the kit's manifest does not install or require these executable files.

## Application

~~~python
"""Persistent task list used by Atlas compatibility trials."""
import argparse
import json
import pathlib
import sys


def load(path):
    if not path.exists():
        return []
    rows = json.loads(path.read_text(encoding="utf-8"))
    if not isinstance(rows, list):
        raise ValueError("task store must be a JSON list")
    seen = set()
    for row in rows:
        if not isinstance(row, dict):
            raise ValueError("invalid task record")
        task_id = row.get("id")
        title = row.get("title")
        completed = row.get("completed", False)
        if (type(task_id) is not int or task_id < 1 or task_id in seen
                or not isinstance(title, str) or not title.strip()
                or type(completed) is not bool):
            raise ValueError("invalid task record")
        seen.add(task_id)
        row["completed"] = completed
    return rows


def save(path, rows):
    path.parent.mkdir(parents=True, exist_ok=True)
    pending = path.with_suffix(path.suffix + ".tmp")
    pending.write_text(json.dumps(rows, indent=2) + "\n", encoding="utf-8")
    pending.replace(path)


def main():
    parser = argparse.ArgumentParser(description="Local task list")
    parser.add_argument("--store", type=pathlib.Path, required=True)
    actions = parser.add_subparsers(dest="action", required=True)
    add = actions.add_parser("add")
    add.add_argument("title")
    listing = actions.add_parser("list")
    listing.add_argument("--open", action="store_true", dest="open_only")
    complete = actions.add_parser("complete")
    complete.add_argument("id", type=int)
    args = parser.parse_args()
    try:
        rows = load(args.store)
        if args.action == "add":
            title = args.title.strip()
            if not title:
                raise ValueError("title must not be empty")
            row = {"id": max((r["id"] for r in rows), default=0) + 1,
                   "title": title, "completed": False}
            rows.append(row)
            save(args.store, rows)
            result = row
        elif args.action == "complete":
            row = next((r for r in rows if r["id"] == args.id), None)
            if row is None:
                raise ValueError("task not found: " + str(args.id))
            row["completed"] = True
            save(args.store, rows)
            result = row
        else:
            result = [r for r in rows if not r["completed"]] if args.open_only else rows
        print(json.dumps(result))
        return 0
    except (OSError, ValueError, KeyError, TypeError) as exc:
        print(str(exc), file=sys.stderr)
        return 2


if __name__ == "__main__":
    sys.exit(main())
~~~

## Black-box smoketest

~~~python
"""Black-box smoke test with isolated data and process-level assertions."""
import json
import pathlib
import subprocess
import sys
import tempfile

APP = pathlib.Path(__file__).with_name("taskboard.py")


def call(store, *args, expected=0):
    result = subprocess.run(
        [sys.executable, str(APP), "--store", str(store), *args],
        capture_output=True, text=True
    )
    if result.returncode != expected:
        raise AssertionError((args, result.returncode, result.stdout, result.stderr))
    return json.loads(result.stdout) if result.returncode == 0 else result.stderr


with tempfile.TemporaryDirectory(prefix="atlas-taskboard-") as tmp:
    store = pathlib.Path(tmp) / "tasks.json"
    assert call(store, "list", "--open") == []
    first = call(store, "add", "Review Atlas")
    second = call(store, "add", "Verify persistence")
    assert first == {"id": 1, "title": "Review Atlas", "completed": False}
    assert second["id"] == 2
    assert call(store, "list") == [first, second]
    before = store.read_bytes()
    assert "empty" in call(store, "add", "   ", expected=2)
    assert store.read_bytes() == before
    assert "not found" in call(store, "complete", "999", expected=2)
    assert store.read_bytes() == before
    done = call(store, "complete", "1")
    assert done["completed"] is True
    assert call(store, "list", "--open") == [second]
    assert len(call(store, "list")) == 2
    assert call(store, "complete", "1") == done
    store.write_text('[{"id":41,"title":"Legacy task"}]', encoding="utf-8")
    assert call(store, "list", "--open")[0]["completed"] is False
    added = call(store, "add", "After migration")
    assert added["id"] == 42
    call(store, "complete", "41")
    assert call(store, "list", "--open") == [added]
    assert call(store, "list")[0]["title"] == "Legacy task"
    for invalid in ["invalid json", "{}", '[{"id":1,"title":"x","completed":"yes"}]']:
        store.write_text(invalid, encoding="utf-8")
        before = store.read_bytes()
        call(store, "add", "Must not overwrite bad data", expected=2)
        assert store.read_bytes() == before
print("PASS: add/list, completion/filter, persistence, idempotency, legacy migration, invalid-input data preservation")
~~~

## Run

~~~text
python scripts/smoke-taskboard.py
python scripts/taskboard.py --store archive/tasks.json add "Review Atlas"
python scripts/taskboard.py --store archive/tasks.json list
~~~

The smoketest prints PASS and exits zero. It uses temporary data, tests invalid operations without data loss, and verifies legacy rows without a completed field. Follow [the UAT guide](uat.md) for completion and filtering behavior.

For an adoption experiment, preserve a baseline app revision before the representative DT. A minimal earlier revision can provide add/list only; the DT then adds completion and the open-only filter. Record the actual before/after revisions and outputs. The [recorded baseline](baseline-2026-10-30.md) used that sequence.

Keep the project's own docs/agile records outside the reusable kit. The current installer has a separate questionnaire and root-preservation contract; read it before choosing an installed trial. Do not report that installer as tested from this project recipe alone.
