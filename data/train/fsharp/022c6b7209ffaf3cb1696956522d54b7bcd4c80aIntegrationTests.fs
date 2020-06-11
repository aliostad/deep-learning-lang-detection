namespace Exira.IIS.Tests

open System.IO
open System.Net
open System.Net.Sockets
open System.Diagnostics

module IntegrationTests =

    // TODO: Find a better way to recursivly search up the tree till 'iis-ops'
    let buildDirectoryPath =
        DirectoryInfo(Directory.GetCurrentDirectory())
            .Parent
            .Parent
            .Parent
            .Parent
            .FullName

    let findFreeTcpPort () =
        let l = TcpListener(IPAddress.Loopback, 0)
        l.Start()
        let port = (l.LocalEndpoint :?> IPEndPoint).Port
        l.Stop()
        port

    let startProcess executable arguments =
        let startInfo =
            ProcessStartInfo(
                executable,
                arguments,
                CreateNoWindow = true,
                UseShellExecute = false,
                RedirectStandardOutput = true)

        Process.Start startInfo

    let runUntilSuccess maxTries f =
        let rec loop attempt =
            try
                f()
            with _ ->
                if (attempt < maxTries) then loop (attempt + 1)
                else reraise()
        loop 0