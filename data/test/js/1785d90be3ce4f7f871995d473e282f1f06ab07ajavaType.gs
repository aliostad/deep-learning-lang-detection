-- --------------------------------------------------------------------
-- Java Types
-- --------------------------------------------------------------------

data JavaType = TJInt 
              | TJFloat
              | TJDouble
              | TJLong
              | TJByte
              | TJChar
              | TJShort
              | TJBoolean
              | TJRef(Int,TypeName)
              | TJArray(JavaType)
              | TJVoid

instance Text JavaType where
  showsPrec _ TJInt         = showString "int"
  showsPrec _ TJFloat       = showString "float"
  showsPrec _ TJDouble      = showString "double"
  showsPrec _ TJShort       = showString "short"
  showsPrec _ TJByte        = showString "byte"
  showsPrec _ TJBoolean     = showString "boolean"
  showsPrec _ TJLong        = showString "long"
  showsPrec _ TJChar        = showString "char"
  showsPrec _ TJVoid        = showString "void"
  showsPrec _ (TJRef(_,c))  = showString c
  showsPrec _ (TJArray(t))  = shows t . showString "[]"
  showsPrec _ x             = error ("Text JavaType: " ++ show' x)

instance AsmTerm JavaType

instance Ord JavaType where
  x <  y = genericCmp x y == -1
  x >  y = genericCmp x y == 1
  x <= y = genericCmp x y <= 0
  x >= y = genericCmp x y >= 0

showAddrType :: JavaType -> ShowS
showAddrType(TJRef((c))) = showString (snd(c))
showAddrType(TJArray(t)) = showString "[" . shows t
showAddrType (w)         = error ("showAddrType: " ++ show' w)    


convertJavaType :: (Int,TypeName) -> (Int,TypeName)
convertJavaType = id