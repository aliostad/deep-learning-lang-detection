#!/usr/bin/env sh
./playgame.py -So --player_seed 41 --end_wait=0.25 --verbose --log_dir game_logs --turns 2500 --map_file maps/maze/maze_08p_01.map "$@" \
        "./mybot.sh" \
	    "./mybotv3.sh" \
        "python sample_bots/python/HunterBot.py" \
        "python sample_bots/python/LeftyBot.py" \
        "python sample_bots/python/GreedyBot.py" \
        "python sample_bots/python/RandomBot.py" \
        "python sample_bots/python/HunterBot.py" \
        "python sample_bots/python/LeftyBot.py" | java -Xmx1536m -jar visualizer.jar
