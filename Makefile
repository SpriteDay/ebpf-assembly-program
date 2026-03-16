all: build/main.o

build/main.o: src/main.s
	mkdir -p build
	clang -target bpf -c src/main.s -o build/main.s

clean:
	rm -rf build/
