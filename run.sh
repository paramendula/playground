#!/bin/bash
qemu-system-i386 -drive format=raw,file=out/disk.img,if=floppy -boot a
