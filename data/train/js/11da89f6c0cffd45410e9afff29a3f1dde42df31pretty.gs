showWord :: Word -> ShowS
showWord (i,WTInt)       = showString "int " . shows i
showWord w@(_,WTFloat)   = showString "float " . shows (w2f(w))
showWord (0,WTReference) = showString "null"
showWord (r,t)           = shows t . showString " " . shows r 
showWord x               = error ("showWord " ++ show x)

showWord' :: Word -> String
showWord' w = showWord w ""


showInstr :: Instr -> ShowS
showInstr (Prim(PrimFun(f)))     = showString f
showInstr (Prim(PrimLdc([(0,WTReference)]))) = showString "aconst_null"
showInstr (Prim(PrimLdc([v])))     = showString "ldc " .shows (v : [])
showInstr (Prim(PrimLdc([v1,v2]))) = showString "ldc2 " .shows [v1,v2]
showInstr (LoadString s) = showString "ldc " . shows (resubstNewline s)
showInstr (Iinc(r,i)) = showString "iinc " 
                        . shows r . showString " "
                        . shows (i : [])
showInstr (Load(t,r)) = shows t . showString "load " . shows r
showInstr (Store(t,r))= shows t . showString "store " . shows r
showInstr (Nop)       = showString "nop"
showInstr (Pop(0))    = showString "nop"
showInstr (Pop(1))    = showString "pop"
showInstr (Pop(2))    = showString "pop2"
showInstr (Dupx(0,1)) = showString "dup"
showInstr (Dupx(0,2)) = showString "dup2"
showInstr (Dupx(1,1)) = showString "dup_x1"
showInstr (Dupx(1,2)) = showString "dup2_x1"
showInstr (Dupx(2,1)) = showString "dup_x2"
showInstr (Dupx(2,2)) = showString "dup2_x2"
showInstr (Goto(o))   = showString "goto " . shows o
showInstr (Cond(rel,o)) = showString rel . showString " " . shows o
showInstr (Halt)      = showString "halt"
showInstr (MGetStatic(t,f,_)) = showString "getstatic " . showFRef f .
                                showString " " . shows t
showInstr (MPutStatic(t,f,_)) = showString "putstatic " . showFRef f .
                                showString " " . shows t
showInstr (MInvokeStatic(rt,m,_)) = showString "invokestatic " . shows m .
                                    shows rt
showInstr (Return(MTvoid)) = showString "return"
showInstr (Return(t))      = shows t . showString "return"
showInstr (NewArray(TJInt,1))    = showString "newarray int"
showInstr (NewArray(TJByte,1))   = showString "newarray byte"
showInstr (NewArray(TJChar,1))   = showString "newarray char"
showInstr (NewArray(TJShort,1))  = showString "newarray short"
showInstr (NewArray(TJFloat,1))  = showString "newarray float"
showInstr (NewArray(TJLong,1))   = showString "newarray long"
showInstr (NewArray(TJDouble,1)) = showString "newarray double"
showInstr (NewArray(t,1))        = showString "anewarray "
                                   . showAddrType t
showInstr (NewArray(t,d))       = showString "multianewarray "
                                  . shows (TJArray(t)) . showString " "
                                  . shows d
showInstr (ArrayLength)         = showString "arraylength"
showInstr (ALoad(t))            = shows t . showString "aload"
showInstr (AStore(t))           = shows t . showString "astore"
showInstr (New(cn))         = showString "new " . showClassName cn
showInstr (MGetField(t,f,_)) = showString "getfield " . showFRef f .
                               showString " " . shows t
showInstr (MPutField(t,f,_))   = showString "putfield " . showFRef f .
                                 showString " " . shows t
showInstr (InstanceOf(t))  = showString "instanceof " . shows t
showInstr (Checkcast(t))   = showString "checkcast " . shows t
showInstr (MInvokeSpecial(rt,m,_))   = showString "invokespecial " . shows m .
                                       shows rt
showInstr (MInvokeVirtual(rt,m,_)) = showString "invokevirtual "
                                   . shows m . shows rt
showInstr (Athrow)               = showString "athrow"
showInstr (Jsr(o))               = showString "jsr " . shows o
showInstr (Ret(r))               = showString "ret " . shows r
showInstr (TableSwitch _ _ _)    = showString "tableswitch"
showInstr (LookupSwitch _ _)     = showString "lookupswitch"

showInstr e = error ("instance Text Instr: " ++ primPrint 0 e "")

showArgs :: (a -> ShowS) -> [a] -> ShowS
showArgs shows xs = showString "(" . showArgs' xs . showString ")"
  where showArgs' []     = id
        showArgs' [x]    = shows x
        showArgs' (x:xs) = shows x . showString ", " . showArgs' xs

showSwitch :: Switch -> ShowS
showSwitch (Noswitch)        = id
showSwitch (Call(meth,locs)) = showString "call: " . showString (mNm(meth))
                             . showArgs showWord locs
showSwitch (Result([]))      = showString "yield: Nothing"
showSwitch (Result(vs))      = showString "yield: " . shows vs
showSwitch (InitClass(c))    = showString "initclass: " . showClass c
showSwitch (Throw(r))        = showString "throw: " . shows r
showSwitch (ThrowInit(r))    = showString "throwInit: " . shows r


prettyPrintTypeAssignment :: (Code,[(Nat,[VerifyType])],
                                   [(Nat, Map RegNo VerifyType)]) -> ShowS
prettyPrintTypeAssignment(code,opdV,regV) = 
   showSepBy' "\n" (map f (zip [0..] code))
 where f (i,instr) = shows i . showString ": " . showInstr instr .
                     showString "\t" . g showList (opd i) . 
                     showString "\t" . g shows (reg i)
       g show Nothing  = showString "undefined"
       g show (Just s) = show s
       opd i = case filter ((==i).fst) opdV of
                 (_,o) : _ -> Just o
                 []        -> Nothing
       reg i = case filter ((==i).fst) regV of
                 (_,r) : _ -> Just r
                 []        -> Nothing

