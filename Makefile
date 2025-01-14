.POSIX:
.SUFFIXES:

SHELL = /bin/sh

BAZEL = bazel
BAZELFLAGS =
ADDLICENSE = $(BAZEL) run $(BAZELFLAGS) -- @addlicense

all:
	$(BAZEL) build $(BAZELFLAGS) -- //...

check: all
	$(BAZEL) test $(BAZELFLAGS) -- //...
	$(ADDLICENSE) -check -- "$${PWD}"
