#!/bin/bash

# set -e

## -- be a good citizen and let the user know about sudo
echo "This script requires superuser access to install software."
echo "You will be prompted for your password by sudo."

# -- clear any previous sudo permission
sudo -k

## -- lua
(cd /tmp ;
  curl -O http://www.lua.org/ftp/lua-5.2.3.tar.gz ;
  tar zxvf lua-5.2.3.tar.gz ;

  (cd lua-5.2.3 && make linux && sudo make install)
)

## -- lsocket
(cd /tmp ;
  curl -O http://www.tset.de/downloads/lsocket-1.1-1.tar.gz ;
  tar zxvf lsocket-1.1-1.tar.gz ;

  (cd lsocket-1.1-1 && make all INCDIRS=-I../lua-5.2.3/src/ &&
    sudo mkdir -p /usr/local/lib/lua/5.2 &&
    sudo mv lsocket.so /usr/local/lib/lua/5.2)
)

## -- md5
(cd /tmp ;
  curl -O http://www.tecgraf.puc-rio.br/~lhf/ftp/lua/5.2/lmd5.tar.gz ;
  tar zxvf lmd5.tar.gz ;

  (cd md5 && make G=-fPIC LUA=../lua-5.2.3 md4 md5 sha1 sha224 sha256 sha384 sha512 ripemd160 &&
    sudo mkdir -p /usr/local/lib/lua/5.2 &&
    sudo mv md4.so md5.so sha1.so sha224.so sha256.so sha384.so sha512.so ripemd160.so /usr/local/lib/lua/5.2)
)

## -- base64
(cd /tmp;
  curl -O http://www.tecgraf.puc-rio.br/~lhf/ftp/lua/5.2/lbase64.tar.gz ;
  tar zxvf lbase64.tar.gz ;

  (cd base64 && make G=-fPIC LUA=../lua-5.2.3 &&
    sudo mkdir -p /usr/local/lib/lua/5.2 &&
    sudo mv base64.so /usr/local/lib/lua/5.2)
)

## -- luuid
sudo apt-get install uuid-dev

(cd /tmp;
  curl -O http://www.tecgraf.puc-rio.br/~lhf/ftp/lua/5.2/luuid.tar.gz ;
  tar zxvf luuid.tar.gz ;

  (cd uuid && make G=-fPIC LUA=../lua-5.2.3 &&
    sudo mkdir -p /usr/local/lib/lua/5.2 &&
    sudo mv uuid.so /usr/local/lib/lua/5.2)
)

## -- lua-cmsgpack

(cd /tmp;
  rm -rf lua-cmsgpack ;
  git clone git://github.com/antirez/lua-cmsgpack.git ;
  cd lua-cmsgpack ;

  gcc -O2 -fPIC -I../lua-5.2.3/src -c lua_cmsgpack.c -o lua_cmsgpack.o ;
  gcc -shared -o cmsgpack.so lua_cmsgpack.o ;

  sudo mv cmsgpack.so /usr/local/lib/lua/5.2
)

## -- pac
(cd /tmp;
  rm -rf pac;
  git clone git://github.com/soveran/pac.git ;
  cd pac && sudo install bin/pac* /usr/local/bin
)

## -- pac extensions
(cd /tmp;
  curl -O https://gist.githubusercontent.com/cyx/f7e37007e0c5063ea636/raw/67c47bafdfc4728a1e1a0a2ca9be5bfee2107841/pac-ls ;
  curl -O https://gist.githubusercontent.com/cyx/f7e37007e0c5063ea636/raw/4981aa4bc2b4e074dd80d0b59b405ff4de82dd53/pac-show ;
  curl -O https://gist.githubusercontent.com/frodsan/9308807/raw/3e92799048082fa8d2b46b27e80e9a78f30cfec8/pac-add ;

  sudo install pac-{ls,show,add} /usr/local/bin
)

# -- cleanup
rm -rf /tmp/lua*
rm -rf /tmp/lsocket*
rm -rf /tmp/lua-cmsgpack*
rm -rf /tmp/pac*
