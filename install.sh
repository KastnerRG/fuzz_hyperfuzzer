#!/usr/bin/env bash
set -euo pipefail

TARGET="${1:-all}"

cd verilator
export VERILATOR_ROOT="$PWD"
autoconf
./configure

# Newer bison emits an include for verilog.h. Provide a stable alias.
mkdir -p src/obj_opt src/obj_dbg
ln -sf V3ParseBison.h src/obj_opt/verilog.h
ln -sf V3ParseBison.h src/obj_dbg/verilog.h

make -j"$(nproc)"

cd ../fuzztest/libprop
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --target libprop -j"$(nproc)"

cd ..
make "$TARGET" -j"$(nproc)"
