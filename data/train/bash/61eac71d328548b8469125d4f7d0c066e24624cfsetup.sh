#!/usr/bin/env bash

source script.sh

function catch() {
    case $1 in
        0)  echo "setup succeeded"
            ;;
        1)  echo "script.sh: failed @ clonePhoneCatRepo@14()";
            ;;
        2)  echo "script.sh: failed @ checkoutPhoneCatRepoStep12()";
            ;;
        4)  echo "script.sh: failed @ npmInstallPhoneCatRepo()";
            ;;
        5)  echo "script.sh; failed @ npmInstallPhoneCatRepo()";
            ;;
        6)  echo "script.sh; failed @ updatePhoneCatRepoWebDriver()";
            ;;
        *)  echo "fubar! Something went wrong."
            ;;
    esac
    exit $1
}
# try
(
    clonePhoneCatRepo@14 || exit 1;
    checkoutPhoneCatRepoStep12 || exit 2;
    npmInstallPhoneCatRepo || exit 4;
    bowerInstallPhoneCatRepo || exit 5;
    updatePhoneCatRepoWebDriver || exit 6;
)
catch $?;
