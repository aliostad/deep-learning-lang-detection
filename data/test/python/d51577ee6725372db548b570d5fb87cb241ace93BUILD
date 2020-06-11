licenses(["notice"])

package(default_visibility = ["//visibility:public"])

cc_library(
    name = "glog",
    srcs = [
        "repository/src/demangle.cc",
        "repository/src/logging.cc",
        "repository/src/raw_logging.cc",
        "repository/src/signalhandler.cc",
        "repository/src/symbolize.cc",
        "repository/src/utilities.cc",
        "repository/src/vlog_is_on.cc",
    ],
    includes = [
        "repository/src",
        "build/src",
    ],
    deps = [
        '//third_party/gflags',
    ],
    linkopts = ["-lpthread"],
)
