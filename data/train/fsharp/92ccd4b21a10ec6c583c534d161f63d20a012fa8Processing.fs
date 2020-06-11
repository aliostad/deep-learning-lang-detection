//===============================================================================
// Microsoft patterns & practices
// Parallel Programming Guide
//===============================================================================
// Copyright © Microsoft Corporation.  All rights reserved.
// This code released under the terms of the 
// Microsoft patterns & practices license (http://parallelpatterns.codeplex.com/license).
//===============================================================================

module Microsoft.Practices.ParallelGuideSamples.ImageBlender.Example

open System
open System.IO
open System.Drawing
open System.Windows.Forms
open System.Threading.Tasks
open System.Drawing.Drawing2D
open Microsoft.Practices.ParallelGuideSamples.Utilities
open Microsoft.Practices.ParallelGuideSamples.ImageBlender.Extensions

// ------------------------------------------------------------------------------
// Implementation of the parallel bitmap processing
// ------------------------------------------------------------------------------

/// Copy source bitmap to the layer and make the target 
/// grayscale and partially transparent (sequentially)
let private setToGray (source:Bitmap) (layer:Bitmap) =
    source.CopyPixels(layer)
    layer.SetGray() 
    layer.SetAlpha(128)

/// Copy source bitmap to the layer, rotate it (by 90 degrees)
/// and make it partially transparent (sequentially)
let private rotate (source:Bitmap) (layer:Bitmap) =
    source.CopyPixels(layer)
    layer.RotateFlip(RotateFlipType.Rotate90FlipNone)
    layer.SetAlpha(128)

/// Alpha blend - draw both of the layers on the result bitmap
/// (using Graphics.DrawImage method) (sequentially)
let private blend (layer1:Bitmap) (layer2:Bitmap) (blender:Graphics) =
    blender.DrawImage(layer1, 0, 0)
    blender.DrawImage(layer2, 0, 0)


/// Prcess both source images sequentially and blend them (sequentially)
let SeqentialImageProcessing source1 source2 layer1 layer2 blender =
    setToGray source1 layer1
    rotate source2 layer2
    blend layer1 layer2 blender
    source1.Width

/// Process both source images (in parallel using Tasks) and then blend them 
let ParallelTaskImageProcessing source1 source2 layer1 layer2 blender =
    let toGray = Task.Factory.StartNew(fun () -> setToGray source1 layer1)
    let rotate = Task.Factory.StartNew(fun () -> rotate source2 layer2)
    Task.WaitAll(toGray, rotate)
    blend layer1 layer2 blender
    source1.Width

/// Process both source images (in parallel using Parallel.Invoke) and then blend them
let ParallelInvokeImageProcessing source1 source2 layer1 layer2 blender =
    Parallel.Invoke
      ( new Action(fun () -> setToGray source1 layer1),
        new Action(fun () -> rotate source2 layer2) )
    blend layer1 layer2 blender
    source1.Width