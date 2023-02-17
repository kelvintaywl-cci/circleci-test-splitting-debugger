#!/usr/bin/env bash

set -eo pipefail

echo "Fetching test data..."
sh scripts/get-testcases.sh

exec "$@"
