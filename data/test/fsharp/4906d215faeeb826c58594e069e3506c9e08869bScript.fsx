// Learn more about F# at http://fsharp.org. See the 'F# Tutorial' project
// for more guidance on F# programming.

#r @"C:\PROJ\googleMusicAllAccess\packages\Dynamitey\lib\net40\Dynamitey.dll"
#r @"C:\PROJ\googleMusicAllAccess\packages\FSharp.Interop.Dynamic\lib\portable-net45+sl50+win\FSharp.Interop.Dynamic.dll"
#r @"C:\PROJ\googleMusicAllAccess\temp\python\Lib\site-packages\Python.Runtime.dll"


#load "StringCypher.fs"
#load "PythonInterop.fs"
#load "../GMusicApi.Core/DataTypes.fs"
#load "../GMusicApi.Core/Interfaces.fs"
#load "GMusicApi.fs"

open GMusicAPI

// Needs to be executed twice. First time the F# compiler will crash with 'error FS0193: internal error: Illegal characters in path.'
GMusicAPI.initialize @"C:\PROJ\googleMusicAllAccess\temp\python"

let getEnv envVar =
  System.Environment.GetEnvironmentVariable envVar
  |> StringCypher.decrypt "V@/H!!}N)-]6N'%k\"Vje"

// Use F# interactive and run
// StringCypher.encrypt "V@/H!!}N)-]6N'%k\"Vje" "myprivatedata" 
// and add the result as environment variable
let email = getEnv "GoogleEmail"
let password = getEnv "GooglePassword"
let android_id = getEnv "AndroidId"

//let gil = Python.Runtime.Py.GIL()

let trackId = "Teaherncwq37g2ebmoaqzl775d4";;

let mb = GMusicAPI.createMobileClient true false true |> PythonInterop.runInPython

let d = GMusicAPI.login mb None email password android_id  |> PythonInterop.runInPython;;
let devices = GMusicAPI.getRegisteredDevices mb |> PythonInterop.runInPython |> Seq.toList
let trackInfo = GMusicAPI.getTrackInfo mb "Teaherncwq37g2ebmoaqzl775d4"  |> PythonInterop.runInPython

GMusicAPI.getAllPlaylists mb true |> PythonInterop.runInPython
GMusicAPI.getAllUserPlayListContents mb  |> PythonInterop.runInPython
GMusicAPI.getSharedPlaylistContents mb "AMaBXykNDUriQwFYwHcuH3tLgKC9fCMZsm7KhfXLdVvBHOK8egCU1UvfIB7k0qZ2PWNN2MJu_kpo-YEkY5V27IV8yUw-yU6WJw==" |> PythonInterop.runInPython
//gil.Dispose()
// Define your library scripting code here

