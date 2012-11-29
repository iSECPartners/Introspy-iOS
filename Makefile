include theos/makefiles/common.mk

TWEAK_NAME = introspy
introspy_FILES = Tweak.xm ArgParser.m IntrospyPlistSerialization.m

introspy_FRAMEWORKS = UIKit, Foundation
include $(THEOS_MAKE_PATH)/tweak.mk
