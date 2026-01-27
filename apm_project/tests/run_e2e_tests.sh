#!/usr/bin/env bash
#
# APM E2E Test Runner
# This script runs the E2E test suite for apm.sh
#

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ""
echo "============================================================"
echo "  APM E2E Test Runner (Bash)"
echo "============================================================"
echo ""

# Make test script executable
chmod +x "$SCRIPT_DIR/e2e_tests.sh"

# Run the tests
"$SCRIPT_DIR/e2e_tests.sh" "$@"
exit_code=$?

echo ""
if [[ $exit_code -eq 0 ]]; then
    echo "============================================================"
    echo "  E2E TESTS PASSED"
    echo "============================================================"
else
    echo "============================================================"
    echo "  E2E TESTS FAILED"
    echo "============================================================"
fi

exit $exit_code

