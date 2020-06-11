licenses(["notice"])

package(default_visibility = ["//visibility:public"])

cc_library(
    name = "gtest",
    srcs = [
        "repository/src/gtest.cc",
        "repository/src/gtest-death-test.cc",
        "repository/src/gtest-filepath.cc",
        "repository/src/gtest-printers.cc",
        "repository/src/gtest-port.cc",
        "repository/src/gtest-test-part.cc",
        "repository/src/gtest-typed-test.cc",
    ],
    includes = [
        'repository',
        'repository/include',
    ],
    linkopts = ["-lpthread"],
)

cc_library(
    name = "gtest_main",
    srcs = [
        "repository/src/gtest_main.cc",
    ],
    includes = [
        'repository',
        'repository/src',
    ],
    deps = [
        ":gtest",
        "//third_party/glog",
        "//third_party/gflags",
    ],
)
