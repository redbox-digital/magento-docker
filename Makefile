all: project

project:
	mkdir -p build tmp
	cp -r compose tmp/rbd
	tar czf build/rbd.tar.gz -C tmp rbd
	rm -rf tmp

link:
	ln -s "$(CURDIR)/rd" "/usr/local/bin/rd"

unlink:
	find /usr/local/bin -type l -name rd -delete

clean:
	rm -rf build tmp
