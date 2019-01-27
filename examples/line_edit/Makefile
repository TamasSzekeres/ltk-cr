all:
	crystal build src/line_edit.cr --link-flags -L/usr/X11/lib/

clean:
	rm line_edit

clear-deps:
	rm -rf .shards
	rm -rf lib
	rm shard.lock

install:
	crystal deps

reinstall: clear-deps install
