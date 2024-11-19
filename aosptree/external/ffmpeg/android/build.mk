#
# Copyright (C) 2013-2017 The Android-x86 Open Source Project
# Copyright (C) 2023 KonstaKANG
#
# Licensed under the GNU General Public License Version 2 or later.
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.gnu.org/licenses/gpl.html
#

FFDROID_DIR := $(FFMPEG_DIR)/android

include $(CLEAR_VARS)

$(foreach V,$(FF_VARS),$(eval $(call RESET,$(V))))

include $(FFDROID_DIR)/config.mak
include $(LOCAL_PATH)/Makefile $(wildcard $(LOCAL_PATH)/$(FFMPEG_ARCH)/Makefile)
include $(FFMPEG_DIR)/ffbuild/arch.mak

# remove duplicate objects
OBJS := $(sort $(OBJS) $(OBJS-yes))

ALL_S_FILES := $(subst $(LOCAL_PATH)/,,$(wildcard $(LOCAL_PATH)/$(FFMPEG_ARCH)/*.S))

ifneq ($(ALL_S_FILES),)
S_OBJS := $(ALL_S_FILES:%.S=%.o)
C_OBJS := $(filter-out $(S_OBJS),$(OBJS))
S_OBJS := $(filter $(S_OBJS),$(OBJS))
else
C_OBJS := $(OBJS)
S_OBJS :=
endif

C_FILES := $(C_OBJS:%.o=%.c)
S_FILES := $(S_OBJS:%.o=%.S)

LOCAL_MODULE := lib$(NAME)
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_TARGET_ARCH := $(TARGET_ARCH)
LOCAL_VENDOR_MODULE := true

LOCAL_SRC_FILES := \
    $(C_FILES) \
    $(S_FILES)

LOCAL_C_INCLUDES := \
    $(FFDROID_DIR)/include \
    $(FFMPEG_DIR)

LOCAL_EXPORT_C_INCLUDE_DIRS := $(LOCAL_C_INCLUDES)

# Base flags
LOCAL_CFLAGS := \
    -DHAVE_AV_CONFIG_H -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -DPIC \
    -O3 -std=c99 -fno-math-errno -fno-signed-zeros -fomit-frame-pointer -fPIC

# Warnings disabled by FFMPEG
LOCAL_CFLAGS += \
    -Wno-parentheses -Wno-switch -Wno-format-zero-length -Wno-pointer-sign \
    -Wno-unused-const-variable -Wno-bool-operation -Wno-deprecated-declarations \
    -Wno-unused-variable

# Additional flags required for AOSP/clang
LOCAL_CFLAGS += \
    -Wno-unused-parameter -Wno-missing-field-initializers \
    -Wno-incompatible-pointer-types-discards-qualifiers -Wno-sometimes-uninitialized \
    -Wno-unneeded-internal-declaration -Wno-initializer-overrides -Wno-string-plus-int \
    -Wno-absolute-value -Wno-constant-conversion \
    -Wno-unknown-attributes -Wno-inline-asm \
    -Wno-enum-conversion

LOCAL_LDFLAGS := -Wl,-Bsymbolic

LOCAL_SHARED_LIBRARIES := $($(NAME)_FFLIBS:%=lib%)
