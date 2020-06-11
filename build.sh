#!/bin/zsh

# Get stable release version

STABLE_VERS=$(curl -s https://omahaproxy.appspot.com/all\?csv\=1 | grep "mac,stable" | cut -d, -f3,3)

# Get tools & setup
git config --global core.precomposeUnicode true
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
export PATH="$PATH:`pwd`/depot_tools"

# Get code from tags
mkdir chromium && cd chromium
fetch chromium
cd src/
git checkout -b my_$STABLE_VERS tags/$STABLE_VERS
gclient sync --with_branch_heads --with_tags

# Set args & build
gn gen out/Default --args='enable_nacl=false'
gn gen out/Default
cat ../../args.gn > out/Default/args.gn
autoninja -C out/Default chrome