[TOC]

# Env

Project Runtime:

|title|description|
|-----|-----------|
|jdk|1.8.+|
|gradle|5.4.1|
|Android Studio|3.5.2|
|com.android.tools.build:gradle|3.5.2|
|androidx-v7|1.0.2|
|compile SDK version|29|
|build tools version|29.0.2|
|target SDK version|29|
|min SDK version|19|

## Less Runtime

- Android API 29
- Android Studio 3.5.2
- Gradle 5.4.1
- com.android.tools.build:gradle:3.5.2
- minSdkVersion 19
- androidx-v7 1.0.2

test Runtime see `package.gradle` test_implement


# Last Version Info

- version 0.0.1
- repo at

provides :
- ~~Full method count 00~~

# Depends

load by `root build.gradle`

```
apply from: rootProject.file("package.gradle")
```

and all depend see in `$project_root/package.gradle`

use by

```gradle
dependencies{
    // in app
    implementation depends.butterknife
    // in moudle
    api depends_com_android_support.appcompat_7
}
```

# Build

```bash
# see help
make help

# init proejct
make init
# check depends
make appDependencesDebugCompile
# run appInDebug
make appRunDebug
```

### License

see [LICENSE.txt](LICENSE.txt)
