@echo off
"C:\\Users\\BISMA SAEED\\AppData\\Local\\Android\\sdk\\cmake\\3.22.1\\bin\\cmake.exe" ^
  "-HC:\\Users\\BISMA SAEED\\Downloads\\flutter_windows_3.29.0-stable\\flutter\\packages\\flutter_tools\\gradle\\src\\main\\groovy" ^
  "-DCMAKE_SYSTEM_NAME=Android" ^
  "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON" ^
  "-DCMAKE_SYSTEM_VERSION=21" ^
  "-DANDROID_PLATFORM=android-21" ^
  "-DANDROID_ABI=x86" ^
  "-DCMAKE_ANDROID_ARCH_ABI=x86" ^
  "-DANDROID_NDK=C:\\Users\\BISMA SAEED\\AppData\\Local\\Android\\sdk\\ndk\\25.1.8937393" ^
  "-DCMAKE_ANDROID_NDK=C:\\Users\\BISMA SAEED\\AppData\\Local\\Android\\sdk\\ndk\\25.1.8937393" ^
  "-DCMAKE_TOOLCHAIN_FILE=C:\\Users\\BISMA SAEED\\AppData\\Local\\Android\\sdk\\ndk\\25.1.8937393\\build\\cmake\\android.toolchain.cmake" ^
  "-DCMAKE_MAKE_PROGRAM=C:\\Users\\BISMA SAEED\\AppData\\Local\\Android\\sdk\\cmake\\3.22.1\\bin\\ninja.exe" ^
  "-DCMAKE_LIBRARY_OUTPUT_DIRECTORY=C:\\Users\\BISMA SAEED\\Desktop\\flutter\\event_planner_app\\android\\app\\build\\intermediates\\cxx\\Debug\\1a5j6e2m\\obj\\x86" ^
  "-DCMAKE_RUNTIME_OUTPUT_DIRECTORY=C:\\Users\\BISMA SAEED\\Desktop\\flutter\\event_planner_app\\android\\app\\build\\intermediates\\cxx\\Debug\\1a5j6e2m\\obj\\x86" ^
  "-DCMAKE_BUILD_TYPE=Debug" ^
  "-BC:\\Users\\BISMA SAEED\\Desktop\\flutter\\event_planner_app\\android\\app\\.cxx\\Debug\\1a5j6e2m\\x86" ^
  -GNinja ^
  -Wno-dev ^
  --no-warn-unused-cli
