#TARGET = iphone:6.1

# Comment out the following line if using Xcode 4
ARCHS = armv7 

include theos/makefiles/common.mk

# Xcode 5 got rid of GCC and forces the use of Clang 
# Clang complains about unused arguments
# Most likely a bug in Theos, silence these warnings for now
ADDITIONAL_CCFLAGS  = -Qunused-arguments

TWEAK_NAME = introspy
introspy_FILES = Tweak.xmi CallTracer.m hooks/CommonDigestHooks.m hooks/LibCHooks.m hooks/KeychainHooks.m hooks/DelegateProxies.m PlistObjectConverter.m hooks/CommonKeyDerivationHooks.m CallStackInspector.m SQLiteStorage.m hooks/SecurityHooks.m hooks/CommonCryptorHooks.m hooks/CommonHMACHooks.m
introspy_LIBRARIES = sqlite3 

introspy_FRAMEWORKS = UIKit, Foundation, Security
include $(THEOS_MAKE_PATH)/tweak.mk
