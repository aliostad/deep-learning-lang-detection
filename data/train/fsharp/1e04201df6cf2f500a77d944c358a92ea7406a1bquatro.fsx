(*** hide ***)
#r "../../../packages/Newtonsoft.Json/lib/net45/Newtonsoft.Json.dll"

namespace Quatro.Entities

open Newtonsoft.Json

type Revision = {
  AsOf : int64
  Text : string
  }
with
  static member Empty =
    { AsOf       = 0L
      Text       = ""
      }
(**
### Quatro - Step 2

As we [converted our model to F#](tres.html), we brought in some immutability.  What we created can form the basis of a
fully operational F# application; but we can do better.  For example, given "faad05f6-c539-44b7-9e94-1b68da4bba57" -
quick!  Is it a post Id?  A page Id?  The text of a really lame blog post?  Also, what is to prevent us from using a
`CommentStatus` value in a spot where a `PostStatus` should go?  (Do you really want your own post to be able to be
flagged as spam?)

To be sure, these same problems exist in most OO realms, and developers manage to keep all the strings separate.
However, just as immutability gets rid of `null` checks, F# has features that go even further, and can help us create a
model where invalid states cannot be represented.  _F# for Fun and Profit_ has a great series on
[Designing with Types](http://fsharpforfunandprofit.com/series/designing-with-types.html), and I highly recommend
reading it; it goes into way more depth that we're going to at this point.

The language feature we're going to use is called **discriminated unions** (or "DUs" for short).  You've probably dealt
with `enum`s in C#; that is the closest parallel to DUs, but there are significant differences.  Like `enum`s, DUs are
an exhaustive list of all expected/valid values.  Unlike `enum`s, though, they are not wrappers over another type; they
are their own type.  Also, each condition does not have to have the same type; it's perfectly valid to have a DU with
one condition that has one type (or no type at all), and other condition with a completely different type.  (We don't
use that with these types.)

OK, enough talking; some code will help it make sense.  One of the forms of a DU is called a single-case discriminated
union; it can be used to wrap primitives to make them more meaningful.  We'll create the following single-case DUs:
*)
type CategoryId = CategoryId of string
type CommentId  = CommentId  of string 
type PageId     = PageId     of string
type PostId     = PostId     of string
type UserId     = UserId     of string
type WebLogId   = WebLogId   of string

type Permalink = Permalink of string
type Tag       = Tag       of string
type Ticks     = Ticks     of int64
type TimeZone  = TimeZone  of string
type Url       = Url       of string
(**
It may be confusing that we're using the same name twice; the name after the `type` keyword defines the type, while the
one after the equals sign defines the constructor for this type (`CategoryId "abc"` defines a category Id whose value
is the string "abc").  We'll look at these implemented in a bit; next, though, we'll convert our
static-classes-turned-modules into multi-case DUs.
*)
type AuthorizationLevel =
  | Administrator
  | User

type PostStatus =
  | Draft
  | Published

type CommentStatus =
  | Approved
  | Pending
  | Spam
(**
This is similar in concept to the single-case DUs, but there are no parameters required for the constructor.

What does a record look like updated with these types?  Let's revisit the `Page` type we dissected for Tres.
*)
type Page = {
  [<JsonProperty("id")>]
  Id : PageId
  WebLogId : WebLogId
  AuthorId : UserId
  Title : string
  Permalink : Permalink
  PublishedOn : Ticks
  UpdatedOn : Ticks
  ShowInPageList : bool
  Text : string
  Revisions : Revision list
  }
with
  static member Empty = 
    { Id             = PageId ""
      WebLogId       = WebLogId ""
      AuthorId       = UserId ""
      Title          = ""
      Permalink      = Permalink ""
      PublishedOn    = Ticks 0L
      UpdatedOn      = Ticks 0L
      ShowInPageList = false
      Text           = ""
      Revisions      = []
    }
(**
The only primitives\* we now have are the `Title` and `Text` fields (which are both free-form text) and the
`ShowInPageList` field (for which yes/no is sufficient, although we could create a `PageListVisibility` DU to constrain
the yes/no values and distinguish them from others).  The compiler will prevent us from crossing boundaries on every
other field in this type!

Let's take a look at the `Empty` property on the `Post` type to see a multi-case DU in use.
*)
(*** hide ***)
type Post = {
  [<JsonProperty("id")>]
  Id : PostId
  WebLogId : WebLogId
  AuthorId : UserId
  Status : PostStatus
  Title : string
  Permalink : string
  PublishedOn : Ticks
  UpdatedOn : Ticks
  Text : string
  CategoryIds : CategoryId list
  Tags : Tag list
  Revisions : Revision list
  }
with
(** *)
  static member Empty =
    { Id              = PostId "new"
      WebLogId        = WebLogId ""
      AuthorId        = UserId ""
      Status          = Draft
      Title           = ""
      Permalink       = ""
      PublishedOn     = Ticks 0L
      UpdatedOn       = Ticks 0L
      Text            = ""
      CategoryIds     = []
      Tags            = []
      Revisions       = []
      }
(**
`Status` is defined as type `PostStatus`; to set its value, we simply have to write `Draft`.  No quotes, no dotted
access\*\*, just `Status = Draft`.  (`Status = Spam` does not compile.)

You can
[review the entire set of types](https://github.com/danieljsummers/FromObjectsToFunctions/tree/step-2/src/4-Freya-FSharp/Entities.fs)
to see where these various DUs were used.  While we could certainly take this much further, these simple changes have
made our types more meaningful, while eliminating a lot of the invalid states we could have assigned in our code.

[Back to Step 2](../step2)

---

\* - `string` is a primitive for our purposes here.

\*\* - If our DU condition is not unique, it would need to be qualified.  For example, if we were to add a "Draft"
`CommentStatus` so we could auto-save comment text while the visitor was typing\*\*\*, we would need to change the
`Empty` property to assign `PostStatus.Draft` instead.  Again, though, the compiler would help us spot that right away.

\*\*\* - This is a really bad idea; don't do this.
*)