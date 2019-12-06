# check env set ANDROID_HOME
checkEnvAndroidHome:
ifndef ANDROID_HOME
	@ echo Environment variable ANDROID_HOME is not set
	exit 1
endif

# can change this for moudle package_name and am start info
module_app_name ?= app
module_app_package_name ?= com.sinlov.aubnig.demo.needchange
module_app_am_start_info ?= $(module_app_package_name)/com.sinlov.aubnig.demo.needchange.MainActivity

# do not reset
module_app_build_apk_path ?= $$(pwd)/$(module_app_name)/build/outputs/apk
module_app_build_apk_debug_name ?= $(module_app_name)-debug
module_app_build_apk_debug_apk ?= $(module_app_build_apk_debug_name).apk
module_app_build_apk_debug_path ?= $(module_app_build_apk_path)/debug/$(module_app_build_apk_debug_apk)
module_app_build_apk_release_name ?= $(module_app_name)-release
module_app_build_apk_release_apk ?= $(module_app_build_apk_release_name).apk
module_app_build_apk_release_path ?= $(module_app_build_apk_path)/release/$(module_app_build_apk_release_apk)

# this is set decode info
module_decode_path ?= build/decode
module_decode_abs_path ?= $$(pwd)/$(module_decode_path)
module_decode_zip_abs_path ?= $$(pwd)/build/decode-zip/

# module module_app_name
appCleanGradle:
	./gradlew clean :$(module_app_name):clean :$(module_app_name):cleanBuildCache :$(module_app_name):cleanIdea

appDependencesDebugCompile:
	./gradlew $(module_app_name):dependencies --configuration debugCompileClasspath

appDependencesReleaseCompile:
	./gradlew $(module_app_name):dependencies --configuration releaseCompileClasspath

# module module_app_name build debug apk
appBuildDebug: checkEnvAndroidHome
	./gradlew :$(module_app_name):buildDebug

# module module_app_name install debug apk
appInstallDebug: checkEnvAndroidHome
	./gradlew :$(module_app_name):installDebug

# module module_app_name uninstall debug apk
appUninstallDebug: checkEnvAndroidHome
	./gradlew :$(module_app_name):uninstallDebug

# module module_app_name install release apk
appInstallRelease: checkEnvAndroidHome
	./gradlew :$(module_app_name):installRelease

# module module_app_name uninstall release apk
appUninstallRelease: checkEnvAndroidHome
	./gradlew :$(module_app_name):uninstallRelease

# module module_app_name installDebug and test
appTestDebug: appInstallDebug
	adb shell am start -n $(module_app_am_start_info) -a android.intent.action.MAIN -c android.intent.category.LAUNCHER

# module module_app_name uninstallDebug then installDebug and test
appTestCleanDebug: appUninstallDebug appInstallDebug
	adb shell am start -n $(module_app_am_start_info) -a android.intent.action.MAIN -c android.intent.category.LAUNCHER

# module module_app_name installRelease and test
appTestRelease: appUninstallRelease appInstallRelease
	adb shell am start -n $(module_app_am_start_info) -a android.intent.action.MAIN -c android.intent.category.LAUNCHER

# module module_app_name uninstal then installRelease and test
appTestCleanRelease: appInstallRelease
	adb shell am start -n $(module_app_am_start_info) -a android.intent.action.MAIN -c android.intent.category.LAUNCHER

helpModuleApp:
	@echo "=> project mode test task"
	@echo "make appBuildDebug -> module $(module_app_name) build debug apk"
	@echo "make appInstallDebug -> module $(module_app_name) install debug apk"
	@echo "make appUninstallDebug -> module $(module_app_name) uninstall debug apk"
	@echo "make appInstallRelease -> module $(module_app_name) install release apk"
	@echo "make appUninstallRelease -> module $(module_app_name) uninstall release apk"
	@echo "make appTestDebug -> module $(module_app_name) install debug apk and start it"
	@echo "make appTestCleanDebug -> module $(module_app_name) uninstall debug then install apk and start it"
	@echo "make appTestRelease -> module $(module_app_name) install release apk and start it"
	@echo "make appTestCleanRelease -> module $(module_app_name) uninstall release then install apk and start it"
	@echo ""

appCheckDecodeCatch:
	if [ -d $(module_decode_abs_path) ]; then echo "~> appCheckDecodeCatch pass"; else mkdir -p $(module_decode_abs_path); fi

appCheckDecodeZipCatch:
	if [ -d $(module_decode_zip_abs_path) ]; then echo "~> module_decode_zip_abs_path pass"; else mkdir -p $(module_decode_zip_abs_path); fi

cleanAppDecodeDebug: appCheckDecodeCatch
	if [ -d $(module_decode_abs_path)/$(module_app_build_apk_debug_name) ]; then rm -rf $(module_decode_abs_path)/$(module_app_build_apk_debug_name); fi
	if [ -f $(module_decode_abs_path)/$(module_app_build_apk_debug_apk) ]; then rm -f $(module_decode_abs_path)/$(module_app_build_apk_debug_apk); fi

cleanAppDecodeRelease: appCheckDecodeCatch
	if [ -d $(module_decode_abs_path)/$(module_app_build_apk_release_name) ]; then rm -rf $(module_decode_abs_path)/$(module_app_build_apk_release_name); fi
	if [ -f $(module_decode_abs_path)/$(module_app_build_apk_release_apk) ]; then rm -f $(module_decode_abs_path)/$(module_app_build_apk_release_apk); fi

cleanAppBuildAll: appCleanGradle
	if [ -d ./.gradle ]; then rm -rf ./.gradle; fi
	@echo "clean all build !"

appAssembleRelease: checkEnvAndroidHome
	./gradlew clean :$(module_app_name):assembleRelease

appAssembleDebug: checkEnvAndroidHome
	./gradlew clean :$(module_app_name):assembleDebug

appRunDebug: checkEnvAndroidHome
	./gradlew :$(module_app_name):installDebug
	@echo "run $(module_app_name) with $(module_app_am_start_info)"
	adb shell am start -n $(module_app_am_start_info) -a android.intent.action.MAIN -c android.intent.category.LAUNCHER

appDecodeZipDebug: appAssembleDebug cleanAppDecodeDebug appCheckDecodeZipCatch
	@echo "check $(module_app_build_apk_debug_path)"
	cp $(module_app_build_apk_debug_path) $(module_decode_abs_path)/
	cd $(module_decode_abs_path) && apktool d $(module_app_build_apk_debug_apk)
	@echo "=> Decode path at: $(module_decode_abs_path)/$(module_app_build_apk_debug_name)"


appDecodeZipRelease: appAssembleRelease cleanAppDecodeRelease appCheckDecodeZipCatch
	@echo "check $(module_app_build_apk_release_path)"
	cp $(module_app_build_apk_release_path) $(module_decode_abs_path)/
	cd $(module_decode_abs_path) && apktool d $(module_app_build_apk_release_apk)
	@echo "=> Decode path at: $(module_decode_abs_path)/$(module_app_build_apk_release_name)"

helpDecodeApp:
	@echo "=> z-decode-app.mk : decode app task"
	@echo "make appAssembleDebug ~> make moudle [ $(module_app_name) ] assmeble debug"
	@echo "make appAssembleRelease ~> make moudle [ $(module_app_name) ] assmeble release"
	@echo "make appDecodeZipDebug ~> make moudle [ $(module_app_name) ] into $(module_decode_path)"
	@echo "make appDecodeZipRelease ~> make moudle [ $(module_app_name) ] into $(module_decode_path)"
	@echo ""