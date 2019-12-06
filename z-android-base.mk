# check env set ANDROID_HOME
checkEnvAndroidHome:
ifndef ANDROID_HOME
	@ echo Environment variable ANDROID_HOME is not set
	exit 1
endif

# init this project
init: checkEnvAndroidHome
	./gradlew clean buildEnvironment

cleanRoot:
	./gradlew clean

# module module_shell_name
cleanGradleBuildAndIdea:
	./gradlew clean cleanBuildCache cleanIdea

cleanBuildCatch:
	@if [ -d ./.gradle ]; then rm -rf ./.gradle; fi
	@if [ -d ./buildCache ]; then rm -rf ./buildCache; fi
	@if [ -d ./buildCacheDir ]; then rm -rf ./buildCacheDir; fi
	@echo "clean .gradle buildCache buildCacheDir"

cleanAll: cleanGradleBuildAndIdea cleanBuildCatch
	@echo "clean all build !"

adbCrash: checkEnvAndroidHome
	adb shell dumpsys dropbox --print data_app_crash

helpAndroidBase:
	@echo "=> z-android-base.mk : android base task"
	@echo "make init -> init this project for check base build error"
	@echo "make cleanRoot -> run clean"
	@echo "make cleanGradleBuildAndIdea -> run clean cleanBuildCache cleanIdea"
	@echo "make cleanAll -> run clean all"
	@echo "make adbCrash ~> show last crash info"
	@echo ""