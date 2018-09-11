#!/bin/bash -euvx
# git clone https://github.com/llvm-mirror/llvm llvm
# cd llvm/tools
# git checkout -b llvm-bolt f137ed238db11440f03083b1c88b7ffc0f4af65e
# git clone https://github.com/facebookincubator/BOLT llvm-bolt
# cd ..
# patch -p 1 < tools/llvm-bolt/llvm.patch
# 
# cd ..
# mkdir build
cd build
cmake -G Ninja ../llvm
ninja
