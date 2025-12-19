# curl

CURL_VERSION := 7.88.1
CURL_URL :=  http://curl.haxx.se/download/curl-$(CURL_VERSION).tar.gz

$(TARBALLS)/curl-$(CURL_VERSION).tar.gz:
	$(call download,$(CURL_URL))

.sum-curl: curl-$(CURL_VERSION).tar.gz

curl: curl-$(CURL_VERSION).tar.gz .sum-curl
	$(UNPACK)
	$(UPDATE_AUTOCONFIG)
	$(MOVE)

DEPS_curl = zlib $(DEPS_zlib) openssl $(DEPS_openssl)

ifdef HAVE_LINUX
configure_option=--without-libidn --without-librtmp
endif

ifdef HAVE_TVOS
configure_option+=--disable-ntlm-wb
endif

ifdef HAVE_WIN32
# Windows: Enable shared library (DLL) build
# This will generate libcurl.dll and libcurl.dll.a (import library)
# Note: --enable-shared will override --disable-shared from HOSTCONF
configure_option+=--enable-shared
# Optionally disable static build if only DLL is needed
# configure_option+=--disable-static
endif

.curl: curl .zlib .openssl
	$(RECONF)
	cd $< && $(HOSTVARS_PIC) PKG_CONFIG_LIBDIR="$(PREFIX)/lib/pkgconfig" ./configure $(HOSTCONF) \
		--with-ssl=$(PREFIX) \
		--with-zlib \
		--enable-ipv6 \
		--disable-ldap \
		$(configure_option)

	cd $< && $(MAKE) install
	touch $@
