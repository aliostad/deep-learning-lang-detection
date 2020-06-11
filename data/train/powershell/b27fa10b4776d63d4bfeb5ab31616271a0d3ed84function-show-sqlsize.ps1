# ----------------------------------------------------------------------
# Function: sss - Show database sizings
# These functions are autoloaded
# ----------------------------------------------------------------------
function show-sqlsize { Param( [String] $MyServer)
invoke-sqlcmd -ServerInstance $MyServer -query `
"select @@servername server,
       d.name dbname,
       cast( sum(8192 * cast(a.size as bigint) / (1024*1024))  as float) Size
from sysaltfiles a,
     sysdatabases d
where a.dbid = d.dbid
group by d.name
order by d.name" 

}
set-alias sss show-sqlsize
# ----------------------------------------------------------------------
# Function: sss - Show database sizings
# ----------------------------------------------------------------------
function show-sqlsizeperdisk { Param( [String] $MyServer)

invoke-sqlcmd -ServerInstance $MyServer -query `
"select
       substring(a.filename,1,2) drivex,
       cast( sum(8192 * cast(a.size as bigint) / (1024*1024))  as float) Size
from sysaltfiles a,
     sysdatabases d
where a.dbid = d.dbid
group by substring(a.filename,1,2)
" | select drivex, size
}
set-alias sssd show-sqlsize
