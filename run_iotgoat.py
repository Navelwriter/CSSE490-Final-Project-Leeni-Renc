#!/usr/bin/env python3

from pandare import Panda

#Get directory of this file
import os
dir_path = os.path.dirname(os.path.realpath(__file__))

ARCH="arm"
MEM="1G"
IMAGE=f"{dir_path}/iotgoat_modified.squashfs"
KERNEL=f"{dir_path}/kernel/openwrt-18.06.2-armvirt-32-zImage"
INITRD=f"{dir_path}/kernel/openwrt-18.06.2-armvirt-32-zImage-initramfs"

qemu_args = [
    '-M', 'virt',
    '-kernel', KERNEL,
    '-device',
    'virtio-blk-pci,drive=drive-virtio-disk0,id=virtio-disk0,bootindex=0',
    '-drive', 'file=%s,format=raw,if=none,id=drive-virtio-disk0' % IMAGE,
    '-append', 'root=/dev/vda rootfstype=squashfs console=ttyAMA0,115200',
    '-initrd', INITRD,
    '-display', 'none',
    '-serial', 'mon:stdio',
    '-netdev',
    'user,id=net0,hostfwd=tcp::4433-:443,hostfwd=tcp::2222-:22',
    '-device' ,'virtio-net-device,netdev=net0',
    '-no-reboot',
]

panda = Panda(ARCH, mem=MEM, os="linux", extra_args=qemu_args)#qcow=IMAGE ?
try:
    panda.run()
except KeyboardInterrupt:
    print("Got Ctrl-C, exiting")
finally:
    panda.panda_finish()
