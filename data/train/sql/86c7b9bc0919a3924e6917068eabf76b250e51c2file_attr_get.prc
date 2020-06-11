proc file_attr_get (filename_n_path)
;
local logging = %liv (log_procedure)
%liv (log_procedure) = FALSE
;
;==============================================================================
;
; Purpose: 
;
; History:
;
#include "cfe_utils.h"

ON ERROR RESUME

local wait_time
local tsr = total_successful_receivers
local tss = total_successful_senders
local tus = total_unsuccessful_senders
local tur = total_unsuccessful_receivers

; set up wait time for file xfer

wait_time = %gmt + 900

; loop until archive bit clears, tsr increments or time is expired

; write "Starting archive bit monitoring ... "
write "Starting file monitoring ... "
; /FM_REQFILESTAT PATHNAME=filename_n_path
; write filename_n_path, ": ",p@fm_fsarchive, " 1"
; write "TSR:   ", total_successful_receivers
; write "TRSp1: ", tsr+1
; while (fm_fsarchive = 1) and 
   while (%gmt < wait_time);;
   and  (total_successful_receivers <> tsr + 1) do
   write "Waiting ..."
   wait 3
;   /FM_REQFILESTAT PATHNAME=filename_n_path
;   write filename_n_path, ": ",p@fm_fsarchive, " 2"
;   write "TSR:   ", total_successful_receivers
;   write "TRSp1: ", tsr+1
enddo

;   write "TSR:   ", total_successful_receivers
;   write "TRSp1: ", tsr+1
;   write
;   write %gmt
;   write wait_time


RETURN:
%liv (log_procedure) = logging

ENDPROC
