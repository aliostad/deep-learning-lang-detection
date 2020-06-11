open System.Security
open System.Diagnostics
open System.Text
open System

// VARS #######################################################################

let workingDir = """{{working-dir-path}}"""
let interpreter = """cmd.exe"""
let interpreterArguments = """/c {{script-file-path}}"""
let pidFile = """{{pid-file-path}}"""
let execUserName =  """{{exec-user-name}}"""

// CONST ######################################################################

let EXEC_USER_PASSWORD_ENV_VAR_KEY = "CIDER_CI_EXEC_USER_PASSWORD"

// FUN ########################################################################

let removeIfExistsEnvVar (startInfo : ProcessStartInfo, key) =
  if startInfo.EnvironmentVariables.ContainsKey key
    then startInfo.EnvironmentVariables.Remove key
  ()

let overwriteEnvVar (startInfo : ProcessStartInfo, key, value) =
  removeIfExistsEnvVar(startInfo, key)
  startInfo.EnvironmentVariables.Add(key, value)
  ()

let setEnvVars(startInfo : ProcessStartInfo) =
  removeIfExistsEnvVar(startInfo,EXEC_USER_PASSWORD_ENV_VAR_KEY)
  {% for k,v in environment-variables %}
  overwriteEnvVar(startInfo, """{{k}}""", """{{v}}""")
  {% endfor %}
  ()

let envVarOrFail s =
  let pw = System.Environment.GetEnvironmentVariable(s)
  if pw = null then failwith(sprintf "The EnvVar for %s was not found!" s)
    else pw

let execUserPassword _ =
  envVarOrFail EXEC_USER_PASSWORD_ENV_VAR_KEY

let toSecureString s =
    let secureString = new SecureString()
    String.iter secureString.AppendChar s
    secureString

let buildStartInfo _ =
  let si = new ProcessStartInfo()
  si.FileName <- interpreter
  si.Arguments <- interpreterArguments
  si.WorkingDirectory <- workingDir
  si.UseShellExecute <- false
  si.RedirectStandardError <- true
  si.RedirectStandardOutput <- true
  // si.UserName <- execUserName
  // si.Password <- toSecureString(execUserPassword())
  // si.LoadUserProfile <- true
  setEnvVars si
  si

let buildProcess(startInfo : ProcessStartInfo) =
  let proc = new Process()
  proc.StartInfo <- startInfo
  proc

let writePidFile(proc : Process) =
  let pid = proc.Id
  System.IO.File.WriteAllText(pidFile, sprintf "%d" pid)

let runit _ =
  let startInfo = buildStartInfo()
  let proc = buildProcess startInfo
  proc.Start() |> ignore
  writePidFile proc
  proc.WaitForExit()
  let proc_stdout = proc.StandardOutput.ReadToEnd()
  printfn "%s" proc_stdout
  let proc_stderr = proc.StandardError.ReadToEnd()
  eprintfn "%s" proc_stderr
  exit proc.ExitCode

let handleFailure(ex : Exception)=
  eprintf "%s" ex.Message
  exit -1


// RUN  #######################################################################

try
  runit()
with
  | ex -> handleFailure(ex)
