# Copyright 2019 Google LLC
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

load("@rules_foreign_cc//tools/build_defs:configure.bzl", "configure_make")

configure_make(
    name = "gmp",
    configure_env_vars = select({
        ":linux": {
            # https://github.com/bazelbuild/rules_foreign_cc/issues/296
            "CXX": "c++",
        },
        ":macos": {
            # https://github.com/bazelbuild/rules_foreign_cc/issues/296
            "CXXFLAGS": "-lc++",
            # https://github.com/bazelbuild/rules_foreign_cc/issues/185
            "AR": "",
        },
    }),
    configure_options = [
        "--enable-cxx",
        # We don’t use the shared libraries, see the comment about copy_outputs
        # in BUILD.
        "--disable-shared",
        # The resulting libraries fail in weird ways without this option.
        "--with-pic",
    ],
    lib_source = ":source",
    make_commands = [
        # Bazel defines the __TIME__ and __DATE__ macros as "redacted"
        # (including the quotes) on the command line.  configure copies the
        # command line without escaping into the definition of the __GMP_CFLAGS
        # macro, leading to a syntax error.  Therefore we escape the "redacted"
        # token here manually.  Note that three levels of escaping are required
        # for the quotes: one for C++, one for sed, one for Bazel.
        "sed '/^#define __GMP_CFLAGS/s/\"redacted\"/\\\\\"redacted\\\\\"/g' gmp.h > gmp.h.patched",
        "mv gmp.h.patched gmp.h",
        "make install",
    ],
    static_libraries = [
        "libgmp.a",
        "libgmpxx.a",
    ],
    visibility = ["//visibility:public"],
)

filegroup(
    name = "source",
    srcs = glob(["**"]),
)

config_setting(
    name = "linux",
    constraint_values = ["@platforms//os:linux"],
)

config_setting(
    name = "macos",
    constraint_values = ["@platforms//os:osx"],
)
