## About this project

I wanted to go deep into how [eBPF](https://www.kernel.org/doc/html/v5.17/bpf/instruction-set.html) works to the bones.
I need that because I want to make Solana Programs, and they run on fork of eBPF, [sBPF](https://github.com/anza-xyz/sbpf).

Doing things on lowest level helps me internalize how things are going on bare metal, and I made this little project

## Explanation of code
Let's look at the first line:

```
    .section socket,"",@progbits
```

What are these arguments:
- `socket` - eBPF programs can be attached at different points in the kernel and will be called like a function ([eBPF docs](https://docs.ebpf.io/linux/)). That's why we specify the type via "socket". Program types: https://docs.ebpf.io/linux/program-type/. Linking of socket to `BPF_PROG_TYPE_SOCKET_FILTER`
- `""` - The second argument currently set to "" is optional flags argument specified here: https://sourceware.org/binutils/docs/as/Section.html. In regular Linux programs it tells to a regular program loader how to set up memory (A - alloc, X - executable, W - writeable)
- `@progbits` - The last element is section type, it is used to mark whether we have initialized data or not (`@progbits` for cases where we have actual program data in section). Reference: https://sourceware.org/binutils/docs/as/Section.html

```
    .type start,@function
```

We need to declare type of start label, without marking it as function ELF will skip it: https://github.com/libbpf/libbpf/blob/master/src/libbpf.c#L920

```
    .global start

start:
    r0 = 0
    exit
```

So we connect our eBPF program to kernel events of sockets, and we filter every of them by setting `r0` to 0:

```
    .size start, .-start
```

We declare the size of start function explicitly, because ELF will check it here: https://github.com/libbpf/libbpf/blob/master/src/libbpf.c#L923

## Prerequisites
Basically we need:
- `clang`
- `llvm`
- `bpftool`

You can try this command that will install everything in a bulk:
```sh
sudo apt install clang llvm libbpf-dev libelf-dev linux-tools-common linux-headers-generic
```


## Build
I set up basic `Makefile` for build:
```sh
make
```

## Running
To attach the process under the name `myprog`:
```sh
sudo bpftool prog load build/main.o /sys/fs/bpf/myprog type socket
```

To see it in the list programs:
```sh
sudo bpftool prog list
```

To remove:
```sh
sudo rm /sys/fs/bpf/myprog
```

## Nice to have (VS Code extension)
I made a custom `spriteday.ebpf-assembly` VS Code extension, it should be published at this point at [Open VSX](https://open-vsx.org/extension/spriteday/ebpf-assembly), but if it's unavailable you should be able to find installable release at https://github.com/SpriteDay/vscode-ebpf-assembly