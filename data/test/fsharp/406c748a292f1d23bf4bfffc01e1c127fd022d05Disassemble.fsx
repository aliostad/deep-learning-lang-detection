open System
open System.Collections.Generic
open System.Diagnostics
open System.IO
open System.Linq
open System.Text
open Microsoft.Win32

let dis assemblyPath = 
    let registryPath = @"SOFTWARE\Microsoft\Microsoft SDKs\Windows"
    let registryValue = "CurrentInstallFolder"
    let key = Registry.LocalMachine.OpenSubKey(registryPath)
    let path = key.GetValue(registryValue) :?> string
    let disassemblerPath = Path.Combine(path, @"Bin\ildasm.exe")
    let sourcePath = Path.ChangeExtension(assemblyPath, ".il")
    let args = sprintf "\"%s\" /out:\"%s\"" assemblyPath sourcePath
    let startInfo = ProcessStartInfo(disassemblerPath, args)
    startInfo.CreateNoWindow <- true
    startInfo.WindowStyle <- ProcessWindowStyle.Hidden
    let process = Process.Start(startInfo)
    process.WaitForExit()

dis @"c:\temp\test.dll"
File.ReadAllText(@"C:\temp\test.il")

dis assemblyFileName
File.ReadAllText (Path.ChangeExtension(assemblyFileName, "il"))

dis @"c:\Dev\Projects\MicroORMTypeProvider\MicroORMTypeProvider\bin\Debug\MicroORMTypeProvider.dll"
File.ReadAllText(@"bin\Debug\MicroORMTypeProvider.il")


dis @"c:\Dev\Projects\ILBuilder\ILBuilder\bin\Debug\ILBuilder.dll"
File.ReadAllText(@"c:\Dev\Projects\ILBuilder\ILBuilder\bin\Debug\ILBuilder.il")


dis @"c:\temp\MyAssembly.dll"
File.ReadAllText(@"c:\temp\MyAssembly.il")

dis @"C:\Dev\Temp\TestDemo\TestDemo\bin\Debug\TestDemo.dll"
File.ReadAllText(@"C:\Dev\Temp\TestDemo\TestDemo\bin\Debug\TestDemo.il")


