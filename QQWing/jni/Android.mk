LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

# Here we give our module a name, which will be used to generate the .so file
LOCAL_MODULE    := qqwing

# List all the C++ source files that need to be compiled. If QQWing consists of
# multiple .cpp files, list all of them here, separated by a whitespace
LOCAL_SRC_FILES := qqwing.cpp

# If there are any include directories that ndk-build needs to know about, list them here
LOCAL_C_INCLUDES := $(LOCAL_PATH)/include

# Here we add any flags for the C++ compiler. Enable C++11, exceptions and extra warnings
LOCAL_CPPFLAGS += -std=c++11 -Wall -fexceptions

# Specify libraries that your module will need to be linked against. 
# For instance, if you're using logging, you'll need to link against the log library
LOCAL_LDLIBS    := -llog

# Finally, include the build shared library macro, which tells ndk-build that this
# module will be built as a shared library (.so file)
include $(BUILD_SHARED_LIBRARY)

