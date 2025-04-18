#!/usr/bin/env bash
#
# Integration tests for ajv-geojson-shim
#

set -uo pipefail

# Setup test environment
SCRIPT_DIR="$(dirname "$(dirname "$0")")"

TESTS_DIR="$(dirname "$0")"
FIXTURES_DIR="${TESTS_DIR}/fixtures"
# shellcheck disable=SC1091
source "${TESTS_DIR}/test-helpers.sh"



# Test: Valid GeoJSON file
test_valid_geojson() {
	"${SCRIPT_DIR}/bin/ajv-geojson-shim" validate -s "${FIXTURES_DIR}/schema.json" "${FIXTURES_DIR}/valid.geojson" >/dev/null 2>&1
	assert "Validating a valid GeoJSON file should end up with exit code 0" $? 0
}

# Test: Valid JSON file
test_valid_json() {
	"${SCRIPT_DIR}/bin/ajv-geojson-shim" validate -s "${FIXTURES_DIR}/schema.json" "${FIXTURES_DIR}/valid.json" >/dev/null 2>&1
	assert "Validating a valid JSON file should end up with exit code 0" $? 0
}

# Test: Invalid GeoJSON file
test_invalid_geojson() {
	"${SCRIPT_DIR}/bin/ajv-geojson-shim" validate -s "${FIXTURES_DIR}/schema.json" "${FIXTURES_DIR}/invalid.geojson" >/dev/null 2>&1 && true
	assert "Validating an invalid GeoJSON file should fail with exit code 1" $? 1
}

# Test: Invalid JSON file
test_invalid_json() {
	"${SCRIPT_DIR}/bin/ajv-geojson-shim" validate -s "${FIXTURES_DIR}/schema.json" "${FIXTURES_DIR}/invalid.json" >/dev/null 2>&1 && true
	assert "Validating an invalid JSON file should fail with exit code 1" $? 1
}


# Test: Help flag
# shellcheck disable=SC2319 # Readability in test evaluation
test_help_flag() {
	local title="Call with long Help flag (--help) should show usage hints"
	local output actual

	output=$("${SCRIPT_DIR}/bin/ajv-geojson-shim" --help)
	[[ "${output}" == *"Usage:"* ]]
	actual=$?
	assert "${title}" "${actual}" 0

	output=$("${SCRIPT_DIR}/bin/ajv-geojson-shim" -h)
	[[ "${output}" == *"Usage:"* ]]
	actual=$?
	assert "${title}" "${actual}" 0
}

# Test: Version flag
# shellcheck disable=SC2319 # Readability in test evaluation
test_version_flag() {
	local title="Call with long Version flag (--version) should show version number"
	local output actual

	output=$("${SCRIPT_DIR}/bin/ajv-geojson-shim" --version)
	[[ "${output}" == "ajv-geojson-shim version"* ]]
	actual=$?
	assert "${title}" "${actual}" 0

	output=$("${SCRIPT_DIR}/bin/ajv-geojson-shim" -v)
	[[ "${output}" == "ajv-geojson-shim version"* ]]
	actual=$?
	assert "${title}" "${actual}" 0
}

# Test 5: No arguments should show usage
test_call_without_args() {
	local output actual

	output=$("${SCRIPT_DIR}/bin/ajv-geojson-shim")
	[[ "${output}" == *"Usage:"* ]]
	actual=$?
	assert "Call with no arguments should show usage hints" "${actual}" 0
}

# Run the tests
echo "=== Integration Tests ==="

check_requirements

test_call_without_args
test_help_flag
test_version_flag
test_valid_geojson
test_invalid_geojson
test_valid_json
test_invalid_json

echo "=== Integration Tests Complete ==="

report
result=$?
exit $result
