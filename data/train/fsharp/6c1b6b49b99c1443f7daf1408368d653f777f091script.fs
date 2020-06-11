module script

open dsl
open generator

let someSite () =

  db Postgres

  dbPassword "NOTSecure1234"

  site "Best Online Store"

  basic home

  basic registration

  basic login

  page "Product" CVELS
    [
      text      "Name"          Required
      text      "Description"   Required
      dollar    "Price"         Required
      text      "Category"      Required
    ]

  page "Cart" CVEL
    [
      fk        "Register"
    ]

  page "CartItem" CVEL
    [
      fk        "Cart"
      fk        "Product"
    ]

  advancedPage "Checkout" CVEL RequiresLogin
    [
      fk        "Cart"
    ]

  api "User"
  api "Product"
  api "Cart"
  api "Checkout"

  currentSite
