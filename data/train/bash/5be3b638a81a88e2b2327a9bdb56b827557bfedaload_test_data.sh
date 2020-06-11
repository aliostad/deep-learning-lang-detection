#!/bin/bash

# Load users
rake mobile_ctf_scoreboard:load:player\[test@example.com,test1234,tester0\] RAILS_ENV=development
rake mobile_ctf_scoreboard:load:player\[testing@example.com,test1234,tester1\] RAILS_ENV=development
rake mobile_ctf_scoreboard:load:player\[tester@example.com,test1234,tester2\] RAILS_ENV=development
rake mobile_ctf_scoreboard:load:player\[tests@example.com,test1234,tester3\] RAILS_ENV=development
rake mobile_ctf_scoreboard:load:player\[testing2@example.com,test1234,tester4\] RAILS_ENV=development

# Create Rounds (2 with one attack/defend, 1 with 2)
rake mobile_ctf_scoreboard:load:round\[10,00:12:00,00:47:00\]
rake mobile_ctf_scoreboard:load:round\[20,01:52:00,03:02:00\]
rake mobile_ctf_scoreboard:load:round\[30\]

# Create Defend Periods
rake mobile_ctf_scoreboard:load:defend_period\[15,1,00:12:00\]
rake mobile_ctf_scoreboard:load:defend_period\[15,1,01:52:00\]
rake mobile_ctf_scoreboard:load:defend_period\[15,1,02:27:00\]

# Create Attack Periods
rake mobile_ctf_scoreboard:load:attack_period\[10,1.2,15,4,00:28:00\]
rake mobile_ctf_scoreboard:load:attack_period\[20,1.5,15,4,02:08:00\]
rake mobile_ctf_scoreboard:load:attack_period\[20,1.4,15,4,02:43:00\]
rake mobile_ctf_scoreboard:load:attack_period\[30,1.8,200\]

# Create a new flag for each Attack Round
rake mobile_ctf_scoreboard:load:flags_for_period\[00:33:00\]
rake mobile_ctf_scoreboard:load:flags_for_period\[02:13:00\]
rake mobile_ctf_scoreboard:load:flags_for_period\[02:48:00\]
rake mobile_ctf_scoreboard:load:flags_for_period\[\]

# Create the integrity check results
rake mobile_ctf_scoreboard:load:integrity_check_result\[1,true,02:06:00\]
rake mobile_ctf_scoreboard:load:integrity_check_result\[2,true,02:06:00\]
rake mobile_ctf_scoreboard:load:integrity_check_result\[3,true,02:06:00\]
rake mobile_ctf_scoreboard:load:integrity_check_result\[4,true,02:06:00\]
rake mobile_ctf_scoreboard:load:integrity_check_result\[5,true,02:06:00\]
rake mobile_ctf_scoreboard:load:integrity_check_result\[1,false,00:26:00\]
rake mobile_ctf_scoreboard:load:integrity_check_result\[1,false,02:40:00\]

# Create messages to user
rake mobile_ctf_scoreboard:load:message:to_user\[1,'(test) Normal','(test) Hopefully this message fins you well.  That is all...',01:47:00\]
rake mobile_ctf_scoreboard:load:message:to_user\[3,"(test) Just (hopefully) a really, really, long title name that won't appear during gameplay",'(test) Not much of a message though',00:19:00\]
rake mobile_ctf_scoreboard:load:message:to_user\[5,"(test) Don't",'(test) Stop sending multiple flags =P',02:40:00\]

# Send message to all users
rake mobile_ctf_scoreboard:load:message:to_all\['(test) Good Luck','(test) Good luck all!',00:01:00\]
rake mobile_ctf_scoreboard:load:message:to_all\['(test) Halfway-ish','(test) The game should be about halfway through!',01:00:00\]
