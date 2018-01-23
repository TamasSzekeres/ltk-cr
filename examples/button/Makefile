all:
	crystal build src/button.cr --link-flags -L/usr/X11R6/lib/

clean:
	rm button

clear-deps:
	rm -rf .shards
	rm -rf lib
	rm shard.lock

install:
	crystal deps

reinstall: clear-deps install
