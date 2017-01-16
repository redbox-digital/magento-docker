all: project

project:
	mkdir -p build tmp
	cp -r compose tmp/rbd
	tar czf build/rbd.tar.gz -C tmp rbd
	rm -rf tmp

test:
	echo "No tests yet, shame on me"

link:
	ln -s "$(CURDIR)/rd" "/usr/local/bin/rdl"

unlink:
	find /usr/local/bin -type l -name rdl -delete

clean:
	rm -rf build tmp

