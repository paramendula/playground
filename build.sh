#!/bin/bash
mkdir -p out &&

gcc -Wall src/make-options.c -o out/make-options &&

nasm -f bin src/bootloader.asm -o out/bootloader.bin &&
nasm -f bin src/loader.asm -o out/loader.bin &&
nasm -f bin src/kernel.asm -o out/kernel.bin &&

kernel_size=$(stat -c%s out/kernel.bin) &&

echo "kernels weighs: $kernel_size bytes" &&

sectors=$(( (kernel_size + 511) / 512 )) &&
excess=$(( kernel_size % 512 )) &&

if [ $excess -ne 0 ]; then
    padding=$(( 512 - excess ))
    dd if=/dev/zero bs=1 count=$padding >> out/kernel.bin
fi &&

./out/make-options $sectors out/options.bin &&

dd if=/dev/zero of=out/disk.img bs=512 count=2880 &&
dd if=out/bootloader.bin of=out/disk.img conv=notrunc &&
dd if=out/options.bin of=out/disk.img bs=512 seek=1 conv=notrunc &&
dd if=out/loader.bin of=out/disk.img bs=512 seek=2 conv=notrunc &&
dd if=out/kernel.bin of=out/disk.img bs=512 seek=3 conv=notrunc
