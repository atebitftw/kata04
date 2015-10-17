#!/usr/bin/env bash
set -o xtrace
set -e 

# Ensure that the code is warning free.
dartanalyzer --fatal-warnings test/kata_app_test.dart

# Run tests.
dart test/kata_app_test.dart