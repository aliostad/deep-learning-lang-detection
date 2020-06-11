namespace VRTest

open System
open Aardvark.Base
open Aardvark.Base.Rendering
open Aardvark.Base.Incremental
open Aardvark.SceneGraph
open Aardvark.SceneGraph.IO
open Aardvark.Application
open Aardvark.Application.WinForms


module VRTest =


    let helloWorld () =
        use app = new OpenGlApplication()
        let win = app.CreateSimpleRenderWindow()

        let runtime = app.Runtime

        let quadSg =
            let quad =
                let index = [|0;1;2; 0;2;3|]
                let positions = [|V3f(-1,-1,0); V3f(1,-1,0); V3f(1,1,0); V3f(-1,1,0) |]

                IndexedGeometry(IndexedGeometryMode.TriangleList, index, 
                                SymDict.ofList [DefaultSemantic.Positions, positions :> Array], SymDict.empty)

            // create a scenegraph given the indexedGeometry containing a quad
            quad |> Sg.ofIndexedGeometry


        let initial = CameraView.lookAt (V3d.III * 5.0) V3d.OOO V3d.OOI
        let cameraView = DefaultCameraController.control win.Mouse win.Keyboard win.Time initial

        let frustum = Frustum.perspective 60.0 0.01 100.0 1.0
        let proTrafo = Frustum.projTrafo frustum

        let viewTrafo = Mod.map CameraView.viewTrafo cameraView

        let models =
            [
                @"C:\Aardwork\sponza\sponza.obj", Trafo3d.Scale 0.01
                @"C:\Aardwork\witcher\geralt.obj", Trafo3d.Translation(0.0, 0.0, 1.0)
                @"C:\Aardwork\ironman\ironman.obj", Trafo3d.Scale 0.5 * Trafo3d.Translation(2.0, 0.0, 0.0)
                //@"C:\Aardwork\Stormtrooper\Stormtrooper.dae", Trafo3d.Scale 0.5 * Trafo3d.Translation(-2.0, 0.0, 0.0)
                @"C:\Aardwork\lara\lara.dae", Trafo3d.Scale 0.5 * Trafo3d.Translation(-2.0, 0.0, 0.0)
            ]

        let assimpFlags = 
            Assimp.PostProcessSteps.CalculateTangentSpace |||
            Assimp.PostProcessSteps.GenerateSmoothNormals |||
            //Assimp.PostProcessSteps.FixInFacingNormals ||| 
            //Assimp.PostProcessSteps.JoinIdenticalVertices |||
            Assimp.PostProcessSteps.FindDegenerates |||
            //Assimp.PostProcessSteps.FlipUVs |||
            //Assimp.PostProcessSteps.FlipWindingOrder |||
            Assimp.PostProcessSteps.MakeLeftHanded ||| 
            Assimp.PostProcessSteps.Triangulate
   
                   
        let scene =
            let flip = Trafo3d.FromBasis(V3d.IOO, V3d.OOI, -V3d.OIO, V3d.Zero)
            models
                |> List.map (fun (file, trafo) -> Loader.Assimp.Load(file, assimpFlags) |> Sg.AdapterNode |> Sg.transform (flip * trafo))
                |> Sg.ofList
                |> Sg.effect [
                    DefaultSurfaces.trafo |> toEffect
                    DefaultSurfaces.constantColor C4f.White |> toEffect
                    DefaultSurfaces.diffuseTexture |> toEffect
                    DefaultSurfaces.normalMap |> toEffect
                    DefaultSurfaces.lighting false |> toEffect
                ]
             
        let sg =
            scene 
                |> Sg.viewTrafo viewTrafo
//                |> Sg.projTrafo (Mod.constant Trafo3d.Identity) 
                |> Sg.projTrafo (Mod.constant proTrafo) 
//                |> Sg.effect [
//                    DefaultSurfaces.trafo |> toEffect                   // compose shaders by using FShade composition.
//                    DefaultSurfaces.constantColor C4f.Red |> toEffect   // use standard trafo + map a constant color to each fragment
//                   ]

        let renderTask = runtime.CompileRender(win.FramebufferSignature, sg)
        win.RenderTask <- renderTask

        win.Run()

        0





