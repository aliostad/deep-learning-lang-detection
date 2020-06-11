module Images = 
    let extensions = [ "gif"; "jpeg"; "jpg"; "png"; "bmp"; "svg" ]
    let Get path = Files.GetByExt path extensions
    let GetSource = Filename.ToSource Get
    let GetTarget = Filename.ToTarget Get
    let Copy source target = Files.Copy GetSource source target
    let Delete source = Files.Delete GetTarget source
    let Move source target = Files.Move GetSource source target

module Apps = 
    let extensions = ["msi";"exe"]
    let Get path = Files.GetByExt path extensions
    let GetSource = Filename.ToSource Get
    let GetTarget = Filename.ToTarget Get
    let Copy source target = Files.Copy (GetSource) source target
    let Delete source = Files.Delete (GetTarget) source
    let Move source target = Files.Move GetSource source target