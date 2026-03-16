    // eBPF programs can be attached at different points in the kernel and will be called like a function
    // That's why we specify the type via "socket_filter" 
    // Program types: https://docs.ebpf.io/linux/program-type/
    // Linking of socket_filter to BPF_PROG_TYPE_SOCKET_FILTER: https://github.com/libbpf/libbpf/blob/master/src/libbpf.c#L199
    //
    // The second argument currently set to "" is optional flags argument specified here: https://sourceware.org/binutils/docs/as/Section.html
    //
    // The last element set to @progbits is data type, is also specified here: https://sourceware.org/binutils/docs/as/Section.html
    .section socket_filter,"",@progbits

    .global start

start:
    r0 = 0
    exit
