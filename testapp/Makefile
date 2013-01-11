#TARGET = iphone:5.1
#ARCHS = armv6
include theos/makefiles/common.mk

APPLICATION_NAME = IntrospyTestApp
IntrospyTestApp_FILES = main.m IntrospyTestAppApplication.mm RootViewController.mm FileSystemTester.m KeyChainTester.m UserPreferencesTester.m CryptoTester.m UIPasteboardTester.m NSURLConnectionTester.m
IntrospyTestApp_FRAMEWORKS = UIKit CoreGraphics Security

include $(THEOS_MAKE_PATH)/application.mk
