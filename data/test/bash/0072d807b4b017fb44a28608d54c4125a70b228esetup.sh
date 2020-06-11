#!/usr/bin/env bash

source script.sh

function catch() {
    case $1 in
        0)  echo "setup succeeded"
            ;;
        1)  echo "script.sh: failed @ clonePhoneCatRepo@14()";
            ;;
        2)  echo "script.sh: failed @ checkoutPhoneCatRepoStep3()";
            ;;
        3)  echo "script.sh: failed @ installPhoneCatRepo()";
            ;;
        4)  echo "script.sh; failed @ updatePhoneCatRepoWebDriver()";
            ;;
        *)  echo "fubar! Something went wrong."
            ;;
    esac
    exit $1
}
# try
(
    clonePhoneCatRepo@14 || exit 1;
    checkoutPhoneCatRepoStep3 || exit 2;
    installPhoneCatRepo || exit 3;
    updatePhoneCatRepoWebDriver || exit 4;
)
catch $?;
