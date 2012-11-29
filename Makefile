include theos/makefiles/common.mk

TWEAK_NAME = introspy
introspy_FILES = Tweak.xm CallTracer.m IntrospyPlistSerialization.m

introspy_FRAMEWORKS = UIKit, Foundation
include $(THEOS_MAKE_PATH)/tweak.mk
