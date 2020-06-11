#!/bin/sh

model_in="serialise_in.$$"
model_out="serialise_out.$$"

cat > $model_in <<HERE
Model ""
    State 0
        X = "State 1"
        P = 0.634323
        Emission
            Table size: 2
            "No eggs": 0.978646
            "Eggs": 0.0213538
        EndEmission
    EndState
    State 1
        X = "State 2"
        P = 0.365677
        Emission
            Table size: 2
            "No eggs": 0.216646
            "Eggs": 0.783354
        EndEmission
    EndState
    Transition 0
        from = 0
        to   = 0
        P    = 0.932979
    EndTransition
    Transition 1
        from = 0
        to   = 1
        P    = 0.0670208
    EndTransition
    Transition 2
        from = 1
        to   = 0
        P    = 0.116258
    EndTransition
    Transition 3
        from = 1
        to   = 1
        P    = 0.883742
    EndTransition
EndModel
HERE

./serialise < $model_in > $model_out || exit $?

if ! diff $model_in $model_out; then
    echo "Serialisation doesn't fit:" >&2
    diff $model_in $model_out >&2

    exit 127;
fi

rm $model_in $model_out
