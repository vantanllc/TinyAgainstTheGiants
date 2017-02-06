if [ $TRAVIS_BRANCH = "master" ] && [ $TRAVIS_PULL_REQUEST == "false" ]; then
  open -b com.apple.iphonesimulator
  fastlane ios test
  fastlane ios report_test_coverage
else
  #open -b com.apple.iphonesimulator
  #fastlane ios test
  #fastlane ios report_test_coverage
  fastlane ios provision
  fastlane ios build
fi
