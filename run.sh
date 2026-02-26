#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

run_tests() {
  gcc -O3 -Iinclude tests/correctness.c src/naive.c -o tests/correctness
  ./tests/correctness
}

run_benchmarks() {
  local M="${1:-512}" N="${2:-512}" K="${3:-512}"

  local targets=(bench-o0 bench-o2 bench-o3 bench-ofast)
  local labels=("o0" "o2" "o3" "ofast")

  for i in "${!targets[@]}"; do
    make -s "${targets[$i]}" >/dev/null
    output="$(./bench/bench "$M" "$N" "$K" naive)"

    median="$(printf '%s\n' "$output" | sed -n 's/.*: \([0-9.]*\) microseconds/\1/p')"
    eff="$(printf '%s\n' "$output" | sed -n 's/.*(\([0-9.]*%\)).*/\1/p')"

    printf "%s %s %s\n" "${labels[$i]}" "$median" "$eff"
  done
}

run_cmd() {
  case "${1:-}" in
    test) run_tests ;;
    bench) run_benchmarks "${2:-512}" "${3:-512}" "${4:-512}" ;;
    both) run_tests; run_benchmarks "${2:-512}" "${3:-512}" "${4:-512}" ;;
    q|quit|exit) : ;;
    *)
      echo "usage: ./run.sh test|bench [M N K]|both [M N K]|q" >&2
      exit 1
      ;;
  esac
}

run_cmd "$@"
exit 0
