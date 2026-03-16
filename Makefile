all: build/main.o

build/main.o: src/main.s
	mkdir -p build
	clang -target bpf -c src/main.s -o build/main.o

clean:
	rm -rf build/
