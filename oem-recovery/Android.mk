ifeq ($(AB_OTA_UPDATER), true)
BUILD_OEM_UPDATER := true
endif

#disable dependency if target uses QMAA
ifeq ($(TARGET_USES_QMAA),true)
ifneq ($(TARGET_USES_QMAA_OVERRIDE_ANDROID_RECOVERY),true)
TARGET_HAS_GENERIC_KERNEL_HEADERS := true
endif
endif

ifneq ($(filter librecovery_updater_msm,$(TARGET_RECOVERY_UPDATER_LIBS)),)
BUILD_OEM_UPDATER := true
endif

ifeq ($(BUILD_OEM_UPDATER), true)

LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE_TAGS := optional
LOCAL_STATIC_LIBRARIES += libedify libotautil libz
LOCAL_C_INCLUDES := bootable/recovery \
                system/core/libion/include \
                system/core/libion/kernel-headers

LOCAL_SRC_FILES := gpt-utils.cpp dec.cpp oem-updater.cpp
LOCAL_CFLAGS := -Wall
LOCAL_NOSANITIZE := cfi
ifeq ($(TARGET_HAS_GENERIC_KERNEL_HEADERS),true)
  LOCAL_CFLAGS += -D_GENERIC_KERNEL_HEADERS
  LOCAL_CFLAGS += -Wno-unused-parameter
else ifeq ($(TARGET_COMPILE_WITH_MSM_KERNEL),true)
  LOCAL_C_INCLUDES += $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr/include
  LOCAL_ADDITIONAL_DEPENDENCIES := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr
endif
LOCAL_SHARED_LIBRARIES += libion
LOCAL_MODULE := librecovery_updater_msm
include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE_TAGS := optional
LOCAL_C_INCLUDES := bootable/recovery \
               system/core/libion/include \
               system/core/libion/kernel-headers

LOCAL_SRC_FILES := gpt-utils.cpp
LOCAL_CFLAGS := -Wall
ifeq ($(TARGET_HAS_GENERIC_KERNEL_HEADERS),true)
  LOCAL_CFLAGS += -D_GENERIC_KERNEL_HEADERS
else ifeq ($(TARGET_COMPILE_WITH_MSM_KERNEL),true)
  LOCAL_C_INCLUDES += $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr/include
  LOCAL_ADDITIONAL_DEPENDENCIES := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr
endif
LOCAL_SHARED_LIBRARIES += liblog libcutils libz libion
LOCAL_MODULE := librecovery_updater_msm
LOCAL_COPY_HEADERS_TO := gpt-utils/inc
LOCAL_COPY_HEADERS := gpt-utils.h
LOCAL_VENDOR_MODULE := true
include $(BUILD_SHARED_LIBRARY)

endif
