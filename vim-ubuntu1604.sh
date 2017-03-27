#!/bin/bash

apt remove --purge vim vim-runtime vim-gnome vim-tiny vim-common vim-gui-common
apt update
apt build-dep vim-gnome
apt install -y build-essential liblua5.3-0 liblua5.3-dev python-dev ruby-dev \
  libperl-dev libncurses5-dev libgnome2-dev libgnomeui-dev libgtk2.0-dev \
  libatk1.0-dev libbonoboui2-dev libcairo2-dev libx11-dev libxpm-dev libxt-dev
rm -rf /usr/local/share/vim /usr/bin/vim /usr/local/bin/vim
mkdir /usr/include/lua5.3/{include,lib}
cp /usr/include/lua5.3/*.h /usr/include/lua5.3/include/
ln -sf /usr/lib/x86_64-linux-gnu/liblua5.3.so /usr/include/lua5.3/lib/liblua.so
ln -sf /usr/lib/x86_64-linux-gnu/liblua5.3.a /usr/include/lua5.3/lib/liblua.a
cd /tmp
git clone https://github.com/vim/vim.git
cd vim
repo_tag=${VIM_TAG:-$(git describe --abbrev=0 --tags --match "v[0-9]*" origin)}
git checkout "${repo_tag}"
make distclean
./configure --with-features=huge \
            --enable-rubyinterp \
            --enable-largefile \
            --disable-netbeans \
            --enable-python3interp \
            --with-python-config-dir=$(python3-config --configdir) \
            --enable-perlinterp \
            --enable-luainterp \
            --enable-gui=auto \
            --enable-fail-if-missing \
            --with-lua-prefix=/usr/include/lua5.3 \
            --enable-cscope \
            --enable-multibyte

make && make install
