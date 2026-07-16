#!/bin/bash
# Verifier for rise/swe-bench-django-11099.
# Applies the official SWE-bench test patch (regression tests for the
# trailing-newline bug), runs the auth validator test module, and writes
# the reward: 1 if all tests pass, 0 otherwise.
mkdir -p /logs/verifier

cd /testbed
source /opt/miniconda3/bin/activate testbed

# Reset the tests directory so the agent cannot have tampered with it,
# then add the regression tests the fix must satisfy.
git checkout -- tests/
if ! git apply /tests/test.patch; then
  echo 0 > /logs/verifier/reward.txt
  exit 0
fi

./tests/runtests.py --verbosity 2 --settings=test_sqlite --parallel 1 auth_tests.test_validators

if [ $? -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
