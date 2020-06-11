export RUN="sbcl --noinform --load algebra.lisp \
                            --load queue.lisp \
                            --load gauss.lisp \
			    --load cone.lisp \
			    --load cone2.lisp \
                            --load enumerate.lisp \
                            --load main-enum-diag.lisp "

function run_weak
{
    (time $RUN weak $1 $2 2>/dev/null) >results/diag_weak_$1_$2.txt 2>>results/diag_weak_$1_$2.txt
}


run_weak 2 10

#for i in `seq 21 30`; do f=results/diag_weak_4_$i.txt; run_weak 4 $i; done
