/*
CORT - Oracle server-side tool allowing to change tables similar to create or replace command

Copyright (C) 2013-2014  Softcraft Ltd - Rustam Kafarov

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
  Description: Accept only Y or N value
  ----------------------------------------------------------------------------------------------------------------------     
  Release | Author(s)         | Comments
  ----------------------------------------------------------------------------------------------------------------------  
  14.01.1 | Rustam Kafarov    | Accept only Y or N value
  ----------------------------------------------------------------------------------------------------------------------  
*/

PROMPT User CORT already exists
ACCEPT recreate_flg CHAR FORMAT A1 DEFAULT "Y" PROMPT "Do you want to recreate CORT user (Y/N)? [Y] > "

SET TERM OFF
SPOOL OFF

COLUMN check_result NEW_VALUE _check_result NOPRINT
COLUMN prompt_text NEW_VALUE _prompt_text NOPRINT

SELECT CASE WHEN UPPER('&recreate_flg') IN ('Y','N') THEN 'dummy.sql' ELSE 'accept_yn.sql' END AS check_result,
       CASE WHEN UPPER('&recreate_flg') IN ('Y','N') THEN NULL ELSE 'Wrong input. Please press "Y" or "N"' END AS prompt_text
  FROM DUAL;

SPOOL install.log APPEND
SET TERM ON

PROMPT &_prompt_text
@&_check_result