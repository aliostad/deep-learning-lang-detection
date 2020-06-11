//F# の詳細 (http://fsharp.net)

open System
open System.IO
open Ionic.Zip


//ディレクトリのコピー
let rec DirectoryCopy (src,dst) = 
    let srcInfo = new DirectoryInfo(src);
    let dstInfo = new DirectoryInfo(dst);

    //コピー先のディレクトリがなければ作成する
    if (not dstInfo.Exists) then 
        dstInfo.Create();
        //dstInfo.Attributes <= srcInfo.Attributes;
    //ファイルのコピー
    for f in srcInfo.GetFiles() do 
        //同じファイルが存在していたら、常に上書きする
        f.CopyTo(dst + "\\" + f.Name, true) |> ignore
    
    //ディレクトリのコピー（再帰を使用）
    for d in srcInfo.GetDirectories() do 
        DirectoryCopy(d.FullName,dst + "\\" + d.Name)

// BJD-Version.zip用のファイルのコピー
let CopyBin(src_base,dst_base) =

    let srcDir = sprintf "%s\\BJD\\out\\" src_base
    let dstDir = sprintf "%s\\BlackJumboDog\\" dst_base

    //dstDirが存在しない場合は、作成する
    if not (Directory.Exists(dstDir)) then Directory.CreateDirectory(dstDir) |> ignore

    //************************************************
    //ファイルコピー
    //************************************************
    //MLが入るまでは、MLなしのOption.defを使用するため、コピーしない
    //let files = ["BJD.exe";"example.pfx";"named.ca";"BJD.exe.config";"Option.def"]
    for f in ["BJD.exe";"example.pfx";"named.ca";"BJD.exe.config"] do
        let src = sprintf "%s\\%s" srcDir f
        let dst = sprintf "%s\\%s" dstDir f
        if not (File.Exists(dst)) then File.Copy(src,dst)

    //************************************************
    //DLLコピー
    //************************************************
    for f in  ["Dhcp";"Dns";"Ftp";"Pop3";"ProxyFtp";"ProxyHttp";"ProxyPop3";"ProxySmtp";"ProxyTelnet";"Remote";"Smtp";"Tftp";"Tunnel";"Web";"Sip";"WebApi"] do
        let src = sprintf "%s\\%sServer.dll" srcDir f
        let dst = sprintf "%s\\%sServer.dll" dstDir f
        if not (File.Exists(dst)) then File.Copy(src,dst)

    let src = sprintf "%s\\Newtonsoft.Json.dll" srcDir
    let dst = sprintf "%s\\Newtonsoft.Json.dll" dstDir
    if not (File.Exists(dst)) then File.Copy(src,dst)


    let src = sprintf "%s\\Option.def" src_base
    let dst = sprintf "%s\\BlackJumboDog\\Option.def" dst_base
    if not (File.Exists(dst)) then File.Copy(src,dst)


    printfn "Finish CopyBin() %s" dstDir

// bjd-src-Version.zip用のファイルのコピー
let CopySrc(src_base,dst_base) = 

    let srcDir = sprintf "%s\\" src_base
    let dstDir = sprintf "%s\\src\\" dst_base

    //dstDirが存在しない場合は、作成する
    if not (Directory.Exists(dstDir)) then Directory.CreateDirectory(dstDir) |> ignore

    //************************************************
    //ファイルコピー
    //************************************************
    for n in ["BJD.sln"] do
        let src = srcDir + "\\" + n
        let dst = dstDir + "\\" + n
        if not (File.Exists(dst)) then File.Copy(src,dst)
    //************************************************
    //ディレクトリコピー
    //************************************************
    for n in  ["BJD";"BJDTest";"FtpServer";"FtpServerTest";"Setup";"SetupFiles";
                "DhcpServer";"DhcpServerTest";"DnsServer";"DnsServerTest";"Pop3Server";"Pop3ServerTest";
                "ProxyFtpServer";"ProxyHttpServer";"ProxyHttpServerTest";"ProxyPop3Server";
                "ProxySmtpServer";"ProxyTelnetServer";"RemoteServer";
                "SmtpServer";"SmtpServerTest";"TftpServer";"TunnelServer";
                "WebServer";"WebServerTest";"SampleServer";"SampleServerTest";"SipServer";"SipServerTest";"WebApiServer";"WebApiServerTest"] do
        let src = srcDir + n
        let dst = dstDir + n
        DirectoryCopy (src,dst)

        //余分なディレクトリは削除する
//        for n in ["obj";"out";"bin";"Debug";"Release"] do
        for n in ["obj";"out";"bin";"Debug";"Release";"Setup"] do
            let f = dst + "\\" + n
            if(Directory.Exists(f)) then 
                Directory.Delete(f,true)

    printfn "Finish CopySrc() %s" dstDir

//Zipファイルへの追加
let rec append(zip:ZipFile,dir,offset) = 
    for f in Directory.GetDirectories(dir) do
        append(zip,f,offset)//ディレクトリがある場合は再帰で処理する
    for f in Directory.GetFiles(dir) do
        let d = Path.GetDirectoryName(f.Substring(offset)) 
        //let v = f.Substring(offset);
        printfn "Adding %s..." d
        //zip.AddFile(f,v) |> ignore
        zip.AddFile(f,d) |> ignore

        //zip.AddFileの使用方法
        //書庫内に"doc"というディレクトリを作って
        //　そこにfilePathを格納するには次のようにする
        //zip.AddFile(filePath, "doc");




//Zipファイルへの作成
let CreateZip(dir,file,dst:string)=
    let src = sprintf "%s\\%s" dir file
    
    //既に存在する場合は削除する
    if (File.Exists(dst)) then File.Delete(dst)

    //Zipファイルの生成
    let zip = new ZipFile()
    append(zip,src,dir.Length+1)
    zip.Save(dst)
    printfn "Finish CreateZip() %s" dst

// Setup.msi のコピー
let CopyMsi(src_base,dst)=
    let src = sprintf "%s\\Setup\\Setup\\Express\\SingleImage\\DiskImages\\DISK1\\\BlackJumboDog.msi" src_base
    if not (File.Exists(dst)) then File.Copy(src,dst)
    printfn "Finish CopyMsi() %s" dst   
    

let GetSize(fileName):int=
    let i = FileInfo(fileName).Length
    int(float(i)/1024.0)

//***************************************************
// Main
//***************************************************

let ver = "5.9.8"//作成するバージョン
let src_base = "c:\\tmp2\\bjd5" //コピー元の基準フォルダ
//let src_base = "X:\\Data\\SRC#2\\BJD\\blackjumbodog" //コピー元の基準フォルダ
let dst_base = "C:\\tmp3" //コピー先の基準フォルダ
let bin = sprintf "%s\\bjd-%s.zip" dst_base ver
let src = sprintf "%s\\bjd-src-%s.zip" dst_base ver
let msi = sprintf "%s\\bjd-%s.msi" dst_base ver


CopyBin(src_base,dst_base)
CopySrc(src_base,dst_base)
CreateZip(dst_base,"BlackJumboDog",bin)
CreateZip(dst_base,"src",src)
CopyMsi(src_base,msi) 

let dt = DateTime.Now
let dateStr = sprintf "%4d/%02d/%02d" dt.Year dt.Month dt.Day

let s1 = GetSize(bin)
printfn "<a href=bin/bjd-%s.zip>%s Ver%s bjd-%s.zip %dKbyte</a><img src=img/new.gif> <span class=R1>要.NET4.0 Client Profile</span>" ver dateStr ver ver s1
let s2 = GetSize(msi)
printfn "<a href=bin/bjd-%s.msi>%s Ver%s bjd-%s.msi %dKbyte</a><img src=img/new.gif> <span class=R1>要.NET4.0 Client Profile</span>" ver dateStr ver ver s2
let s3 = GetSize(src)
printfn "<a href=bin/bjd-src-%s.zip>%s Ver%s bjd-src-%s.zip %dKbyte </a><img src=img/new.gif>" ver dateStr ver ver s3


printfn "Hit any Key"
Console.ReadKey(true)|>ignore
