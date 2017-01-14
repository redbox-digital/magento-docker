all: project

project:
	mkdir -p build tmp
	cp -r compose tmp/rbd
	tar czf build/rbd.tar.gz -C tmp rbd
	rm -rf tmp

clean:
	rm -rf build tmp
