#!/usr/bin/env bash
set -euo pipefail

runtime_dir="$(dirname "${OGORON_BIN}")"
export PATH="${runtime_dir}:${PATH}"

selected=0
if [[ "${INPUT_UNIT_TESTS:-true}" == "true" ]]; then
  selected=1
fi
if [[ "${INPUT_UI_TESTS:-true}" == "true" ]]; then
  selected=1
fi

if [[ "${selected}" -ne 1 ]]; then
  echo "At least one of unit-tests or ui-tests must be true." >&2
  exit 2
fi

if [[ "${INPUT_UNIT_TESTS:-true}" == "true" ]]; then
  log_file="$(mktemp)"
  unit_cmd=(ogoron run tests)
  if [[ "${INPUT_PROJECT:-false}" == "true" ]]; then
    unit_cmd+=(--project)
  fi

  if "${unit_cmd[@]}" 2>&1 | tee "${log_file}"; then
    :
  elif grep -Eq "No generated unit tests directory was found\\.|No generated unit test batches were found\\.|No generated unit test files were found" "${log_file}"; then
    echo "Skipping unit tests: no generated unit tests are available yet."
  else
    exit 1
  fi
fi

if [[ "${INPUT_UI_TESTS:-true}" == "true" ]]; then
  generated_root=".ogoron/tests/tests/ui/generated"
  if [[ -d .ogoron/tests && -f .ogoron/tests/.venv/bin/python ]] && find "${generated_root}" -type f -name 'test_*.py' | grep -q .; then
    ui_cmd=(ogoron run ui-tests)
    if [[ -n "${INPUT_UI_TARGET:-}" ]]; then
      ui_cmd+=(--target "${INPUT_UI_TARGET}")
    fi
    "${ui_cmd[@]}"
  else
    echo "Skipping UI tests: no generated UI tests are available yet."
  fi
fi
