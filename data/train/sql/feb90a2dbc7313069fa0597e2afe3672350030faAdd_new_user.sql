/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/* Author: Patrick Conrad - Ekagra                                       */
/* Date:   12/1/2005                                                     */
/* Description: This script is used to grant the appropriate roles and   */
/*              permissions to a user to execute the Data Extract Utility*/
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* Modification History:                                                 */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

-- Added condition to exit when error.  Just incase run accidently.
WHENEVER SQLERROR EXIT

-- Spool a log file
spool Add_new_user.lst


GRANT EXT_ROLE to &&NewUser;

GRANT EXTRACT_ADMIN to &&NewUser;

GRANT EXTRACT_EXECUTE to &&NewUser;
  
Insert into CT_EXT_ACCOUNTS (USER_NAME)
       Values (UPPER('&&NewUser'));

Commit;

create synonym &&NewUser..CT_DATA for OC_DATA.CT_DATA;

create synonym &&NewUser..CDUS_DATA for OC_DATA.CDUS_DATA;


undefine NewUser
