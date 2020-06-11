proc $sc_$cpu_evs_send_error
;JAN 11 2006 Added CFE_TBL
on ERROR resume

#include "ut_statusdefs.h"
local raw_command

local appid_key
local spec_appid_key

local cpu_index = %substring("$CPU",4,4)
if (cpu_index = "1") then
   appid_key = "0"
   spec_appid_key = "1880"
elseif (cpu_index = "2") then
   appid_key = "2"
   spec_appid_key = "1980"
elseif (cpu_index = "3") then
   appid_key = "4"
   spec_appid_key = "1A80"
endif

write
write "     Sending ERROR message for CFE_EVS."
write "     *** EVS messages are all INFO type ***"
write

write "     Sending ERROR message for CFE_SB."
ut_setupevt $SC, $CPU, CFE_SB, 53, ERROR
wait 5
raw_command = "18" & appid_key & "3c0000001aa"
Ut_sendrawcmd "$SC_$CPU_SB", {raw_command}
wait 7
write
IF ($SC_$CPU_num_found_messages = 1) THEN
   write "     Event Message: ", $SC_$CPU_find_event[1].eventid 
ELSE
   write "     Event Message NOT generated."
ENDIF
write

write "     Sending ERROR message for CFE_ES."
ut_setupevt $SC, $CPU, CFE_ES, 17, ERROR
wait 5
raw_command = "18" & appid_key & "6c0000001aa"
Ut_sendrawcmd "$SC_$CPU_ES", {raw_command}
wait 7
write
IF ($SC_$CPU_num_found_messages = 1) THEN
   write "     Event Message: ", $SC_$CPU_find_event[1].eventid 
ELSE
   write "     Event Message NOT generated."
ENDIF
write
;
write "     Sending ERROR message for CFE_TIME."
ut_setupevt $SC, $CPU, CFE_TIME, 27, ERROR
wait 5
raw_command = "18" & appid_key & "5c0000001aa"
Ut_sendrawcmd "$SC_$CPU_TIME", {raw_command}
wait 7
write
IF ($SC_$CPU_num_found_messages = 1) THEN
   write "     Event Message: ", $SC_$CPU_find_event[1].eventid 
ELSE
   write "     Event Message NOT generated."
ENDIF
write
;
write "     Sending ERROR message for CFE_TBL."
ut_setupevt $SC, $CPU, CFE_TBL, 51, ERROR
wait 5
;
raw_command = "18" & appid_key & "4C00000270A00"
Ut_sendrawcmd "$SC_$CPU_TBL", {raw_command}
wait 7
write
IF ($SC_$CPU_num_found_messages = 1) THEN
   write "     Event Message: ", $SC_$CPU_find_event[1].eventid 
ELSE
   write "     Event Message NOT generated."
ENDIF
write

write "     Sending ERROR message for TO_APP."
ut_setupevt $SC, $CPU, TO_LAB_APP, 9, ERROR
wait 5
raw_command = spec_appid_key & "c0000001aa"
Ut_sendrawcmd "$SC_$CPU_TO", {raw_command}
wait 7
write
IF ($SC_$CPU_num_found_messages = 1) THEN
   write "     Event Message: ", $SC_$CPU_find_event[1].eventid 
ELSE
   write "     Event Message NOT generated."
ENDIF
write

write "     Sending ERROR message for TST_EVS."
/$SC_$CPU_TST_EVS_SendEvtMsg ERROR  EventId = "1" Iters = "1" Milliseconds = "0"
write ""
wait 5

endproc
