module BankOcrTests

open NUnit.Framework
open FsUnit
open BankOcr
open digitConstants

[<Test>]
let ``scan multiple digits``()=
  let text = @"
    _ 
 |  _|
 | |_ "

  scanDigits text |> should equal "12"

[<Test>]
let ``scan 0-9 text``()=
  let text = @"
 _     _  _     _  _  _  _  _ 
| | |  _| _||_||_ |_   ||_||_|
|_| | |_  _|  | _||_|  ||_| _|"

  scanDigits text |> should equal "0123456789"

[<Test>]
let ``scan invalid digit``()=
  let text = @"
 _ xxx
| |xxx
|_|xxx"

  scanDigits text |> should equal "0?"

[<Test>]
let ``text to 3 character strings``()=
  "123456" |> stringToThreeCharacters|> should equal ["123";"456"]


[<Test>]
let ``split text into 3 by 3 digit strings``()=
  let text = @"
abcjkl
defmno
ghipqr"

  text |> splitTextInto3by3digitStrings |> should equal ["abc\r\ndef\r\nghi";"jkl\r\nmno\r\npqr"]


[<Test>]
let ``scratch``()=
  let text12 = @"
    _ 
 |  _|
 | |_ "

  let text1 = @"
   
 | 
 | "

  let text = @"
ABCDEF
GHIJKL
MNOPQR"
  text12 |> scanDigits |> (printfn "%s %A" text12)
  text1 |> scanDigits |> (printfn "%s %A" text1)
  text |> scanDigits |> (printfn "%s %A" text)

[<Test>]
let ``join lines``()=
  let expected = @"ab
cd"

  ["ab";"cd"] |> joinLines |> should equal expected

[<Test>]
let ``abc to chars``()=
  "abc" |> toChars |> should equal ['a';'b';'c']

[<Test>]
let ``three list to three tuple``()=
  ["a";"b";"c"] |> threeListTo3Tuple |> should equal ("a", "b", "c")


[<Test>]
let ``scan a 1 digit`` () =
  one |> scanDigit |> should equal "1"

[<Test>]
let ``scan a 2 digit`` () =
  two |> scanDigit |> should equal "2"

[<Test>]
let ``scan a 3 digit`` () =
  three|> scanDigit |> should equal "3"

[<Test>]
let ``number status checksum valid``()=
  "345882865" |> getNumberStatus |> should equal Valid

[<Test>]
let ``number status checksum invalid``()=
  "111111111" |> getNumberStatus |> should equal Invalid

[<Test>]
let ``number status with illegal characters``()=
  "?11111111" |> getNumberStatus |> should equal Illegal

[<Test>]
let ``process number with status when valid``()=
  "345882865" |> processNumberWithStatus |> should equal "345882865"

[<Test>]
let ``process number with status when invalid checksum``()=
  "111111111" |> processNumberWithStatus |> should equal "111111111 ERR"

[<Test>]
let ``process number with status when invalid characters``()=
  "34588286?" |> processNumberWithStatus |> should equal "34588286? ILL"