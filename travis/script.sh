if [ $TRAVIS_BRANCH = "production-release" ] && [ $TRAVIS_PULL_REQUEST == "false" ]; then
  open -b com.apple.iphonesimulator
  fastlane ios test
  fastlane ios report_test_coverage
  fastlane ios build
  fastlane ios deliver
  fastlane ios beta
else
  #open -b com.apple.iphonesimulator
  #fastlane ios test
  #fastlane ios report_test_coverage
  fastlane ios build
  fastlane ios deliver
  fastlane ios beta
fi
