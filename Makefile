.POSIX:
.SUFFIXES:

SHELL = /bin/sh

BAZEL = bazel
BAZELFLAGS =
ADDLICENSE = $(BAZEL) run $(BAZELFLAGS) -- @addlicense
BUILDIFIER = $(BAZEL) run $(BAZELFLAGS) -- @buildifier

all:
	$(BAZEL) build $(BAZELFLAGS) -- //...

check: all
	$(BAZEL) test $(BAZELFLAGS) -- //...
	$(ADDLICENSE) -check -- "$${PWD}"
	$(BUILDIFIER) -mode=check -lint=warn -warnings=+native-cc -r -- "$${PWD}"
