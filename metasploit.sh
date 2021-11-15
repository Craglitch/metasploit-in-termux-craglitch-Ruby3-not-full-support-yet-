#!/usr/bin/bash

# Installing ruby3 and requeirment
apt update 
apt upgrade

pkg install -y python autoconf bison clang coreutils curl findutils apr apr-util postgresql openssl readline libffi libgmp libpcap libsqlite libgrpc libtool libxml2 libxslt ncurses make ncurses-utils ncurses git wget unzip zip tar termux-tools termux-elf-cleaner pkg-config git ruby 

python3 -m pip install --upgrade pip
python3 -m pip install requests

# Installing metasploit framework to $PREFIX/share

cd $PREFIX/share
git clone https://github.com/rapid7/metasploit-framework.git --depth=1
cd $PREFIX/share/metasploit-framework

# Installing bundler and nokogiri 1.8.0
sed '/rbnacl/d' -i Gemfile.lock
sed '/rbnacl/d' -i metasploit-framework.gemspec
sed 's|nokogiri (1.*)|nokogiri (1.8.0)|g' -i Gemfile.lock
gem install bundler
gem install nokogiri -v 1.8.0 -- --use-system-libraries
$PREFIX/bin/find -type f -executable -exec termux-fix-shebang \{\} \;
gem install actionpack
bundle update activesupport
bundle update --bundler
bundle install -j$(nproc --all)
$PREFIX/bin/find -type f -executable -exec termux-fix-shebang \{\} \;

# Remove old metasploit install new metasploit to bin
if [ -e $PREFIX/bin/msfconsole ];then
	rm $PREFIX/bin/msfconsole
fi
if [ -e $PREFIX/bin/msfvenom ];then
	rm $PREFIX/bin/msfvenom
fi
# # # # # # # # # # # # # # # # # # # # # # # # # # # #
chmod 777 msfconsole
chmod 777 msfvenom
ln -s $PREFIX/share/metasploit-framework/msfconsole $PREFIX/bin
ln -s $PREFIX/share/metasploit-framework/msfvenom $PREFIX/bin

echo "install success"
