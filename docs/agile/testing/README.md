# Regression Suite and Test Harness

This directory is a placeholder for a future test harness. On its own, this README is not a harness, and its presence does not mean the project keeps a regression suite.

## Terms

- Smoke test: a quick, repeatable check that one task's change works. It lives in the task's `Smoketest:` section, often with a script under `scripts/`.
- Regression suite: the accumulated checks for features built earlier, re-run to catch regressions, which are breaks in behavior that used to work.
- Test harness: the runner plus the list of what it covers, which runs the regression suite in one command.

## When the Suite Runs

The `regressionSuite` setting in `.atlas/setup.json` decides when the full suite runs: `every-task`, `pre-merge`, which is the default, or `on-demand`. See Regression Suite Rules in `ATLAS.md` for what each value means, the commands that change it, and the mode line that shows it.

Per-task smoke tests still prove each task's change. Under `pre-merge` and `on-demand`, a task closes on its own checks, and the full suite runs at the gates the setting names.

## Adding a Harness

Create a harness when cross-feature checks become worth running as one set. This directory then typically contains:

- A runner script or command, for example `run-harness.sh` or a test suite invocation
- A coverage list naming what is covered, how to run each part, and the expected pass signal
- A `reports/` folder for run logs and test output, usually gitignored

When a harness exists, add each task's new checks to it. Until then, leave this README unchanged during routine tasks; replace it only when the user asks to set up a harness. Delete this directory if the project keeps no harness and its smoke tests live under `scripts/`.
