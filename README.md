# Ogoron Run Action

Run generated or project tests with Ogoron on Linux runners.

Current scope:
- `ubuntu-*` runners only
- Linux release assets only

## Required environment

Provide secrets via workflow `env`, not action inputs.

- `OGORON_REPO_TOKEN`
- `OGORON_LLM_API_KEY` when BYOK access is required

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
