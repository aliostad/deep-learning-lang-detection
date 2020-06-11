open System.IO

let delDir dir =
    let dirInfo = new DirectoryInfo(dir)
    for file in dirInfo.GetFiles() do
        file.Delete() |> ignore
    for dir in dirInfo.GetDirectories() do
        dir.Delete(true) |> ignore

try
    delDir "Packaged/Pikatwo/responseData"
    delDir "Packaged/Pikatwo"
with
    _ -> ()

let defaultAuthFile = 
    "[
        {
            \"Hostmask\": \"EnterHostmaskHere\",
            \"AuthLevel\": 2
        }
]"
            
let defaultConfigFile =
    "{
    \"Nick\": \"pikatwo\",
    \"Password\": \"thisprobablyisntyourpassword\",
	\"Port\": \"6667\",
	\"Server\": \"chat.freenode.net\",
	\"RealName\": \"pikatwo\",
	\"UserName\": \"zalzane.b\",
	\"Channels\": 
	[
		\"#pikadev\",
		\"#ufeff\"
	]
}"

let defaultGithubConfig =
    "{
	\"SubscribedProjects\":
		[
		],
	\"RssUrl\": \"github.com/your_rss_url\"
}"

let defaultGithubAnnounceHistory =
    "[]"

try
    File.Copy("Release/Pikatwo.exe", "Packaged/Pikatwo/Pikatwo.exe")
    File.Copy("Release/Newtonsoft.Json.dll", "Packaged/Pikatwo/Newtonsoft.Json.dll")
    File.Copy("Release/StarkSoftProxy.dll", "Packaged/Pikatwo/StarkSoftProxy.dll")
    File.Copy("Release/Meebey.SmartIrc4net.dll", "Packaged/Pikatwo/Meebey.SmartIrc4net.dll")
    File.Copy("Release/log4net.dll", "Packaged/Pikatwo/log4net.dll")
    File.Copy("Release/HtmlAgilityPack.dll", "Packaged/Pikatwo/HtmlAgilityPack.dll")
    File.Copy("LICENCE", "Packaged/Pikatwo/LICENCE")
    File.Copy("Readme.md", "Packaged/Pikatwo/Readme.md")
    File.WriteAllText("Packaged/Pikatwo/auth.json",defaultAuthFile)
    File.WriteAllText("Packaged/Pikatwo/config.json",defaultConfigFile)
    File.WriteAllText("Packaged/Pikatwo/githubAnnounceHistory.json",defaultGithubAnnounceHistory)
    File.WriteAllText("Packaged/Pikatwo/githubConfig.json",defaultGithubConfig)
    let responseFiles = Directory.GetFiles("Release/responseData")
    Directory.CreateDirectory("Packaged/Pikatwo/responseData") |> ignore
    for i in 0..(responseFiles.Length-1) do
        File.Copy(responseFiles.[i], "Packaged/Pikatwo/responseData/" + string i + ".json")
with
    :? System.IO.FileNotFoundException -> System.Console.WriteLine("not all required files were found to create package")