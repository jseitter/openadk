# This file is part of the OpenADK project. OpenADK is copyrighted
# material, please see the LICENCE file in the top-level directory.

include $(ADK_TOPDIR)/rules.mk

PKG_NAME:=		nginx
PKG_VERSION:=		1.12.0
PKG_RELEASE:=		1
PKG_HASH:=		b4222e26fdb620a8d3c3a3a8b955e08b713672e1bc5198d1e4f462308a795b30
PKG_DESCR:=		powerful http reverse proxy and webserver
PKG_SECTION:=		net/http
PKG_BUILDDEP:=		pcre zlib
PKG_DEPENDS:=		libpcre zlib
PKG_NEEDS:=		threads
PKG_URL:=		http://nginx.org/
PKG_SITES:=		http://nginx.org/download/

DISTFILES:=		$(PKG_NAME)-$(PKG_VERSION).tar.gz

PKG_CHOICES_NGINX:=	WITH_LIBRESSL WITHOUT_SSL
PKGCD_WITH_LIBRESSL:=	use libressl for crypto
PKGCB_WITH_LIBRESSL:=	libressl
PKGCS_WITH_LIBRESSL:=	libressl ca-certificates
PKGCD_WITHOUT_SSL:=	use no ssl

include $(ADK_TOPDIR)/mk/package.mk

$(eval $(call PKG_template,NGINX,nginx,$(PKG_VERSION)-$(PKG_RELEASE),$(PKG_DEPENDS),$(PKG_DESCR),$(PKG_SECTION)))

TARGET_CFLAGS+=         -fPIC

CONFIG_STYLE:=          minimal
CONFIGURE_ENV+=		ngx_force_gcc_have_atomic=yes \
			ngx_force_have_libatomic=no
CONFIGURE_ARGS:=        --prefix=/srv/www \
			--sbin-path=/usr/sbin \
			--crossbuild=Linux::$(ADK_TARGET_ARCH) \
			--with-cc='$(TARGET_CC)' \
                        --with-cc-opt='$(TARGET_CPPFLAGS) $(TARGET_CFLAGS)' \
                        --with-ld-opt='$(TARGET_LDFLAGS)' \
			--conf-path=/etc/nginx/nginx.conf \
                        --error-log-path=/var/log/nginx-error.log \
                        --pid-path=/var/run/nginx.pid \
                        --lock-path=/var/lock/nginx.lock \
                        --http-log-path=/var/log/nginx-access.log \
                        --http-client-body-temp-path=/var/lib/nginx/body \
                        --http-proxy-temp-path=/var/lib/nginx/proxy \
                        --http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
			--http-scgi-temp-path=/var/lib/nginx/uwsgi \
			--http-uwsgi-temp-path=/var/lib/nginx/uwsgi

ifeq ($(ADK_PACKAGE_NGINX_WITH_LIBRESSL),y)
CONFIGURE_ARGS+=	--with-http_ssl_module
endif

ALL_TARGET:=		

nginx-install:
	$(INSTALL_DIR) $(IDIR_NGINX)/usr/sbin $(IDIR_NGINX)/etc/nginx
	$(INSTALL_BIN) $(WRKINST)/usr/sbin/nginx \
		$(IDIR_NGINX)/usr/sbin
	for f in nginx.conf mime.types fastcgi_params koi-utf koi-win win-utf; do \
		cp ./files/$${f} \
		$(IDIR_NGINX)/etc/nginx ; \
	done
	$(INSTALL_DIR) $(IDIR_NGINX)/srv/www

include $(ADK_TOPDIR)/mk/pkg-bottom.mk
