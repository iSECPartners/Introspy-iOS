#TARGET = iphone:5.1
#ARCHS = armv6
include theos/makefiles/common.mk

TWEAK_NAME = introspy
introspy_FILES = Tweak.xmi CallTracer.m IntrospySQLiteStorage.m hooks/KeyChainHooks.m hooks/CCCryptorHooks.m
introspy_LIBRARIES = sqlite3 

introspy_FRAMEWORKS = UIKit, Foundation, Security
include $(THEOS_MAKE_PATH)/tweak.mk
