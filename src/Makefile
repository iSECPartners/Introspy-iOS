include $(THEOS)/makefiles/common.mk

TWEAK_NAME = introspy
introspy_FILES = Tweak.xm CallTracer.m hooks/CommonDigestHooks.m hooks/LibCHooks.m hooks/KeychainHooks.m hooks/DelegateProxies.m PlistObjectConverter.m hooks/CommonKeyDerivationHooks.m CallStackInspector.m SQLiteStorage.m hooks/SecurityHooks.m hooks/CommonCryptorHooks.m hooks/CommonHMACHooks.m
introspy_LIBRARIES = sqlite3

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
