#!/usr/bin/env bash

dirs=("src" "tests" "logs" "external" "memory_bank" "memory_bank/design" "memory_bank/specs" "memory_bank/tasks")

for d in "${dirs[@]}"; do
  mkdir -p "$d"
done

echo "Initialized: ${dirs[*]}"
