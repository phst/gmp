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

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def phst_gmp_repos():
    """Adds required dependencies for the phst_gmp workspace."""
    http_archive(
        name = "gmp",
        build_file = "@phst_gmp//:gmp.BUILD",
        sha256 = "a3c2b80201b89e68616f4ad30bc66aee4927c3ce50e33929ca819d5c43538898",
        strip_prefix = "gmp-6.3.0/",
        urls = [
            "https://gmplib.org/download/gmp/gmp-6.3.0.tar.xz",  # 2023-07-29
        ],
    )
    http_archive(
        name = "rules_foreign_cc",
        sha256 = "8e5605dc2d16a4229cb8fbe398514b10528553ed4f5f7737b663fdd92f48e1c2",
        strip_prefix = "rules_foreign_cc-0.13.0",
        url = "https://github.com/bazel-contrib/rules_foreign_cc/releases/download/0.13.0/rules_foreign_cc-0.13.0.tar.gz",
    )

def _copy_outputs(ctx):
    hdrs = _copy_headers(ctx)
    libs = _copy_libs(ctx)
    return DefaultInfo(files = depset(hdrs + libs))

copy_outputs = rule(
    attrs = {
        "src": attr.label(mandatory = True),
        "hdrs": attr.output_list(
            mandatory = True,
            allow_empty = False,
        ),
        "libs": attr.output_list(
            mandatory = True,
            allow_empty = False,
        ),
    },
    implementation = _copy_outputs,
)

def _copy_headers(ctx):
    # configure_make adds the include directory as output file instead of the
    # headers within.
    outs = ctx.outputs.hdrs
    directories = [f for f in ctx.attr.src.files.to_list() if f.basename == "include"]
    if len(directories) != 1:
        fail("not exactly one include directory: {}".format(directories))
    directory = directories[0]
    for out in outs:
        ctx.actions.run(
            outputs = [out],
            inputs = [directory],
            executable = "cp",
            arguments = ["--", "{}/{}".format(directory.path, out.basename), out.path],
            mnemonic = "Copy",
            progress_message = "copying {}/{} to {}".format(directory.short_path, out.basename, out.short_path),
        )
    return outs

def _copy_libs(ctx):
    outs = ctx.outputs.libs
    for out in outs:
        srcs = [f for f in ctx.attr.src.files.to_list() if f.basename == out.basename]
        if len(srcs) != 1:
            fail("not exactly one source file: {}".format(srcs))
        src = srcs[0]
        ctx.actions.run(
            outputs = [out],
            inputs = [src],
            executable = "cp",
            arguments = ["--", src.path, out.path],
            mnemonic = "Copy",
            progress_message = "copying {} to {}".format(src.short_path, out.short_path),
        )
    return outs
