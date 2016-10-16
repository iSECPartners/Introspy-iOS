#TARGET = iphone:6.1
#ARCHS = armv7
include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = IntrospyTestApp
IntrospyTestApp_FILES = main.m IntrospyTestAppApplication.mm RootViewController.mm XMLTester.m FileSystemTester.m KeyChainTester.m UserPreferencesTester.m CryptoTester.m PasteboardTester.m HTTPTester.m SchemeTester.m
IntrospyTestApp_FRAMEWORKS = UIKit CoreGraphics Security

include $(THEOS_MAKE_PATH)/application.mk
