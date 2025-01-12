This repository contains [Bazel](https://bazel.build/) targets for
version 6.3.0 of the [GNU Multiple Precision Arithmetic
Library](https://gmplib.org/).  To use, add the following to your [MODULE.bazel
file](https://bazel.build/external/overview#bzlmod):

```python
bazel_dep(name = "phst_gmp", version = "0")
git_override(
    module_name = "phst_gmp",
    commit = "b02eaae05766c7eae4046d3f65ab9cf277b5519f",
    remote = "https://github.com/phst/gmp.git",
)
```

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
