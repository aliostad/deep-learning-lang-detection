MYTMP=$SCRATCH/breakdancer
mkdir $MYTMP


one_job_all_samples()
{
    stderr=$MYTMP/breakdancer.stderr
    stdout=$MYTMP/breakdancer.stdout
    context=$MYTMP/breakdancer.context
    oarsub -O $stdout -E $stderr -S "./chkpt_breakdancer.sh $context"
}

separate_job_per_sample()
{
    for k in 4 #2 4 5 6 7 8
    do
	sample=patient_$k
	stderr=$MYTMP/breakdancer.sample$k.stderr
	stdout=$MYTMP/breakdancer.sample$k.stdout
	context=$MYTMP/breakdancer.sample$k.context
	name=Breakdancer_$k
	oarsub -n $name -O $stdout -E $stderr -S "./chkpt_breakdancer2.sh $sample $context"
    done
}

#one_job_all_samples
separate_job_per_sample
