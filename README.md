This repository contains [Bazel](https://bazel.build/) targets for
version 6.3.0 of the [GNU Multiple Precision Arithmetic
Library](https://gmplib.org/).  To use, add the following to your [WORKSPACE
file](https://docs.bazel.build/versions/master/external.html):

```python
http_archive(
    name = "phst_gmp",
    sha256 = "6b138c773afbc41ede0233f873d2508c6ea9dc71c2809ea56aa1f8c4b658c743",
    strip_prefix = "gmp-b02eaae05766c7eae4046d3f65ab9cf277b5519f/",
    urls = ["https://github.com/phst/gmp/archive/b02eaae05766c7eae4046d3f65ab9cf277b5519f.zip"],
)

load("@phst_gmp//:def.bzl", "phst_gmp_repos")

phst_gmp_repos()

load("@rules_foreign_cc//:workspace_definitions.bzl", "rules_foreign_cc_dependencies")

rules_foreign_cc_dependencies(register_default_tools = False)
```

The `register_default_tools = False` attribute isn’t necessary; you can also
leave it out if you e. g. want to use CMake.

Then you can use the
[`cc_library`](https://docs.bazel.build/versions/master/be/c-cpp.html#cc_library)
targets `@phst_gmp//:gmp` and `@phst_gmp//:gmpxx` to use the C and C++ bindings
of GNU MP, respectively.

This repository relies on
[`rules_foreign_cc`](https://github.com/bazelbuild/rules_foreign_cc).  It
should work fine on recent versions of GNU/Linux or macOS, but Windows isn’t
supported at this point.  It includes workarounds for the `rules_foreign_cc`
bugs [185](https://github.com/bazelbuild/rules_foreign_cc/issues/185) and
[296](https://github.com/bazelbuild/rules_foreign_cc/issues/296).

This is not an officially supported Google product.
