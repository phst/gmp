# Copyright 2025 Philipp Stephani
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""Internal repository rules."""

visibility("private")

def _gmp_repo_impl(ctx):
    version = ctx.attr.version or fail("missing version")
    archive = "/gmp/gmp-{}.tar.xz".format(version)
    ctx.download_and_extract(
        url = [
            "https://ftpmirror.gnu.org/gnu" + archive,
            "https://ftp.gnu.org/gnu" + archive,
            "https://gmplib.org/download" + archive,
        ],
        sha256 = ctx.attr.sha256 or fail("missing integrity"),
        stripPrefix = "gmp-{}/".format(version),
    )
    ctx.template(
        "BUILD.bazel",
        Label("//:gmp.BUILD.template"),
        {
            '"[configure.bzl]"': repr(str(Label("@rules_foreign_cc//foreign_cc:configure.bzl"))),
            '"[linux]"': repr(str(Label("@platforms//os:linux"))),
            '"[macos]"': repr(str(Label("@platforms//os:macos"))),
        },
        executable = False,
    )

gmp_repo = repository_rule(
    # @unsorted-dict-items
    attrs = {
        "version": attr.string(mandatory = True),
        "sha256": attr.string(mandatory = True),
    },
    implementation = _gmp_repo_impl,
)
