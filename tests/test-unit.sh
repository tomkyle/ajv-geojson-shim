#!/usr/bin/env bash
#
# Unit tests for ajv-geojson-shim
#

set -uo pipefail

# Setup test environment
SCRIPT_DIR="$(dirname "$(dirname "$0")")"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/bin/ajv-geojson-shim"

TESTS_DIR="$(dirname "$0")"
FIXTURES_DIR="${TESTS_DIR}/fixtures"
# shellcheck disable=SC1091
source "${TESTS_DIR}/test-helpers.sh"


# Test: arg_replacement with non-geojson file
test_arg_replacement_normal_json() {
	local fixture result

	fixture="${FIXTURES_DIR}/test.json"
	result=$(replace_file_arg "${fixture}")
	assert "Plain JSON file argument should be returned unchanged" "${result}" "${fixture}"
}

# Test: arg_replacement with geojson file
test_arg_replacement_geojson() {
	local fixture result content expected

	fixture="${FIXTURES_DIR}/valid.geojson"
	result=$(replace_file_arg "${fixture}")
	assert "GeoJSON file should be converted to a temporary JSON file that exists" "[ -f \"${result}\" ]" 0
	assert "GeoJSON file should be converted to a different file" "[ \"${result}\" != \"${fixture}\" ]" 0
	assert "Converted file should have .json extension" "[ \"${result##*.}\" = \"json\" ]" 0

	# Check content of the converted file
	content=$(cat "${result}")
	expected=$(cat "${fixture}")
	assert "Converted file should have the same content as the original GeoJSON file" "${content}" "${expected}"
}

# Test: process_arguments with mixed file types
test_process_arguments() {
	local fixture args processed

	fixture="${FIXTURES_DIR}/test.json"
	fixture_geojson="${FIXTURES_DIR}/valid.geojson"
	args=("validate" "-s" "${fixture}" "${fixture_geojson}")
	IFS=" " read -r -a processed <<< "$(process_arguments "${args[@]}")"

	assert "Processed arguments should have the same count as original arguments" "${#processed[@]}" "${#args[@]}"
	assert "Command argument should be unchanged" "${processed[0]}" "${args[0]}"
	assert "Option flag should be unchanged" "${processed[1]}" "${args[1]}"
	assert "JSON file path should be unchanged" "${processed[2]}" "${args[2]}"
	assert "GeoJSON file should be replaced with a temp file" "[ -f \"${processed[3]}\" ]" 0
}

# Test: cleanup function
test_cleanup() {
	# Create some temp files and add them to TEMP_FILES
	local tempfile1 tempfile2

	tempfile1=$(mktemp /tmp/ajv.XXXXXX)
	tempfile2=$(mktemp /tmp/ajv.XXXXXX)

	# Call ajv-geojson-shims’ cleanup:
	# Inject the temp files into its TEMP_FILES
	# shellcheck disable=SC2034
	TEMP_FILES=("${tempfile1}" "${tempfile2}")
	cleanup

	assert "First temporary file should be deleted" "[ ! -f \"${tempfile1}\" ]" 0
	assert "Second temporary file should be deleted" "[ ! -f \"${tempfile2}\" ]" 0
}


# Run tests

echo "=== Unit Tests ==="

check_requirements

test_arg_replacement_normal_json
test_arg_replacement_geojson
test_process_arguments
test_cleanup

echo "=== Unit Tests Complete ==="

report
result=$?
exit $result

