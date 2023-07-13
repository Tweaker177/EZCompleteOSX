export TARGET := macosx:clang:latest:10.14
#CFLAGS = -fobjc-arc
export FINALPACKAGE = 1
DEBUG = 0
include $(THEOS)/makefiles/common.mk

TOOL_NAME = EZCompleteOSX

EZCompleteOSX_FILES = OpenAIKeyManager.m EZCompleteOSX.m
EZCompleteOSX_FRAMEWORKS = Foundation AVFoundation AppKit
EZCompleteOSX_CFLAGS += -fobjc-arc  -Wno-error -Wno-deprecated-declarations -Wno-error=unguarded-availability
EZCompleteOSX_LDFLAGS +=  -Wno-error  -Wno-deprecated-declarations
EZCompleteOSX_INSTALL_PATH = /usr/local/bin

include $(THEOS_MAKE_PATH)/tool.mk

after-install::
	install.exec "killall Terminal"
include $(THEOS_MAKE_PATH)/aggregate.mk
