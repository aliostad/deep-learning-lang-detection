namespace EvoDistroLisa.Engine

module WBxRender = 
    open System.Windows
    open System.Windows.Media
    open System.Windows.Media.Imaging
    open EvoDistroLisa.Domain

    let inline private toByte v = (float v |> max 0.0 |> min 1.0) * 255.0 |> round |> byte
    let inline private createColor (a, r, g, b) = Color.FromArgb(toByte a, toByte r, toByte g, toByte b)
    let inline private toColorCode (color: Color) = 
        let a, r, g, b = int color.A, int color.R, int color.G, int color.B
        (a <<< 24) ||| 
        ((r * a / 255) <<< 16) ||| 
        ((g * a / 255) <<< 8) ||| 
        ((b * a / 255) <<< 0)
    let inline private copyPoint width height (points: int[]) index { X = x; Y = y } = 
        let index = index <<< 1
        points.[index + 0] <- x * (float width) |> round |> int
        points.[index + 1] <- y * (float height) |> round |> int

    let private zeroColor = (1, 0.5, 0.5, 0.5) |> createColor

    let private renderPolygon width height (bmp: WriteableBitmap) (polygon: Polygon) =
        let brush = 
            let b = polygon.Brush
            (b.A, b.R, b.G, b.B) |> createColor |> toColorCode
        let length = polygon.Points.Length
        let points = Array.zeroCreate ((length + 1) * 2)
        polygon.Points |> Array.iteri (copyPoint width height points)
        copyPoint width height points length polygon.Points.[0]
        bmp.FillPolygon(points, brush, true)

    let private renderScene width height (bmp: WriteableBitmap) (scene: Scene) =
        bmp.Clear(zeroColor)
        scene.Polygons |> Seq.iter (renderPolygon width height bmp)

    let render (bitmap: WriteableBitmap) (scene: Scene) = 
        let width, height = bitmap.PixelWidth, bitmap.PixelHeight
        scene |> renderScene width height bitmap
        bitmap
