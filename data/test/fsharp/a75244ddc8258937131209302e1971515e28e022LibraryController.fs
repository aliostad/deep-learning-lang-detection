namespace Fantastica.Controllers

open System
open System.Collections.Generic
open System.Linq
open System.Web
open System.Web.Mvc
open System.Web.Mvc.Ajax
open System.Net;
open System.Web.Http;
open Fantastica.Models;
open Fantastica.Api.Entities
open Fantastica.Api

type LibraryController() =
    inherit ApiController()
    
    let mp3s = DataStore.Instance.SongRepository.FindAll()
    
    member x.Get([<FromUri>]filter:string) =
      TagReader.filterSongs(Seq.toList(mp3s) , filter)

    member x.Put([<FromBody>]songIds:string array)=
        DataStore.Instance.SongRepository.Find(fun (s:Song) -> songIds.Contains(s.Id))