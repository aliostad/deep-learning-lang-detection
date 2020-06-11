-- Team: Data Junkies
-- Employee Database Application

prompt
prompt =====================================================
prompt 
prompt This tests operations assigned to the Employee Role
prompt but not assigned to any of its super-roles
prompt   Queries: ShowMyInfo, ShowDeptEmps, ShowDeptLoc, ShowAddr
prompt   Actions: ChangeAddr
prompt
pause Hit Return to test Employee role operations

prompt
prompt ==> ShowMyInfo
@&u\ShowMyInfo

prompt
prompt ==> ShowDeptEmps shows names and jobs of employees in my dept
@&u\ShowDeptEmps

prompt
prompt ==> Use ShowDeptLoc to show dept and loc of &other
@&u\ShowDeptLoc &other

prompt
prompt ==> Show my address; none provided
@&u\ShowAddr &me

prompt
prompt ==> Set my address to be visible at 100 &me Way
@&u\ChangeAddr '100 &me Way' Boston MA 01234 T

prompt
prompt ==> Now show my address again
@&u\ShowAddr &me

prompt
prompt ==> Show address of &other
prompt ==> Might not show anything unless &other has provided a visible address
@&u\ShowAddr &other






