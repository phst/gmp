.POSIX:
.SUFFIXES:

SHELL = /bin/sh

BAZEL = bazel
BAZELFLAGS =

all:
	$(BAZEL) build $(BAZELFLAGS) -- //...

check: all
	$(BAZEL) test $(BAZELFLAGS) -- //...
