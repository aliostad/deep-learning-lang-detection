# This is simple backUp PowerShell script, it delete some directory/files 
# and copy the same from my USB device but up to date.
# v.1.0 - 17.07.2014

# First DELETE some directory and files
# some examples: 
# remove-item some_name | Where { $_.PSIsContainer } #  Delete only a folder called some_name
# remove-item some_name | Where { ! $_.PSIsContainer } # Delete only a file called some_name
# Aliases : rm ; rmdir ; ri

# This output some string text
write-host "This is simple backUp PowerShell script. 
It delete some directory/files and copy the same from my USB device but up to date." -foregroundcolor Red -backgroundcolor white
write-host "Task DELETE BEGIN !!!" -foregroundcolor Red -backgroundcolor white

Remove-Item "F:\E\My_Office\MY CV_CL_R.rar"
Remove-Item "F:\E\My_Office\MY CV_CL_R" -recurse -force
Remove-Item "F:\E\My_Office\HRA_Junona" -recurse -force
Remove-Item "F:\E\My_Office\Bio_Kamini" -recurse -force

Remove-Item "F:\E\BoianArh\Office\MY CV_CL_R.rar" 
Remove-Item "F:\E\BoianArh\Office\MY CV_CL_R" -recurse -force
Remove-Item "F:\E\BoianArh\Office\HRA_Junona" -recurse -force
Remove-Item "F:\E\BoianArh\Office\Bio_Kamini" -recurse -force

Remove-Item "F:\E\BoianArh\Danni\c_s_info*"
Remove-Item "F:\E\BoianArh\Danni\DNI.rar"

Remove-Item "F:\E\BoianArh\Danni\MyFinance\Myfin_2014.*"
Remove-Item "F:\E\BoianArh\Danni\ArhUSB_Prog\Programs\EssentialPIM" -recurse -force
Remove-Item "F:\E\BoianArh\Danni\ArhUSB_Prog\Programs\ThunderbirdPortable" -recurse -force

Remove-Item "F:\E\BoianArh\Danni\ArhivPSW" -recurse -force
Remove-Item "F:\E\BoianArh\Danni\EVN_VIK_info" -recurse -force
Remove-Item "F:\E\BoianArh\Danni\PIB_Izvl_Visa" -recurse -force
Remove-Item "F:\E\BoianArh\Danni\sys_info_nosec" -recurse -force

# This output some string text
write-host "Task DELETE is complete !!!" -foregroundcolor Red -backgroundcolor white

# This output some string text
write-host "Task COPY is begin !!!" -foregroundcolor Red -backgroundcolor white

# Then COPY Up to Date Items from USB device
# some examples:
# Copy-Item C:\work -destination C:\some_folder\work -recurse
# The -recurse option ensures any subdirectories will be copied intact. 
# The -container parameter is set to true by default, this preserves the directory structure. 
# The work folder will be created if it does not already exist in destination location.
# Aliases : cp ; cpi

Copy-Item "J:\Office\Bio_Kamini" -destination "F:\E\My_Office\Bio_Kamini" -recurse
Copy-Item "J:\Office\HRA_Junona" -destination "F:\E\My_Office\HRA_Junona" -recurse
Copy-Item "J:\Office\MY CV_CL_R" -destination "F:\E\My_Office\MY CV_CL_R" -recurse
Copy-Item "J:\Office\MY CV_CL_R.rar" -destination "F:\E\My_Office\" 

Copy-Item "J:\Office\Bio_Kamini" -destination "F:\E\BoianArh\Office\Bio_Kamini" -recurse
Copy-Item "J:\Office\HRA_Junona" -destination "F:\E\BoianArh\Office\HRA_Junona" -recurse
Copy-Item "J:\Office\MY CV_CL_R" -destination "F:\E\BoianArh\Office\MY CV_CL_R" -recurse
Copy-Item "J:\Office\MY CV_CL_R.rar" -destination "F:\E\BoianArh\Office\" 

Copy-Item "J:\Danni\c_s_info*" -destination "F:\E\BoianArh\Danni\"
Copy-Item "J:\Danni\DNI.rar" -destination "F:\E\BoianArh\Danni\"

Copy-Item "J:\Danni\Myfin_2014.xls" -destination "F:\E\BoianArh\Danni\MyFinance\"
Copy-Item "J:\Programs\EssentialPIM" -destination "F:\E\BoianArh\Danni\ArhUSB_Prog\Programs\EssentialPIM" -recurse
Copy-Item "J:\Programs\ThunderbirdPortable" -destination "F:\E\BoianArh\Danni\ArhUSB_Prog\Programs\ThunderbirdPortable" -recurse 

Copy-Item "J:\Danni\ArhivPSW" -destination "F:\E\BoianArh\Danni\ArhivPSW" -recurse
Copy-Item "J:\Danni\EVN_VIK_info" -destination "F:\E\BoianArh\Danni\EVN_VIK_info" -recurse
Copy-Item "J:\Danni\PIB_Izvl_Visa" -destination "F:\E\BoianArh\Danni\PIB_Izvl_Visa" -recurse
Copy-Item "J:\Danni\sys_info_nosec" -destination "F:\E\BoianArh\Danni\sys_info_nosec" -recurse

# This output some string text
write-host " ALL Tasks DONE !!!" -foregroundcolor Red -backgroundcolor white

