#load "Password.fsx"
open Password

[<System.Security.Permissions.PrincipalPermission(System.Security.Permissions.SecurityAction.Demand, Role = @"BUILTIN\Administrators")>]
//let psw =  (System.Globalization.CultureInfo.CurrentCulture.DateTimeFormat.GetMonthName(System.DateTime.Now.Month) + System.DateTime.Now.Year.ToString())
let dude = new System.Net.NetworkCredential(System.Environment.UserName, Password.getPassword());
let info = System.Diagnostics.ProcessStartInfo("C:\software\ZZZZZZ.msc")
info.Verb <- "runas"
info.Arguments <- "-h"
info.UseShellExecute <- true
System.Diagnostics.Process.Start(info)
//System.Diagnostics.Process.Start("c:\software\ZZZZZZ.msc", System.Environment.UserName, dude.SecurePassword, System.Environment.UserDomainName)
