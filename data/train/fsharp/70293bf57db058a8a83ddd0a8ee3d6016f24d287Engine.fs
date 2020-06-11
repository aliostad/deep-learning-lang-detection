namespace FsDither

module Treshold = 
    let processLayer quantize layer =
        layer |> Matrix.pmap quantize

module Random = 
    open System

    let processLayer amplify quantize layer =
        let rng = Random()
        let inline gen () = rng.NextDouble() - 0.5
        let processPixel v = v + gen () * amplify |> quantize
        layer |> Matrix.map processPixel

module Bayer =
    let private createMatrix m = 
        let m = m |> array2D
        let w, h = Matrix.sizeOf m
        let area = w * h
        m |> Matrix.pmap (fun v -> float v / float (area + 1) - 0.5)

    let bayer2x2 = [ [1; 3]; [4; 2] ] |> createMatrix
    let bayer3x3 = [ [3; 7; 4]; [6; 1; 9]; [2; 8; 5] ] |> createMatrix
    let bayer4x4 = [ [1; 9; 3; 11]; [13; 5; 15; 7]; [4; 12; 2; 10]; [16; 8; 14; 6] ] |> createMatrix
    let bayer8x8 = 
        [
            [1; 49; 13; 61; 4; 52; 16; 64]
            [33; 17; 45; 29; 36; 20; 48; 32]
            [9; 57; 5; 53; 12; 60; 8; 56]
            [41; 25; 37; 21; 44; 28; 40; 24]
            [3; 51; 15; 63; 2; 50; 14; 62]
            [35; 19; 47; 31; 34; 18; 46; 30]
            [11; 59; 7; 55; 10; 58; 6; 54]
            [43; 27; 39; 23; 42; 26; 38; 22] 
        ] |> createMatrix

    let inline processLayer matrix quantize layer =
        let height, width = matrix |> Matrix.sizeOf
        let inline processPixel y x v = v + matrix.[y % height, x % width] |> quantize
        layer |> Matrix.pmapi processPixel

module FloydSteinberg =
    open Value

    let processLayer quantize input =
        let height, width = Matrix.sizeOf input
        let output = Matrix.zeroCreate height width
        let yH = height - 1

        let inline processRow (cy0: Value[]) y =
            let cy1 = Array.zeroCreate (width + 2)
            let xW = width - 1

            let inline calculateValue x c = 
                let expected = input.[y, x] + cy0.[x + 1] + c
                let actual = quantize expected
                output.[y, x] <- actual
                expected - actual

            let inline diffuseError x error =
                let error' = error / 16.0
                let inline diffuseDown x error ratio = 
                    cy1.[x + 1] <- cy1.[x + 1] + error * ratio
                diffuseDown (x - 1) error' 3.0
                diffuseDown x error' 5.0
                diffuseDown (x + 1) error' 1.0
                error' * 7.0

            let inline processPixel c x = 
                c |> calculateValue x |> diffuseError x

            (0, xW) |> Range.fold processPixel 0.0 |> ignore

            cy1

        let cy0 = Array.zeroCreate (width + 2)
        (0, yH) |> Range.fold processRow cy0 |> ignore

        output

module PFloydSteinberg = 
    open Value

    type internal Patch = { XC: int; Y0: int; Width: int; Height: int }

    let internal enumeratePatches (h, w) (imageHeight, imageWidth) =
        let inline moveE (y0, xc) = (y0, xc + w)
        let inline moveSW (y0, xc) = (y0 + h, xc - w - h - 1)
        let inline extent (y0, xc) = 
            let y1 = (y0 + h |> min imageHeight) - 1
            let ph' = y1 - y0 + 1
            let x1 = (xc + w |> min imageWidth) - 1
            let x0 = xc - ph' + 1
            (y0, x0, y1, x1)
        let inline overlaps (y0, x0, y1, x1) = 
            y1 >= 0 && x1 >= 0 && y0 < imageHeight && x0 < imageWidth
        let rec walk ((y0, xc) as p) =
            let finished = y0 >= imageHeight
            let patch = extent p
            seq {
                match finished, patch |> overlaps with
                | true, _ -> ()
                | _, true -> yield (y0, xc); yield! walk (moveE p)
                | _ -> yield! walk (moveSW p)
            }
        let rec fork ((y0, xc) as p) =
            let inline finished (y0, _, _, x1) = y0 >= imageHeight || x1 < 0
            let patch = extent p
            seq {
                match finished patch with
                | true -> ()
                | _ -> yield (y0, xc); yield! fork (moveSW p)
            }
        let makePatch ((y0, xc) as p) =
            let _, _, y1, _ = extent p 
            { XC = xc; Y0 = y0; Width = w; Height = y1 - y0 + 1 }

        (0, 0) |> walk |> Seq.map (fork >> Seq.map makePatch)

    let private processPatch quantize (input: Value[,]) (output: Value[,]) (patch: Patch) =
        let imageHeight, imageWidth = Matrix.sizeOf output
        let { Patch.XC = xC; Patch.Y0 = y0; Patch.Height = h; Patch.Width = w } = patch
        let yH = y0 + h - 1

        let cx = Array.zeroCreate h

        let inline update y x v = output.[y, x] <- output.[y, x] + v
        let inline lcapx x = x |> max 0
        let inline hcapx x = x |> min (imageWidth - 1)

        let inline processRow y =
            let r = y - y0
            let cy = Array.zeroCreate (w + 2)

            let inline setcy x v = let x' = x - xC + r + 1 in cy.[x'] <- cy.[x'] + v

            let inline calculateValue x c =
                let expected = input.[y, x] + output.[y, x] + c
                let actual = quantize expected
                output.[y, x] <- actual
                expected - actual

            let inline diffuseError x error =
                let error' = error / 16.0
                let inline diffuseDown x ratio = setcy x (error' * ratio)
                diffuseDown (x - 1) 3.0
                diffuseDown x 5.0
                diffuseDown (x + 1) 1.0
                error' * 7.0

            let inline processPixel c x = c |> calculateValue x |> diffuseError x

            let x0 = xC - r
            let xW = xC + w - r - 1

            cx.[r] <- (lcapx x0, hcapx xW) |> Range.fold processPixel 0.0
            if y + 1 < imageHeight then
                (lcapx x0, hcapx (xW + 1)) |> Range.iter (fun x -> update (y + 1) x cy.[w + x - xW])

        (y0, yH) |> Range.iter processRow

        let r0 = xC + w - (imageWidth - 1) |> max 0 // solve for r: xC - r + w <= iW - 1
        let rH = xC + w - 1 |> min (h - 1) // solve for r: xC - r + w >= 1
        (r0, rH) |> Range.iter (fun r -> update (y0 + r) (xC + w - r) cx.[r])

    let processLayer quantize input =
        let (height, width) as size = input |> Matrix.sizeOf 
        let output = Matrix.zeroCreate height width
        size
        |> enumeratePatches (128, 128)
        |> Seq.iter (Seq.piter (processPatch quantize input output))

        output
