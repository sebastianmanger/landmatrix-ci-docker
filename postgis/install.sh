#!/bin/sh
# source: https://bitbucket.org/lontongcorp/docker-postgis/

# match versions on live hosting
export VERSION="9.6.2"
export POSTGIS="2.3.2"
export PROJ="4.9.3"
export GDAL="2.1.3"

export PACKAGES="curl make g++ linux-headers git automake autoconf libxml2-dev json-c-dev libtool"
export REQUIRED="su-exec libstdc++ libxml2 json-c"

cd /tmp

apk add --no-cache ${REQUIRED} ${PACKAGES}

cd /tmp

curl -o postgresql-${VERSION}.tar.bz2 -sSL https://ftp.postgresql.org/pub/source/v${VERSION}/postgresql-${VERSION}.tar.bz2
curl -o postgresql-${VERSION}.tar.bz2.sha256 -sSL https://ftp.postgresql.org/pub/source/v${VERSION}/postgresql-${VERSION}.tar.bz2.sha256
sha256sum -c postgresql-${VERSION}.tar.bz2.sha256
tar -jxf postgresql-${VERSION}.tar.bz2
cd postgresql-${VERSION}
./configure --prefix=/usr --disable-debug --without-zlib --without-readline
make && make install-strip
cd contrib
make && make install-strip

cd /tmp

curl -o proj-${PROJ}.tar.gz -sSL http://download.osgeo.org/proj/proj-${PROJ}.tar.gz
tar -zxf proj-${PROJ}.tar.gz
cd proj-${PROJ}
./configure --prefix=/usr --disable-static --without-mutex --without-jni
make && make install && ldconfig

cd /tmp

git clone --depth 1 -b svn-3.5 https://github.com/libgeos/libgeos
cd libgeos
./autogen.sh
ldconfig
./configure --prefix=/usr --disable-static --disable-cassert --disable-glibcxx-debug --disable-python --disable-ruby
make && make install && ldconfig

cd /tmp

curl -o gdal-${GDAL}.tar.xz -sSL http://download.osgeo.org/gdal/${GDAL}/gdal-${GDAL}.tar.xz
tar -xf gdal-${GDAL}.tar.xz
cd gdal-${GDAL}
./configure --prefix=/usr --without-grib --without-mrf --without-pam --without-libtool --without-perl --without-java --without-python \
            --without-pcidsk --without-libz --without-qhull --without-curl --without-png --without-gif --without-jpeg --without-jpeg12 \
            --without-pcre --without-sqlite3 --without-libkml --without-pg --without-pcraster --without-xml2 --disable-static
make && make install && ldconfig

cd /tmp

curl -o postgis-${POSTGIS}.tar.gz -sSL http://download.osgeo.org/postgis/source/postgis-${POSTGIS}.tar.gz
tar -zxf postgis-${POSTGIS}.tar.gz
cd postgis-${POSTGIS}
./configure --with-geosconfig=/usr/bin/geos-config
make && make install

cd /tmp

apk del ${GEOS_DEV} ${PACKAGES}

cd /usr/bin
rm -rf /usr/share/doc /usr/share/man /usr/share/gdal /tmp/* /etc/ssl /usr/include /var/cache/apk/*

rm -f /install
