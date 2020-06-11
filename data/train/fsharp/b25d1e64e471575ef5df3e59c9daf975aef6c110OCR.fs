module OCR

open Types
open Google.Cloud.Vision.V1

let processImage image = 
    let client = ImageAnnotatorClient.Create()
    let response = client.DetectText(image)
    [for anno in response do yield  { Description = anno.Description; Verticies = [for v in anno.BoundingPoly.Vertices do yield { X = v.X; Y = v.Y }]}]

let getFromGoogle fileName =    
    let image = Image.FromFile(sprintf "%s" fileName);    
    processImage image

let getFromBytes file = 
    let image = Image.FromBytes(file)
    processImage image