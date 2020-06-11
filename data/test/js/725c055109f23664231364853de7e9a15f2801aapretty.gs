
instance Text ClassState where
  showsPrec _ ClassLinked      = showString "Linked"
  showsPrec _ InProgress       = showString "InProgress"
  showsPrec _ ClassInitialized = showString "Initialized"
  showsPrec _ ClassUnusable    = showString "Unusable"
  showsPrec _ x                = showString (show' x)

showsJavaFRef :: FieldRef -> ShowS
showsJavaFRef (c :/ f) = showString c . showString "." . showString f

showJavaFRef :: FieldRef -> String
showJavaFRef (fr) = showsJavaFRef(fr) ""


showsJavaMRef :: MethRef -> ShowS
showsJavaMRef (c :/ (m,types)) = showString c . showString "." .
                          showString m

showJavaMRef :: MethRef -> String
showJavaMRef (mr) = showsJavaMRef (mr) ""

showJavaMRefArgs :: MethRef -> String
showJavaMRefArgs(c:/(m,types)) = (showString c . showString "." .
                                  showString m  . showString "(" .
                                  showSepBy (", ") (map shows types) .
                                  showString ")") ""

showSepBy :: String -> [ShowS] -> ShowS
showSepBy _ []       = id
showSepBy _ [x]      = x
showSepBy sep (x:xs) = x . showString sep . showSepBy sep xs
