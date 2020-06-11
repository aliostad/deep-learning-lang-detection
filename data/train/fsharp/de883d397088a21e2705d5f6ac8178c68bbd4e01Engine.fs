namespace VyrEngine

open VyrCore
open VyrCore.Graphics

module Engine =

// Windows platform
#if _WIN32
    let initializeGraphics renderingAPI =
        match renderingAPI with
        | RenderingAPI.OpenGL -> VyrGraphics.GLGraphics() :> IGraphics
        | _ -> failwith "Not yet implemented"

#endif

// Android Platform
#if __ANDROID__
        /// Initializes a new graphics window (param data is inside engineMode) (probably use OpenTK-Window? or Glew??)
    let initializeWindow renderingAPI = failwith "Not yet implemented"

    let initializeControl renderingAPI = failwith "Not yet implemented"
#endif

// iOS Platform

// Linux Platform

// WebGL?