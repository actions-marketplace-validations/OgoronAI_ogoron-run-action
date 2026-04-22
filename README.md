# Ogoron Run Action

Run generated or project tests with Ogoron on Linux runners.

Current scope:
- `ubuntu-*` runners only
- Linux release assets only

## Required environment

Provide secrets via workflow `env`, not action inputs.

- `OGORON_REPO_TOKEN`
- `OGORON_LLM_API_KEY` when BYOK access is required

Get your Ogoron repository token in the product UI:

- https://app.ogoron.ai/

## Inputs

| Input | Required | Default | Description |
| --- | --- | --- | --- |
| `unit-tests` | no | `true` | Run `ogoron run tests`. |
| `ui-tests` | no | `true` | Run `ogoron run ui-tests` when generated UI tests are available. |
| `project` | no | `false` | Add `--project` to `ogoron run tests`. |
| `ui-target` | no | `""` | Optional path inside `.ogoron/tests/tests/ui/generated`. |
| `working-directory` | no | `.` | Repository directory where commands should run. |
| `cli-version` | no | `5.2.0` | Ogoron CLI release version to download. Versions older than `5.2.0` are rejected. |
| `download-url` | no |  | Explicit Linux bundle URL override. |

## Outputs

| Output | Description |
| --- | --- |
| `ogoron-bin` | Absolute path to the downloaded Ogoron executable. |

## Notes

- If generated unit tests do not exist yet, the unit test phase is treated as a skip instead of a failure.
- If generated UI tests do not exist yet, the UI test phase is treated as a skip instead of a failure.
- This action does not prepare the UI workspace or cache `.ogoron/tests/.venv` for you. Keep that logic in the surrounding workflow.

## Related actions

- [`Ogoron Setup`](https://github.com/OgoronAI/ogoron-setup-action) to bootstrap the repository before CI usage
- [`Ogoron Generate`](https://github.com/OgoronAI/ogoron-generate-action) to create artifacts that `run` will execute
- [`Ogoron Heal`](https://github.com/OgoronAI/ogoron-heal-action) to repair failing generated or project tests
- [`Ogoron Exec`](https://github.com/OgoronAI/ogoron-exec-action) for custom execution workflows

## Recommended flow

1. Run `setup` once and merge the bootstrap PR.
2. Use `generate` to create or refresh test artifacts.
3. Use `run` in CI for routine execution.
4. If failures require repository changes, use `heal`.
