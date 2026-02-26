#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

DEFAULT_THREADS="${OMP_NUM_THREADS:-$(nproc)}"
PAR_ENV=(
  "OMP_NUM_THREADS=${DEFAULT_THREADS}"
  "OMP_DYNAMIC=false"
  "OMP_PROC_BIND=true"
  "OMP_PLACES=cores"
)

extract_metrics() {
  local output="$1"
  local median eff
  median="$(printf '%s\n' "$output" | sed -n 's/.*: \([0-9.]*\) microseconds/\1/p' | tail -n1)"
  eff="$(printf '%s\n' "$output" | sed -n 's/.*(\([0-9.]*%\)).*/\1/p' | tail -n1)"
  printf "%s %s" "$median" "$eff"
}

run_tests() {
  gcc -O3 -Iinclude -fopenmp tests/correctness.c src/naive.c src/tiled.c -o tests/correctness
  ./tests/correctness
}

run_benchmarks() {
  local M="${1:-512}" N="${2:-512}" K="${3:-512}"

  local targets=(bench-o0 bench-o2 bench-o3 bench-ofast)
  local labels=("o0" "o2" "o3" "ofast")

  printf "shape=%sx%sx%s parallel_threads=%s\n" "$M" "$N" "$K" "$DEFAULT_THREADS"
  printf "%-7s %-12s %-12s %-12s %-12s %-12s %-12s\n" \
    "build" "naive_us" "naive_eff" "t1_us" "t1_eff" "tpar_us" "tpar_eff"

  for i in "${!targets[@]}"; do
    make -s "${targets[$i]}" >/dev/null

    out_naive="$(./bench/bench "$M" "$N" "$K" naive)"
    read -r naive_us naive_eff <<< "$(extract_metrics "$out_naive")"

    out_t1="$(OMP_NUM_THREADS=1 OMP_DYNAMIC=false ./bench/bench "$M" "$N" "$K" tiled)"
    read -r t1_us t1_eff <<< "$(extract_metrics "$out_t1")"

    out_tpar="$(env "${PAR_ENV[@]}" ./bench/bench "$M" "$N" "$K" tiled)"
    read -r tpar_us tpar_eff <<< "$(extract_metrics "$out_tpar")"

    printf "%-7s %-12s %-12s %-12s %-12s %-12s %-12s\n" \
      "${labels[$i]}" "$naive_us" "$naive_eff" "$t1_us" "$t1_eff" "$tpar_us" "$tpar_eff"
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
