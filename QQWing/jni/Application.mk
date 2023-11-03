# The APP_ABI line specifies for which architectures the code should be compiled.
# 'all' will compile for all default architectures, but if you're targeting specific
# ones, you can list them here like 'armeabi-v7a arm64-v8a'
APP_ABI := all

# This line specifies the minimum Android platform version you want to support.
# The value should match the minSdkVersion in your Godot project's export settings.
APP_PLATFORM := android-21

# The APP_STL line specifies which C++ runtime to use. The NDK supports several
# different ones, but 'c++_shared' or 'c++_static' are the most common choices.
APP_STL := c++_shared

# Enable C++ exceptions, RTTI, etc., if required by the library.
# Uncomment lines below if necessary.
# APP_CPPFLAGS := -frtti -fexceptions

