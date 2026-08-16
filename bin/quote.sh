#!/bin/bash
for _ in $(seq 1 50); do
    q="$(fortune -s)"
    n="$(printf '%s\n' "$q" | grep -cv '^[[:space:]]*$')"
    if [ "$n" -le 1 ]; then
        printf '%s\n' "$q"
        exit 0
    fi
done
fortune -s
