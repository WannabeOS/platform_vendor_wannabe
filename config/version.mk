# Copyright (C) 2016 The Pure Nexus Project
# Copyright (C) 2016 The JDCTeam
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

WANNABE_MOD_VERSION = v12.1
WANNABE_BUILD_TYPE := UNOFFICIAL
WANNABE_BUILD_ZIP_TYPE := VANILLA

ifeq ($(WANNABE_BETA),true)
    WANNABE_BUILD_TYPE := BETA
endif

ifeq ($(WANNABE_GAPPS), true)
    $(call inherit-product, vendor/gapps/common/common-vendor.mk)
    WANNABE_BUILD_ZIP_TYPE := GAPPS
endif

CURRENT_DEVICE=$(shell echo "$(TARGET_PRODUCT)" | cut -d'_' -f 2,3)

ifeq ($(WANNABE_OFFICIAL), true)
   LIST = $(shell cat infrastructure/devices/wannabe.devices | awk '$$1 != "#" { print $$2 }')
    ifeq ($(filter $(CURRENT_DEVICE), $(LIST)), $(CURRENT_DEVICE))
      IS_OFFICIAL=true
      WANNABE_BUILD_TYPE := OFFICIAL

PRODUCT_PACKAGES += \
    Updater

    endif
    ifneq ($(IS_OFFICIAL), true)
       WANNABE_BUILD_TYPE := UNOFFICIAL
       $(error Device is not official "$(CURRENT_DEVICE)")
    endif
endif

ifeq ($(WANNABE_COMMUNITY), true)
   LIST = $(shell cat infrastructure/devices/wannabe-community.devices | awk '$$1 != "#" { print $$2 }')
    ifeq ($(filter $(CURRENT_DEVICE), $(LIST)), $(CURRENT_DEVICE))
      IS_COMMUNITY=true
      WANNABE_BUILD_TYPE := COMMUNITY
    endif
    ifneq ($(IS_COMMUNITY), true)
       WANNABE_BUILD_TYPE := UNOFFICIAL
       $(error This isn't a community device "$(CURRENT_DEVICE)")
    endif
endif

WANNABE_VERSION := Wannabe-$(WANNABE_MOD_VERSION)-$(CURRENT_DEVICE)-$(WANNABE_BUILD_TYPE)-$(shell date -u +%Y%m%d)-$(WANNABE_BUILD_ZIP_TYPE)

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
  ro.wannabe.version=$(WANNABE_VERSION) \
  ro.wannabe.releasetype=$(WANNABE_BUILD_TYPE) \
  ro.wannabe.ziptype=$(WANNABE_BUILD_ZIP_TYPE) \
  ro.modversion=$(WANNABE_MOD_VERSION)

WANNABE_DISPLAY_VERSION := Wannabe-$(WANNABE_MOD_VERSION)-$(WANNABE_BUILD_TYPE)

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
  ro.wannabe.display.version=$(WANNABE_DISPLAY_VERSION)
