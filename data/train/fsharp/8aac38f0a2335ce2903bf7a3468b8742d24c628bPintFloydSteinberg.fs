namespace FsDither

module PintFloydSteinberg = 
    open PFloydSteinberg

    let toFloat iv = (float iv / 65536.0) |> max 0.0 |> min 1.0
    let fromFloat v = v * 65536.0 |> round |> int

    let private processPatch levels (input: int[,]) (output: int[,]) (patch: Patch) =
        let imageHeight, imageWidth = Matrix.sizeOf output
        let { XC = xC; Y0 = y0; Height = h; Width = w } = patch
        let yH = y0 + h - 1

        let cx = Array.zeroCreate h

        // integer quantizer
        let quantizerSteps = levels - 1
        let quantizerStepWidth = (0x10000 / quantizerSteps) >>> 1
        let inline quantize v = 
            (((v + quantizerStepWidth) * quantizerSteps) &&& ~~~0xFFFF) / quantizerSteps 
            |> max 0 |> min 0x10000

        let inline update y x v = output.[y, x] <- output.[y, x] + v
        let inline lcapx x = x |> max 0
        let inline hcapx x = x |> min (imageWidth - 1)

        let inline processRow y (cy0: int[]) =
            let r = y - y0
            let cy1 = Array.zeroCreate (w + 2)

            let inline getcy0 x = cy0.[x - xC + r]
            let inline setcy1 x v = let x' = x - xC + r + 1 in cy1.[x'] <- cy1.[x'] + v

            let inline calculateValue x c =
                let expected = input.[y, x] + output.[y, x] + getcy0 x + c
                let actual = quantize expected
                output.[y, x] <- actual
                expected - actual

            // integer diffusor
            let inline diffuseError x error =
                let error4 = error <<< 2
                let inline div16round v = (v + 8) >>> 4
                let inline diffuseDown x error = setcy1 x (error |> div16round)
                diffuseDown (x - 1) (error4 - error)
                diffuseDown x (error4 + error)
                diffuseDown (x + 1) error
                (error4 <<< 1) - error |> div16round

            let inline processPixel x c = c |> calculateValue x |> diffuseError x

            let x0 = xC - r
            let xW = xC + w - r - 1

            let mutable c = 0
            for x = lcapx x0 to hcapx xW do 
                c <- processPixel x c
            cx.[r] <- c

            if y + 1 < imageHeight then
                for x = lcapx xW to hcapx (xW + 1) do
                    update (y + 1) x cy1.[w + x - xW]

            cy1 // carry to next row

        let inline finalizePatch (cx: int[]) (cy: int[]) =
            for r = 0 to h - 1 do
                let x = xC - r + w
                if x >= 0 && x < imageWidth then
                    update (y0 + r) x cx.[r]

            if yH + 1 < imageHeight then 
                let x0 = xC - h
                let x1 = x0 + w - 1 |> min (imageWidth - 1)
                for x = x0 |> max 0 to x1 do
                    update (yH + 1) x cy.[x - x0]

        let mutable cy = Array.zeroCreate (w + 2)
        for y = y0 to yH do
            cy <- processRow y cy

        finalizePatch cx cy

    let processLayer quantize input =
        let (height, width) as size = input |> Matrix.sizeOf 
        let output = Matrix.zeroCreate height width
        size
        |> enumeratePatches (128, 128)
        |> Seq.iter (Seq.piter (processPatch quantize input output))

        output
