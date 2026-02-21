#!/usr/bin/env bash

method="$1"

if [[ -z "$method" ]]; then
  echo "Usage: apm_init_structure.sh RAPID|DS"
  exit 1
fi

case "${method^^}" in
  RAPID)
    dirs=("src" "tests" "logs" "memory bank")
    ;;
  DS)
    dirs=("src" "experiments" "eda" "models" "logs" "memory bank" "data/raw" "data/processed" "data/external")
    ;;
  *)
    echo "Unknown methodology: $method"
    echo "Usage: apm_init_structure.sh RAPID|DS"
    exit 1
    ;;
esac

for d in "${dirs[@]}"; do
  mkdir -p "$d"
done

echo "Initialized: ${dirs[*]}"
