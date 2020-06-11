#!/usr/bin/env bash
set -x
. bin/common.sh

usage () {
    e_e $"
Usage: $(basename $0) {${ALL_OPTS}} payload

    Where payload: '{\"key1\":\"value1\"}'

" 1
}

[ -z "$1" ] && usage
[ -z "$2" ] && usage

LAMBDA=$1
PAYLOAD=$2
FAIL=0


invoke_lambda () {
    echo $"Invoking ${LAMBDA} with payload: $2"
    [ ! -d "out/result" ] && { mkdir -p "out/result"; }
    TMPFILE=$(pwd)/$(mktemp -u -p out/result ${LAMBDA}XXXXXX)
    L_CMD="aws lambda invoke"
    L_CMD="${L_CMD} --function-name $1"
    L_CMD="${L_CMD} --payload '$2'"
    L_CMD="${L_CMD} $TMPFILE"
    bash -c "${L_CMD}" && cat ${TMPFILE}
}
case "$LAMBDA" in
    ${LAMBDA_CASES})
        fn_name=
        lambda_fn_name $LAMBDA "fn_name"
        invoke_lambda "$(bin/cfn-value.sh ${!fn_name})" $PAYLOAD
        ;;
    ${LAMBDA_OUTPUT_FN})
        invoke_lambda StackOutputsLookup $PAYLOAD
        ;;
    *)
        usage
        exit 3
esac
