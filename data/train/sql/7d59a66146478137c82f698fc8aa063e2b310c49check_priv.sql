/*
CORT - Oracle database deployment and continuous integration tool

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
  Description: Check system privilege is granted
  ----------------------------------------------------------------------------------------------------------------------     
  Release | Author(s)         | Comments
  ----------------------------------------------------------------------------------------------------------------------  
  14.02   | Rustam Kafarov    | Checks that given system privilege is granted
  ----------------------------------------------------------------------------------------------------------------------  
*/

DEFINE privilege = '&1'
DEFINE priv_mask = '&2'

SET TERM OFF
SPOOL OFF

COLUMN c_check_result NEW_VALUE check_result NOPRINT
COLUMN c_prompt_text NEW_VALUE prompt_text NOPRINT

SELECT * 
  FROM (SELECT 'privilege '||privilege||' is found' AS c_prompt_text,
               'dummy.sql' AS c_check_result
          FROM (SELECT privilege
                  FROM user_role_privs p
                 INNER JOIN ROLE_SYS_PRIVS rp
                    ON p.granted_role = rp.role
                 UNION    
                SELECT privilege 
                  FROM user_sys_privs
               )
         WHERE REGEXP_LIKE(privilege, '&priv_mask')
         UNION ALL
        SELECT 'privilege &privilege not found' AS c_prompt_text,
               'exit.sql "You need to grant &privilege privilege to &_user user"' AS c_check_result
           FROM dual
        )        
 WHERE ROWNUM = 1;          

SPOOL install.log APPEND
SET TERM ON

PROMPT &prompt_text

@&check_result