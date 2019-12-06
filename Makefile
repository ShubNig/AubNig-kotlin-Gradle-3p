.PHONY: dist test build

include z-android-base.mk
include z-moudle-app.mk

help: helpAndroidBase helpModuleApp
	@echo "more task see makefile!"
