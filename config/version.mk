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

ANDROID_VERSION = v12.1
WANNABEVERSION = v1.0
WANNABE_BUILD_TYPE := UNOFFICIAL
WANNABE_BUILD_ZIP_TYPE := VANILLA
WANNABEVERNAME := emptiness

WANNABE_DATE_YEAR := $(shell date -u +%Y)
WANNABE_DATE_MONTH := $(shell date -u +%m)
WANNABE_DATE_DAY := $(shell date -u +%d)
WANNABE_DATE_HOUR := $(shell date -u +%H)
WANNABE_DATE_MINUTE := $(shell date -u +%M)
WANNABE_BUILD_DATE := $(WANNABE_DATE_YEAR)$(WANNABE_DATE_MONTH)$(WANNABE_DATE_DAY)-$(WANNABE_DATE_HOUR)$(WANNABE_DATE_MINUTE)
TARGET_PRODUCT_SHORT := $(subst wannabe_,,$(WANNABE_BUILD))

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

ifeq ($(WANNABE_ALPHA), true)
      IS_ALPHA=true
      WANNABE_BUILD_TYPE := ALPHA
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

WANNABE_VERSION := $(WANNABEVERSION)-$(WANNABE_BUILD)-$(WANNABE_BUILD_DATE)-$(WANNABE_BUILD_TYPE)
WANNABE_DISPLAY_VERSION := $(WANNABEVERSION)-$(WANNABEVERNAME)
WANNABE_MOD_VERSION := $(ANDROID_VERSION)-$(WANNABEVERSION)-$(WANNABEVERNAME)
WANNABE_DISPLAY_BUILDTYPE := $(WANNABE_BUILD_TYPE)
WANNABE_FINGERPRINT := WannabeOS/$(ANDROID_VERSION)/$(TARGET_PRODUCT_SHORT)/$(WANNABE_BUILD_DATE)

# Wannabe System Version
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
  ro.WANNABE.version=$(WANNABE_DISPLAY_VERSION) \
  ro.WANNABE.build.status=$(WANNABE_BUILD_TYPE) \
  ro.modversion=$(ANDROID_VERSION) \
  ro.WANNABE.build.date=$(WANNABE_BUILD_DATE) \
  ro.WANNABE.buildtype=$(WANNABE_BUILD_TYPE) \
  ro.WANNABE.fingerprint=$(WANNABE_FINGERPRINT) \
  ro.WANNABE.device=$(WANNABE_BUILD) \
  org.WANNABE.version=$(WANNABEVERSION) \
  ro.WANNABE.maintainer=$(WANNABE_MAINTAINER) 