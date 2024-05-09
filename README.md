# Kernel build
```
$ make defconfig  # Without this, my QEMU couldn't find the root fs
$ make menuconfig
    |-- CONFIG_RANDOMIZE_BASE is not set # if this option is set, GDB cannot find the symbol
      |-- (Processor type and features -> Randomize the address of the kernel image (KASLR))
    |-- CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
      |-- (Kernel hacking -> Compile-time checks and compiler options -> Debug information)
    |-- CONFIG_GDB_SCRIPTS=y
      |-- (Kernel hacking -> Compile-time checks and compiler options -> Provide GDB scripts for kernel debugging)
    |-- CONFIG_KGDB=y
      |-- (Kernel hacking -> Generic Kernel Debugging Instruments -> KGDB: kernel debugger)
    |-- CONFIG_FRAME_POINTER=y 
      |-- (Kernel hacking -> x86 Debugging -> Choose kernel unwinder -> Frame pointer unwinder
$ cd /path/to/qemu_scripts
$ ./build_kernel.sh
```

# Run QEMU
Before running QEMU, add `add-auto-load-safe-path /path/to/linux` to `~/.gdbinit` to use gdb scripts.  
Not sure but you may need to run `make scripts_gdb`
```
# ./run_qemu.sh
(Other window)
# cd /path/to/linux/
# gdb vmlinux
# (gdb) target remote:1234
```

# Connect module
## 1. Kernel module preparation
First, make a virtfs directory.  
```
# mkdir virtio-dir
```

In order to build the module inside QEMU, place your kernel directory in the virtfs directory.
After `build-kernel.sh`, copy `/lib/modules/KERNEL_VERSION` to the virtfs directory and modify the softlink to
```
# cd /path/to/modules
# ln -s ../path/to/linux build
```
Now, place the kernel module directory that you want to debug in the virtfs directory

## 2. QEMU script
Then, add a line to `run-qemu.sh` for virtfs
```
-virtfs local,path=/path/to/virtio-dir,mount_tag=host0,security_model=passthrough,id=host0
```
In QEMU, mount virtfs by `sudo mount -t 9p -o trans=virtio host0 /mnt/host/`.  
Now, virtio-dir is a shared directory between the host and QEMU.


## 3. Build and load kernel module
Now that the virtio-dir is mounted, you can build the kernel module.  
Make sure to modify the KERNELDIR path in your kernel module makefile.  
Also, don't forget to add a debug option when building your module.
```
KERNELDIR := /path/to/virtio-dir/$(shell uname -r)/build
```

## 4. GDB
You must add the symbol table to GDB.  
After loading the kernel module to QEMU, go to `/sys/modules/MODULE_NAME/sections`.  
Then check the following values
```
# cat .text
# cat .bss
# cat .data
```
Using the values, add the symbol table to GDB by
```
(gdb) add-symbol-file /path/to/virtio-dir/MODULE_DIR/MODULE.ko [value from .text] -s .bss [value from .bss] -s .data [value from .data]
```
