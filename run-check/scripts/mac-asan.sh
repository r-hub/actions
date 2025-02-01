#! /bin/bash

# Use XCode 16.2 ------------------------------------------------
sudo ln -sf /Applications/Xcode_16.2.app /Applications/Xcode.app

# Compile with sanitizers ---------------------------------------
mkdir -p ~/.R
cat >> ~/.R/Makevars <<EOF
CC+=-mmacos-version-min=15 -fsanitize=address,undefined
CXX+=-mmacos-version-min=15 -fsanitize=address,undefined
CXX11+=-mmacos-version-min=15 -fsanitize=address,undefined
CXX14+=-mmacos-version-min=15 -fsanitize=address,undefined
CXX17+=-mmacos-version-min=15 -fsanitize=address,undefined
CXX20+=-mmacos-version-min=15 -fsanitize=address,undefined
CXX23+=-mmacos-version-min=15 -fsanitize=address,undefined
REC_INSTALL_OPT=--dsym
EOF

# Need to patch the shell script, because these env vars --------
# do not go through a shell because of Apple security.
R=$(which R)
head -1 ${R} >> /tmp/R
cat >> /tmp/R <<EOF
export DYLD_FORCE_FLAT_NAMESPACE=1
export DYLD_INSERT_LIBRARIES=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/clang/16/lib/darwin/libclang_rt.asan_osx_dynamic.dylib
EOF
tail -1 ${R} >> /tmp/R
chmod +x /tmp/R
sudo mv /tmp/R ${R}

# For debugging -------------------------------------------------
echo '#' mac-asan setup -------------------------------------------
echo which R: $(which R)
echo R CMD config CC: $(R CMD config CC)
echo R CMD config CXX: $(R CMD config CXX)
echo R CMD config CXX11: $(R CMD config CXX11)
echo R CMD config CXX14: $(R CMD config CXX14)
echo R CMD config CXX17: $(R CMD config CXX17)
echo R CMD config CXX20: $(R CMD config CXX20)
echo R CMD config CXX23: $(R CMD config CXX23)
echo ------------------------------------------------------------
