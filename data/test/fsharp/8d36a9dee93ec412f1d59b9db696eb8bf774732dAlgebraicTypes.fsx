// ========================================
// Record Types (a.k.a Product types)
// ========================================

type Name = {first: string; last: string}

// usage
let name1 = {first="John"; last="Bloggs"}
let name2 = {first="John"; last="Bloggs"}
let name3 = {first="John"; last="Smith"}












// access of properties
name1.first
name1.first = "Bob"









// immutable
name1.first <- "Bob"


















// instant equality 
name1 = name2
name1 = name3


















// instant comparison
name1 > name3

let list = [name3; name1] 
List.sort list


















// ========================================
// Union Types  (a.k.a Sum types)
// ========================================

type Colour = 
    | Red 
    | Yellow 

// usage
let red = Red
let yellow = Yellow



// equality
red = yellow








let processColour colour = 
    match colour with
    | Red -> printfn "colour is red" 
    | Yellow -> printfn "colour is yellow" 

processColour Red
processColour Yellow


// not very exciting? 










type ContactInfo = 
    | Email of string
    | Phone of int

// usage
let email = Email "bill@gmail.com"
let phone = Phone 1234567


// exhaustive pattern matching
let processContact contact = 
    match contact with
    | Email address -> printfn "sending email to %s" address

processContact email












// exhaustive pattern matching to handle requirements changes







// ========================================
// Fun with sorting
// ========================================

type Suit = Clubs | Diamonds | Spades | Hearts
type Rank = Two | Three | Four | Five | Six | Seven | Eight 
            | Nine | Ten | Jack | Queen | King | Ace


let aceHearts = Hearts, Ace
let twoHearts = Hearts, Two
let aceSpades = Spades, Ace

twoHearts > aceHearts 
twoHearts > aceSpades 

let hand = [ Clubs,Ace; Hearts,Three; Hearts,Ace; 
             Spades,Jack; Diamonds,Two; Diamonds,Ace ]

//instant sorting!
List.sort hand |> printfn "sorted hand is (low to high) %A"

List.max hand |> printfn "high card is %A"
List.min hand |> printfn "low card is %A"






// ========================================
// No nulls!
// ========================================

// Name name = null         // C-style 
let name:Name = null        // F#-style 

// ContactInfo contact = null   // C-style 
let contact:ContactInfo = null  // F#-style 


(*


public void ProcessContact(Contact contact)
{ 
    // null checking always needed! 
    if (contact==null) {throw new ArgumentNullException("contact");

    // do something useful
}


*)


let processContact2 contact = 
    // no null checking needed! "contact" cannot be null.
    match contact with
    | Email address -> printfn "sending email to %s" address
    | Phone number -> printfn "calling phone number %i" number





















// ========================================
// Option types
// ========================================


type Optional<'TObject> = 
    | Something of 'TObject
    | Nothing




// Nullable<ContactInfo> contact = null        // C#-style (but not allowed for classes)
let contact2 : Optional<ContactInfo> = Nothing // F#-style











(*

Name? name = null        // It is optional and I set it nothing

Name name = null         // It is not optional but I set it to null anyway!












// how many times have you written this!  How many times did you forget?
if (something !=null)
{
    // do something
}





*)












// with Options -- all cases MUST ALWAYS be matched
let processOptional aValue = 
    match aValue with
    | Something value -> printfn "something of value %O" value












let something = Something 123
let nothing = Nothing


processOptional something
processOptional nothing





// in F# this is built in and called "Option"