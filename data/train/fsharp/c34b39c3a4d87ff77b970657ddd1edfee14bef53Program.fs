open iTextSharp.text.pdf
open iTextSharp.text;
open System.IO
open System


let GetDef (variable :string[] ) (number : int)  defaultValue = match variable with 
    | null   -> defaultValue
    | x when x.Length > number  ->  x.[number] 
    | _ -> defaultValue

[<EntryPoint>]
let main argv = 
    if(argv.Length = 0) then
        printfn "Usage: \n \t<app.exe> <pdf file path> <numering format with sign 0 ex. \"_{0:##}\"> \n\n"
            
    let pdfFileName = GetDef argv 0  "sample.pdf"
    let formatNum = GetDef  argv 1  "_{0:000}"
    
    if not  (File.Exists(pdfFileName) ) then
        printfn " File %s does not exist" pdfFileName
    else 
        printfn "Splitting file %s into:" pdfFileName
            
        let dirPath = Path.GetDirectoryName(pdfFileName)
        let pdfFileNameWithoutExt =  Path.GetFileNameWithoutExtension(pdfFileName)
        use reader = new PdfReader(pdfFileName)

        for i = 1 to reader.NumberOfPages   do 
        
            let filename = pdfFileNameWithoutExt  +  String.Format(formatNum,i) + ".pdf"
        
            let document = new Document()

            let pdfCopy = new PdfCopy(document, new FileStream(Path.Combine(dirPath , filename), FileMode.Create));
            document.Open();
 
            let importedPage = pdfCopy.GetImportedPage(reader, i)
            pdfCopy.AddPage(importedPage );
            printfn "%s" filename
            document.Close();

    Console.ReadKey()
    0 // return an integer exit code
