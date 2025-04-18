#!/usr/bin/env bash
#
# Helper functions for unit and integration tests
#

TESTS_RETURN_CODE=0

# Check if ajv is available
check_requirements() {
  if ! command -v ajv &>/dev/null && ! (command -v npx &>/dev/null && npx ajv --help &>/dev/null); then
    echo "⚠️ WARNING: No ajv command found. Make sure ajv-cli or @jirutka/ajv-cli is installed, either globally or locally."
    echo "  Tests will be skipped."
    exit 0
  fi
}


# Helper function to print test status
assert() {
  local name=$1
  local actual=$2
  local expected=$3

  # Handle bracketed expressions by evaluating them
  if [[ "$actual" == "["* ]]; then
    # It's a bracketed expression, evaluate it
    if eval "$actual"; then
      local result=0
    else
      local result=1
    fi

    if [ "$result" -eq "$expected" ]; then
      echo "✅ PASS: ${name}"
      return 0
    else
      echo "❌ FAIL: ${name} (expected: ${expected}, got: ${result})"
	  TESTS_RETURN_CODE=1
      return 1
    fi

  # If the parameters are numeric, do a numeric comparison
  elif [[ "$actual" =~ ^[0-9]+$ ]] && [[ "$expected" =~ ^[0-9]+$ ]]; then
    if [ "$actual" -eq "$expected" ]; then
      echo "✅ PASS: ${name}"
      return 0
    else
      echo "❌ FAIL: ${name} (expected: ${expected}, got: ${actual})"
	  TESTS_RETURN_CODE=1
      return 1
    fi

  # Else do a string comparison
  else
    if [ "$actual" = "$expected" ]; then
      echo "✅ PASS: ${name}"
      return 0
    else
      echo "❌ FAIL: ${name} (expected: ${expected}, got: ${actual})"
	  TESTS_RETURN_CODE=1
      return 1
    fi
  fi
}


report() {
	echo;
	if [ "$TESTS_RETURN_CODE" -eq 0 ]; then
		echo "✅ All tests passed."
	else
		echo "❌ Some tests failed."
	fi

	return $TESTS_RETURN_CODE
}
