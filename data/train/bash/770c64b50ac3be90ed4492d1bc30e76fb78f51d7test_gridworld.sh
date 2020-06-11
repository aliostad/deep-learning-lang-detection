maze=$HOME/projects/beliefbox/dat/maze2
width=8
height=8
T=1000
n_runs=1
n_episodes=1000
rand=0.01
lambda=0.9
gamma=0.99
epsilon=0.0
S=8
A=3
Environment=Gridworld

model=QLearning
echo $model
time ./bin/online_algorithms --gamma $gamma --lambda $lambda --n_runs $n_runs --n_episodes $n_episodes --n_steps $T --maze_name=$maze --algorithm $model --environment $Environment --epsilon $epsilon > $model.out

model=Sarsa
echo $model
time ./bin/online_algorithms --gamma $gamma --lambda $lambda --n_runs $n_runs --n_episodes $n_episodes --n_steps $T --maze_name=$maze --algorithm $model --environment $Environment --epsilon $epsilon > $model.out



model=Model
echo $model
time ./bin/online_algorithms --gamma $gamma --lambda $lambda --n_runs $n_runs --n_episodes $n_episodes --n_steps $T --maze_name=$maze --algorithm $model --environment $Environment --epsilon $epsilon  > $model.out


for i in 1 2 3 4; do
    model=Sampling
    echo $model${i}
    time ./bin/online_algorithms --gamma $gamma --lambda $lambda --n_runs $n_runs --n_episodes $n_episodes --n_steps $T --maze_name=$maze --algorithm $model --max_samples ${i} --environment $Environment --epsilon $epsilon  > ${model}${i}.out
done    
wait;

for i in 5 6 7 8; do
    model=Sampling
    echo $model${i}
    time ./bin/online_algorithms --gamma $gamma --lambda $lambda --n_runs $n_runs --n_episodes $n_episodes --n_steps $T --maze_name=$maze --algorithm $model --max_samples ${i} --environment $Environment --epsilon 0.0  > ${model}${i}.out &
done    
wait;

for model in QLearning Sarsa Model Sampling
do
    grep REWARD $model.out >$model.reward
    grep PAYOFF $model.out >$model.payoff
done


for i in 1 2 3 4 5 6 7 8
do
    model=Sampling${i}
    grep REWARD $model.out >$model.reward
    grep PAYOFF $model.out >$model.payoff
done
