#!/bin/bash

fastlane test

if [[ "$TRAVIS_BRANCH" == "develop" ]]; then
  fastlane beta
fi

exit $?
