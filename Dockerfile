FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip unzip libargon2-1 libaudit1 libbsd0 libbz2-1.0 libc6 libcap-ng0 libcom-err2 libcurl4 libexpat1 libffi6 libfftw3-double3 libfontconfig1 libfreetype6 libgcc1 libgcrypt20 libglib2.0-0 libgmp10 libgnutls30 libgomp1 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu63 libidn2-0 libjemalloc2 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblcms2-2 libldap-2.4-2 liblqr-1-0 libltdl7 liblzma5 libmagickcore-6.q16-6 libmagickwand-6.q16-6 libmcrypt4 libmemcached11 libmemcachedutil2 libncurses6 libnettle6 libnghttp2-14 libp11-kit0 libpam0g libpcre3 libpng16-16 libpq5 libpsl5 libreadline7 librtmp1 libsasl2-2 libsodium23 libsqlite3-0 libssh2-1 libssl1.1 libstdc++6 libsybdb5 libtasn1-6 libtidy5deb1 libtinfo6 libunistring2 libuuid1 libwebp6 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 libxml2 libxslt1.1 libzip4 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "php" "7.3.29-0" --checksum 2f79d3dc37797526549d4a2a264647fc5a973e8b1d76c43e7ec7c89f050aa5c0
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "apache" "2.4.48-0" --checksum 85aa9ec2b419b3e53b5aa8f8e52bb35cddba3a646f204dfaec029e292d250017
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mysql-client" "10.3.30-0" --checksum 47107f86621bb184307e47bbb15244d076575f0e0f7d339f198ef312b6f3f285
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "libphp" "7.3.29-0" --checksum 4d12ca46685c94e8502990d417a466a919d1aa5d9528b29a45df3284686bbbf9
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "render-template" "1.0.0-3" --checksum 8179ad1371c9a7d897fe3b1bf53bbe763f94edafef19acad2498dd48b3674efe
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.13.0-0" --checksum fd7257c2736164d02832dbf72e2c1ed9d875bf3e32f0988520796bc503330129

# Get ocstore
COPY ocStore-3.0.2.0.zip / 
RUN mkdir tmp_ocstore
RUN unzip -qq ocStore-3.0.2.0.zip -d /tmp_ocstore
RUN mv /tmp_ocstore/upload /opt/bitnami/opencart
RUN rm -rf /tmp_ocstore 
# end

RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/mysql-client/postunpack.sh
RUN /opt/bitnami/scripts/apache/postunpack.sh
RUN /opt/bitnami/scripts/php/postunpack.sh
RUN /opt/bitnami/scripts/apache-modphp/postunpack.sh
RUN /opt/bitnami/scripts/opencart/postunpack.sh
ENV ALLOW_EMPTY_PASSWORD="no" \
    APACHE_ENABLE_CUSTOM_PORTS="no" \
    APACHE_HTTPS_PORT_NUMBER="" \
    APACHE_HTTP_PORT_NUMBER="" \
    BITNAMI_APP_NAME="opencart" \
    BITNAMI_IMAGE_VERSION="3.0.3-6-debian-10-r287" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_ROOT_USER="root" \
    MYSQL_CLIENT_CREATE_DATABASE_NAME="" \
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES="ALL" \
    MYSQL_CLIENT_CREATE_DATABASE_USER="" \
    MYSQL_CLIENT_ENABLE_SSL="no" \
    MYSQL_CLIENT_SSL_CA_FILE="" \
    PATH="/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/apache/bin:/opt/bitnami/mysql/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 8080 8443

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/opencart/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/apache/run.sh" ]

RUN sed -i 's/;\[XDebug\]/\[XDebug\]/'						/opt/bitnami/php/etc/php.ini
RUN sed -i 's/;zend_extension = xdebug/zend_extension = xdebug/'		/opt/bitnami/php/etc/php.ini
RUN sed -i 's/;xdebug.mode = debug/xdebug.mode = debug/'			/opt/bitnami/php/etc/php.ini
RUN sed -i 's/;xdebug.client_host = 127.0.0.1/xdebug.client_host = 127.0.0.1/'	/opt/bitnami/php/etc/php.ini
RUN sed -i 's/;xdebug.client_port = 9000/xdebug.client_port = 9000/'		/opt/bitnami/php/etc/php.ini
RUN sed -i 's/;xdebug.output_dir = \/tmp/xdebug.output_dir = \/tmp/'		/opt/bitnami/php/etc/php.ini
RUN sed -i 's/;xdebug.remote_handler = dbgp/xdebug.remote_handler = dbgp/'	/opt/bitnami/php/etc/php.ini
RUN echo 'xdebug.start_with_request = yes'					>> /opt/bitnami/php/etc/php.ini
RUN echo 'xdebug.idekey = VSCODE'						>> /opt/bitnami/php/etc/php.ini
RUN echo 'xdebug.remote_enable = 1'						>> /opt/bitnami/php/etc/php.ini

USER 0
RUN mkdir /.vscode-server
RUN chmod 777 /.vscode-server

ENV SCRIPT_FOLDER=/docker-entrypoint-init.d
RUN mkdir $SCRIPT_FOLDER

ENV SCRIPT_FILE=update-config.sh
COPY ./$SCRIPT_FILE $SCRIPT_FOLDER
RUN chmod 777 $SCRIPT_FOLDER/$SCRIPT_FILE

ENV SCRIPT_FILE=update-admin-config.sh
COPY ./$SCRIPT_FILE $SCRIPT_FOLDER
RUN chmod 777 $SCRIPT_FOLDER/$SCRIPT_FILE

USER 1001