proc $sc_$cpu_evs_send_debug
;JAN 11 2006 CFE_TBL added
;APR 14 2006 updated message for CFE_SB
on ERROR resume

#include "ut_statusdefs.h"

write
write "     Sending DEBUG message for CFE_EVS."
write "     *** EVS messages are all ERROR or INFO types ***"
write ""

write "     Sending DEBUG message for CFE_SB."
write "     *** SB no-op evt msg is of type INFO ***"
write ""

write "     Sending DEBUG message for CFE_ES."
write "     *** ES messages are all ERROR or INFO types ***"
write ""

write "     Sending DEBUG message for CFE_TIME."
write "     *** TIME messages are all ERROR or INFO types ***"
write ""

write "     Sending DEBUG message for CFE_TBL."
write "     *** TBL no-op evt msg if of INFO type"
write ""

write "     Sending DEBUG message for CI_APP."
write "     *** NO messages are being attempted at this time ***"
write

write "     Sending DEBUG message for TO_APP."
write "     *** NO messages are being attempted at this time ***"
write

write "     Sending DEBUG message for TST_EVS."
/$SC_$CPU_TST_EVS_SendEvtMsg DEBUG EventId = "1" Iters = "1" Milliseconds = "0"
write ""
wait 5

endproc
