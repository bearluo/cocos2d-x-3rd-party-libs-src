# ZLIB
ZLIB_VERSION := 1.2.8
ZLIB_URL := http://zlib.net/fossils/zlib-$(ZLIB_VERSION).tar.gz


ifeq ($(shell uname),Darwin) # zlib tries to use libtool on Darwin
ifdef HAVE_CROSS_COMPILE
ZLIB_CONFIG_VARS=CHOST=$(HOST)
endif
endif

ifdef HAVE_TIZEN
EX_ECFLAGS = -fPIC
endif

ifdef HAVE_LINUX
EX_ECFLAGS = -fPIC
endif

ifdef HAVE_MACOSX
# Fix compatibility with Xcode 16.4+ and macOS SDK 15.5+
# Disable C23 strict checks for deprecated function prototypes
EX_ECFLAGS = -Wno-deprecated-non-prototype -Wno-error=deprecated-non-prototype
endif

ifdef HAVE_WIN32
extra_makefile=-fwin32/Makefile.gcc
endif

$(TARBALLS)/zlib-$(ZLIB_VERSION).tar.gz:
	$(call download,$(ZLIB_URL))

.sum-zlib: zlib-$(ZLIB_VERSION).tar.gz

zlib: zlib-$(ZLIB_VERSION).tar.gz .sum-zlib
	$(UNPACK)
ifdef HAVE_MACOSX
	$(APPLY) $(SRC)/zlib/macos-fdopen-fix.patch
endif
	$(MOVE)

.zlib: zlib
ifndef HAVE_WIN32
	cd $< && $(HOSTVARS) $(ZLIB_CONFIG_VARS) CFLAGS="$(CFLAGS) $(EX_ECFLAGS)" ./configure --prefix=$(PREFIX) --static
	cd $< && $(MAKE) install
endif
ifdef HAVE_WIN32
	cd $< && make -fwin32/Makefile.gcc BINARY_PATH=$(PREFIX)/bin INCLUDE_PATH=$(PREFIX)/include LIBRARY_PATH=$(PREFIX)/lib install
endif
	touch $@
