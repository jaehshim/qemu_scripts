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
