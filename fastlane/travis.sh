#!/bin/bash

if [ "$TRAVIS_BRANCH" = "develop" ]; then
  fastlane testflight
elif [ "$TRAVIS_BRANCH" = "master" ]; then
  fastlane appstore
else
  # fastlane test
  fastlane deploy_testflight
fi

if [[ "$TRAVIS_BRANCH" == "develop" ]]; then
  fastlane beta
fi

exit $?
