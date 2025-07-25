include $(TOPDIR)/rules.mk
#Based on adb package from AUR https://aur.archlinux.org/packages/adb/ , reused adbMakefile

PKG_NAME:=fastboot
PKG_VERSION:=android.5.0.2_r1
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://android.googlesource.com/platform/system/core
PKG_SOURCE_VERSION:=a3b721a32242006b59cb12bd62c9133632af3a2d
# PKG_SOURCE_SUBDIR specifies where repo is cloned
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_SOURCE_VERSION)
PKG_SOURCE:=$(PKG_SOURCE_SUBDIR).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_SOURCE_SUBDIR)
PKG_MAINTAINER:=Swift Geek <swiftgeek at gmail>

include $(INCLUDE_DIR)/package.mk

ifeq ($(CONFIG_BIG_ENDIAN),y)
TARGET_CFLAGS+= -DHAVE_BIG_ENDIAN=1
beinfo: $(info *** Big endian detected, look for -DHAVE_BIG_ENDIAN=1 ***)
endif
TARGET_CFLAGS+= -D_GNU_SOURCE

define Package/fastboot
	SECTION:=utils
	CATEGORY:=Utilities
	TITLE:=Android Debug Bridge CLI tool
	URL:=http://tools.android.com/
	DEPENDS:=+zlib +libopenssl +libpthread
endef

define Package/bridge/description
	Android Debug Bridge (adb) is a versatile command line tool that lets you communicate with an emulator instance or connected Android-powered device.
endef

# Add Makefile from AUR
define Build/Prepare
	$(call Build/Prepare/Default)
	$(CP) ./adbMakefile $(PKG_BUILD_DIR)/fastboot/Makefile
endef

# Nothing just to be sure
define Build/Configure
endef

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR)/fastboot/ \
		$(TARGET_CONFIGURE_OPTS) \
		TARGET=Linux \
		CFLAGS="$(TARGET_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)"
	$(STRIP) $(PKG_BUILD_DIR)/fastboot/fastboot
endef

define Package/fastboot/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/fastboot/fastboot $(1)/usr/bin/
endef

$(eval $(call BuildPackage,fastboot))