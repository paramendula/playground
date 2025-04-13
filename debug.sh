#!/bin/bash
qemu-system-x86_64 -s -S -drive format=raw,file=out/disk.img,if=floppy -boot a
