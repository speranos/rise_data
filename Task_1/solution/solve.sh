#!/bin/bash
# (the gold patch from the SWE-bench dataset).
set -e
cd /testbed
git apply /solution/fix.patch
