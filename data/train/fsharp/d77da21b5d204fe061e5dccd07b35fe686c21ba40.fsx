// origional code from http://stackoverflow.com/questions/10765860/decrypt-wep-wlan-profile-key-using-cryptunprotectdata, taken an F#'d up.

open System
open System.Diagnostics
open System.Runtime.InteropServices

let getWinlogonPID name = 
  Process.GetProcessesByName name
  |> Seq.head
  |> fun ps -> ps.Id

let ERROR_SUCCESS                        = 0
let TOKEN_QUERY, TOKEN_ADJUST_PRIVILEGES = 0x0008u, 0x0020u
let MAXIMUM_ALLOWED                      = 0x2000000u

let CRYPT_STRING_HEX                     = 0x00000004u
let CRYPT_STRING_HEXASCII                = 0x00000005u

let SE_PRIVILEGE_ENABLED_BY_DEFAULT      = 0x00000001u
let SE_PRIVILEGE_ENABLED                 = 0x00000002u
let SE_PRIVILEGE_REMOVED                 = 0x00000004u
let SE_PRIVILEGE_USED_FOR_ACCESS         = 0x80000000u

let SE_ASSIGNPRIMARYTOKEN_NAME           = "SeAssignPrimaryTokenPrivilege"
let SE_BACKUP_NAME                       = "SeBackupPrivilege"
let SE_DEBUG_NAME                        = "SeDebugPrivilege"
let SE_INCREASE_QUOTA_NAME               = "SeIncreaseQuotaPrivilege"
let SE_TCB_NAME                          = "SeTcbPrivilege"


[<Struct>]
type DATA_BLOB = 
  val mutable cbData         : uint32
  val mutable bytes          : nativeint

[<Struct>]
type LUID =
  val mutable lowPart        : uint32
  val mutable highPart       : int

[<Struct>]
type LUID_AND_ATTRIBUTES = 
  val mutable luid           : LUID
  val mutable attributes     : uint32

[<Struct>]
type TOKEN_PRIVILEGES =
  val mutable privilegeCount : uint32
  val mutable privileges     : LUID_AND_ATTRIBUTES

[<DllImport "advapi32">]
extern bool LookupPrivilegeValue(
  string            lpSystemName, 
  string            lpName,
  LUID&             lpLuid)

[<DllImport ("advapi32", SetLastError=true)>]
extern bool AdjustTokenPrivileges(
  nativeint         TokenHandle, 
  bool              DisableAllPrivileges, 
  TOKEN_PRIVILEGES& NewState, 
  uint32            Bufferlength, 
  TOKEN_PRIVILEGES& PreviousState, 
  int&              ReturnLength)

[<DllImport "advapi32" >]
extern bool OpenProcessToken(
  nativeint         ProcessHandle,
  uint32            DesiredAccess, 
  nativeint&        TokenHandle)

[<DllImport "kernel32">]
extern nativeint OpenProcess(
  uint32            dwDesiredAccess, 
  bool              bInheritHandle, 
  int               dwProcessId)

[<DllImport( "crypt32", SetLastError=true)>]
extern bool CryptStringToBinary( 
  string            pszString, 
  uint32            cchString, 
  uint32            dwFlags,
  nativeint         pbBinary, 
  uint32&           pcbBinary, 
  uint32&           pdwSkip, 
  uint32&           pdwFlags)


[<DllImport("crypt32", SetLastError=true)>]
extern bool CryptUnprotectData(
    DATA_BLOB&      pDataIn, 
    string          szDataDescr, 
    uint32          pOptionalEntropy, 
    nativeint       pvReserved, 
    uint32          pPromptStruct, 
    uint32          dwFlags, 
    DATA_BLOB&      pDataOut)
    
[<DllImport "kernel32">]
extern bool CloseHandle(nativeint hObject)

[<DllImport( "advapi32", SetLastError=true)>]
extern bool ImpersonateLoggedOnUser(nativeint hToken)

let errorHandle s = 
  let err = Marshal.GetLastWin32Error()
  fprintf stdout "%s, error=%d" s err
  exit -1

let SeSetCurrentPrivilege pszPrivilege bEnablePrivilege =
  
  let mutable NULL       = 0
  let mutable nullToken  = Unchecked.defaultof<_>
  let mutable luid       = LUID()
  let mutable hToken     = 0n
  let mutable tp         = TOKEN_PRIVILEGES()
  let mutable tpPrevious = TOKEN_PRIVILEGES()
  let mutable cbPrevious = sizeof<TOKEN_PRIVILEGES>

  let privs = LookupPrivilegeValue(null, pszPrivilege, &luid)

  if not privs then errorHandle "[+] could not lookup privileges, exiting"
    
  let currentPh = Process.GetCurrentProcess().Handle
  let ps        = OpenProcessToken(currentPh,TOKEN_QUERY|||TOKEN_ADJUST_PRIVILEGES,&hToken) 

  if not ps then errorHandle "[+] could not open process."

  tp.privilegeCount <- 1u
  tp.privileges     <- LUID_AND_ATTRIBUTES(luid=luid,attributes=0u)
  
  let dwReturn = 
    AdjustTokenPrivileges(
      hToken, 
      false, 
      &tp, 
      uint32 sizeof<TOKEN_PRIVILEGES>, 
      &tpPrevious, 
      &cbPrevious)

  if dwReturn then 

    let tpa = tpPrevious.privileges.attributes
    let adjustPrivAttr (tk : TOKEN_PRIVILEGES) newval = 
      tk.privileges.attributes <- newval

    tpPrevious.privilegeCount  <- 1u
    tpPrevious.privileges.luid <- luid

    if bEnablePrivilege then
      adjustPrivAttr tpPrevious (tpa ||| SE_PRIVILEGE_ENABLED)
    else
      adjustPrivAttr tpPrevious (tpa ^^^ (SE_PRIVILEGE_ENABLED &&& tpa))

    let dwReturn = 
      AdjustTokenPrivileges(
        hToken,
        false,
        &tpPrevious,
        uint32 cbPrevious,
        &nullToken,
        &NULL)

    if dwReturn then true
    else 
      printfn "AdjustTokenPrivileges failed. 2"
      CloseHandle hToken |> ignore
      false
  else
    printfn "AdjustTokenPrivileges failed. 1"
    CloseHandle hToken |> ignore
    false
    
// whatevs    
let getNameAndPw (s : string) = 
  let x1, x2 = s.IndexOf "<name>"+6, s.IndexOf "</name>"-1
  let y1, y2 = s.IndexOf "<keyMaterial>"+13, s.IndexOf "</keyMaterial>"-1
  try s.[x1..x2],s.[y1..y2] with _ -> "",""

let getXmlSsidAndPass () = 
  let dir = @"C:\ProgramData\Microsoft\Wlansvc\Profiles\Interfaces\"

  let maybe f x y = 
    try f(x,y) |> Seq.cast<string> with _ -> Seq.empty

  let enumFiles = maybe IO.Directory.EnumerateFiles
  let enumDirs  = maybe IO.Directory.EnumerateDirectories

  let rec loop dir pattern =
    seq { yield! enumFiles dir pattern
          for d in enumDirs dir "*" do
            yield! loop d pattern }

  loop dir "*.xml"

let decodeWifiKey szKey = 

  let mutable hProcessToken = 0n
  let mutable dwFlags       = 0u
  let mutable dwSkip        = 0u
 
  let dwProcessId = getWinlogonPID "winlogon"

  if dwProcessId = 0 then
    errorHandle "couldn't get winlogon.exe process Id"

  let bIsSuccess = SeSetCurrentPrivilege SE_DEBUG_NAME true
  if not bIsSuccess then
    errorHandle "couldn't set SeDebugPrivilege" 

  let hProcess = OpenProcess(MAXIMUM_ALLOWED,false,dwProcessId)
  if hProcess = 0n then 
    errorHandle (sprintf "couldnt OpenProcess on %d" hProcess)

  let bIsSuccess = OpenProcessToken(hProcess,MAXIMUM_ALLOWED,&hProcessToken)
  if not bIsSuccess && hProcessToken = 0n then
    errorHandle "could not OpenProcessToken"
  
  let bIsSuccess = ImpersonateLoggedOnUser hProcessToken
  if not bIsSuccess then
    errorHandle "could not ImpersonateLoggedOnUser"
 
  let mutable cbBinary = 1024u
  
  let mutable byKey = Marshal.AllocHGlobal (int cbBinary)
  if byKey = 0n then errorHandle "could not Alloc"
  
  let bIsSuccess = 
    CryptStringToBinary(
      szKey, uint32 szKey.Length, 
      CRYPT_STRING_HEX,byKey,&cbBinary,&dwSkip,&dwFlags)

  if not bIsSuccess then
    errorHandle "could not CryptStringToBinary"

  let mutable dataOut = DATA_BLOB()
  dataOut.cbData     <- cbBinary
  dataOut.bytes      <- byKey

  let mutable dataVerify = DATA_BLOB()
  let bIsSuccess = CryptUnprotectData(&dataOut,null,0u,0n,0u,0u,&dataVerify)
  if not bIsSuccess then 
    errorHandle "could not CryptUnprotectData"
    
  else
    if dataVerify.bytes <> 0n then
      Marshal.PtrToStringAnsi dataVerify.bytes
    else
      "couldnt get password"

  
// todo: need to check if elevated.
[<EntryPoint>]
let main _ = 
  getXmlSsidAndPass () 
  |> Seq.map (IO.File.ReadAllText >> getNameAndPw)
  |> Seq.filter (fun (x,y) -> x <> "")
  |> Seq.map (fun (x,y) -> x, decodeWifiKey y)
  |> Seq.iter (printfn "%A")
  0