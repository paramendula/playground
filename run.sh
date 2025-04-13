#!/bin/bash
qemu-system-x86_64 -drive format=raw,file=out/disk.img,if=floppy -boot a
