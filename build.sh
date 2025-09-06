#!/bin/bash

# variables
SRC_DIR="asm"
OBJ_DIR="obj"
LST_DIR="lst"
OUT_DIR="dos"
ENTRY="_main"
OUT="GAME"

# point at binaries
ASM="/bin/nasm"
LINK="/opt/watcom/binl/wlink"

# https://openwatcom.org/ftp/archive/11.0c/docs/linkeruserguide.pdf

# watcom linker environment variables
TARGET="dos"
export WATCOM="/opt/watcom"
export WLINK_LNK="/opt/watcom/binl/wlink.lnk"

# go find all asm sources
segments=()
while IFS= read -r file; do
    segment=${file#*/}
    segment=${segment%.*}
    segments+=($segment)
done < <(find "$SRC_DIR" -type f -name "*.asm")

# ensure out dirs exist
mkdir -p $OBJ_DIR
mkdir -p $LST_DIR
mkdir -p $OUT_DIR

# assemble all
objects=()
for segment in ${segments[@]}; do
    $ASM -i macro -f obj $SRC_DIR/$segment.asm -l $LST_DIR/$segment.lst -o $OBJ_DIR/$segment.obj
    objects+=($OBJ_DIR/$segment.obj)
done

# link
printf -v all_objects "%s," "${objects[@]}"
$LINK system $TARGET option map=$LST_DIR/$OUT.map,start=_start name $OUT_DIR/$OUT.EXE file $all_objects