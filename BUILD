# Copyright 2019, 2025 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

load(":def.bzl", "copy_outputs")

_OPTS = [
    "-Werror",
    "-pedantic-errors",
] + select({
    # Assume that on macOS the compiler is always Clang and that on Linux it can
    # be GCC or Clang.
    "@platforms//os:linux": [
        "-Wall",
        "-Wextra",
        "-Wconversion",
        "-Wno-sign-conversion",
    ],
    "@platforms//os:macos": [
        "-Wall",
        "-Wextra",
        "-Wconversion",
        "-Wno-sign-conversion",
        "--system-header-prefix=gmp",
    ],
})

_COPTS = _OPTS + ["-std=c11"]

_CXXOPTS = _OPTS + ["-std=c++11"]

cc_library(
    name = "gmp",
    srcs = ["libgmp.a"],
    hdrs = ["gmp.h"],
    copts = _COPTS,
    # Using an include_prefix causes Bazel to emit -I instead of -iquote
    # options for the include directory, so that #include <gmp.h> works.
    include_prefix = ".",
    visibility = ["//visibility:public"],
)

cc_library(
    name = "gmpxx",
    srcs = ["libgmpxx.a"],
    hdrs = ["gmpxx.h"],
    copts = _CXXOPTS,
    # Using an include_prefix causes Bazel to emit -I instead of -iquote
    # options for the include directory, so that #include <gmpxx.h> works.
    include_prefix = ".",
    visibility = ["//visibility:public"],
    deps = [":gmp"],
)

cc_test(
    name = "gmp_test",
    srcs = ["gmp_test.c"],
    copts = _COPTS,
    deps = [":gmp"],
)

cc_test(
    name = "gmpxx_test",
    srcs = ["gmpxx_test.cc"],
    copts = _CXXOPTS,
    deps = [":gmpxx"],
)

# The configure_make rule doesn’t declare its output files, so we can’t refer
# to them directly.  Rather, we introduce an intermediate rule that only copies
# some files to declared output files.  Because declared outputs aren’t
# configurable, we only include the static libraries here since the suffix for
# shared libraries differs between GNU/Linux and macOS.
copy_outputs(
    name = "copy_outputs",
    src = "@gmp",
    hdrs = [
        "gmp.h",
        "gmpxx.h",
    ],
    libs = [
        "libgmp.a",
        "libgmpxx.a",
    ],
)
