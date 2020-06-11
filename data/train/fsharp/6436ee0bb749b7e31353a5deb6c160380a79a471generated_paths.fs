module generated_paths

open Suave
open Suave.Filters
open Suave.Successful
open Suave.Operators
open Suave.Model.Binding
open Suave.Form
open Suave.ServerErrors
open forms
open helper_handler
open generated_handlers

type Int64Path = PrintfFormat<(int64 -> string),unit,string,string,int64>

let path_home = "/"
let path_register = "/register"
let path_login = "/login"
let path_view_product : Int64Path = "/product/view/%i"
let path_search_product = "/product/search"
let path_view_cart : Int64Path = "/cart/view/%i"
let path_add_to_cart = "/cart/add"
let path_checkout = "/checkout"
let path_thanks = "/thanks"

let path_api_register = "/api/register"
let path_api_user : Int64Path = "/api/user/%i"
let path_api_product : Int64Path = "/api/product/%i"
let path_api_search_product = "/api/product/search"
let path_api_create_product = "/api/product/create"
let path_api_edit_product = "/api/product/edit"
let path_api_delete_product : Int64Path = "/api/product/delete/%i"
let path_api_cart : Int64Path = "/api/cart/%i"
let path_api_create_cart = "/api/cart/create"
let path_api_add_to_cart = "/api/cart/add"
let path_api_checkout = "/api/checkout"

let generated_routes =
  [
    path path_home >=> home
    path path_register >=> register
    path path_login >=> login
    pathScan path_view_product view_product
    path path_search_product >=> search_product
    pathScan path_view_cart view_cart
    path path_checkout >=> checkout
    path path_add_to_cart >=> add_to_cart
    path path_thanks >=> thanks

    path path_api_register >=> api_register
    pathScan path_api_product api_product
    path path_api_search_product >=> api_search_product
    path path_api_create_product >=> api_create_product
    path path_api_edit_product >=> api_edit_product
    pathScan path_api_delete_product api_delete_product

    pathScan path_api_cart api_cart
    path path_api_create_cart >=> api_create_cart
    path path_api_add_to_cart >=> api_add_to_cart

    path path_api_checkout >=> api_checkout
  ]
