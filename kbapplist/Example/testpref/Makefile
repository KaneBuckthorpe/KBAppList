include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = testpref
testpref_FILES = KBTRootListController.m
testpref_INSTALL_PATH = /Library/PreferenceBundles
testpref_FRAMEWORKS = UIKit
testpref_PRIVATE_FRAMEWORKS = Preferences
testpref_EXTRA_FRAMEWORKS += KBAppList

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/testpref.plist$(ECHO_END)
