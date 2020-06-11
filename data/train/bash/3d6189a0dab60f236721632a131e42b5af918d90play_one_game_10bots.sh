#!/usr/bin/env sh
./playgame.py -SoeEIO --player_seed 42 --end_wait=0.25 --verbose --log_dir game_logs --turns 1000 --turntime 5000000000 --loadtime 60000000 --map_file maps/official/random_walk_10p_02.map "$@" "python sample_bots/python/HunterBot.py" "python sample_bots/python/HunterBot.py" "python sample_bots/python/GreedyBot.py" "python sample_bots/python/GreedyBot.py" "python sample_bots/python/GreedyBot.py" "python sample_bots/python/HunterBot.py" "python sample_bots/python/HunterBot.py" "python sample_bots/python/HunterBot.py" "python sample_bots/python/GreedyBot.py" 