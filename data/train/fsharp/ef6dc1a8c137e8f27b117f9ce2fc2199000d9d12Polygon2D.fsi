namespace Foom.Geometry

open System.Numerics

type Polygon2D

[<CompilationRepresentationAttribute (CompilationRepresentationFlags.ModuleSuffix)>]
module Polygon2D =

    val create : vertices: Vector2 seq -> Polygon2D

    val isArrangedClockwise : poly: Polygon2D -> bool

    val containsPoint : Vector2 -> Polygon2D -> bool

    val copyVertices : Polygon2D -> Vector2 []

    val iteri : (int -> Vector2 -> unit) -> Polygon2D -> unit

    val maxBy<'T when 'T : comparison> : (Vector2 -> 'T) -> Polygon2D -> Vector2

    val item : int -> Polygon2D -> Vector2

    val findIndex : (Vector2 -> bool) -> Polygon2D -> int

    val vertexCount : Polygon2D -> int