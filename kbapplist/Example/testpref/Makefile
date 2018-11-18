export ARCHS=arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = testpref
testpref_FILES = Tweak.xm

testpref_EXTRA_FRAMEWORKS = KBAppList
testpref_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += testpref
include $(THEOS_MAKE_PATH)/aggregate.mk
