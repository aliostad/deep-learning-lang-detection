﻿module SuaveMusicStore.Path

type IntPath = PrintfFormat<(int -> string), unit, string, string, int>

let withParam (key,value) path = sprintf "%s?%s=%s" path key value

let home = "/"

module Store =
    let overview = "/store"
    let browse = "/store/browse"
    let browseKey = "genre"
    let details : IntPath = "/store/details/%d"

module Admin =
    let manage = "/admin/manage"
    let deleteAlbum : IntPath = "/admin/delete/%d"
    let createAlbum = "/admin/create"
    let editAlbum : IntPath = "/admin/edit/%d"

module Account =
    let logon = "/account/logon"
    let logoff = "/account/logoff"
    let register = "/account/register"

module Cart =
    let overview = "/cart"
    let addAlbum : IntPath = "/cart/add/%d"
    let removeAlbum : IntPath = "/cart/remove/%d"
    let checkout = "/cart/checkout"