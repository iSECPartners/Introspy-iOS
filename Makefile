include theos/makefiles/common.mk

TWEAK_NAME = introspy
introspy_FILES = Tweak.xm CallTracer.m IntrospyPlistSerialization.m IntrospySQLiteStorage.m
introspy_LIBRARIES = sqlite3

introspy_FRAMEWORKS = UIKit, Foundation
include $(THEOS_MAKE_PATH)/tweak.mk
