## About this project

I wanted to go deep into how [eBPF](https://www.kernel.org/doc/html/v5.17/bpf/instruction-set.html) works to the bones.
I need that because I want to make Solana Programs, and they run on fork of eBPF, [sBPF](https://github.com/anza-xyz/sbpf).

Doing things on lowest level helps me internalize how things are going on bare metal, and I made this little project

## Explanation of code
Let's look at the first line:

```
    .section socket_filter,"",@progbits
```

What are these arguments:
- `socket_filter` - eBPF programs can be attached at different points in the kernel and will be called like a function ([eBPF docs](https://docs.ebpf.io/linux/)). That's why we specify the type via "socket_filter". Program types: https://docs.ebpf.io/linux/program-type/. Linking of socket_filter to BPF_PROG_TYPE_SOCKET_FILTER: https://github.com/libbpf/libbpf/blob/master/src/libbpf.c#L199
- `""` - The second argument currently set to "" is optional flags argument specified here: https://sourceware.org/binutils/docs/as/Section.html. In regular Linux programs it tells to a regular program loader how to set up memory (A - alloc, X - executable, W - writeable)
- `@progbits` - The last element is section type, it is used to mark whether we have initialized data or not (`@progbits` for cases where we have actual program data in section). Reference: https://sourceware.org/binutils/docs/as/Section.html

So we connected our small eBPF program to kernel events of sockets, and we filter every of them by setting `r0` to 0:
```
    .global start

start:
    r0 = 0
    exit
```

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

## Nice to have (VS Code extension)
I made a custom `spriteday.ebpf-assembly` VS Code extension, it should be published at this point at [Open VSX](https://open-vsx.org/extension/spriteday/ebpf-assembly), but if it's unavailable you should be able to find installable release at https://github.com/SpriteDay/vscode-ebpf-assembly