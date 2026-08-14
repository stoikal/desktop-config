#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_ROOT="$(dirname "$SCRIPT_DIR")"

chmod +x "$CONFIG_ROOT/bin"/*.sh "$CONFIG_ROOT/scripts"/*.sh
