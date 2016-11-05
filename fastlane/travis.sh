#!/bin/bash

if [ "${TRAVIS_BRANCH}" = "develop" ]; then
    fastlane ios report_test_coverage
else
    fastlane test
fi
exit $?
