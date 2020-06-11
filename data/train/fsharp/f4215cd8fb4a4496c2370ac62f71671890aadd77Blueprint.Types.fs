namespace FunEve.IndustryDomain.Blueprint

module Types = 
    open FunEve.Base.Types

    type Probability = Probability of single 
            
    type ReqSkill = ReqSkill of Level * TypeId 
                        
    type MfgMaterial = MfgMaterial of (Qty * TypeId) list 

    type MfgProduct = MfgProduct of (Qty * TypeId * Probability) list 

    type MfgSkill = MfgSkill of ReqSkill list 
    
    type RunLimit = RunLimit of int 
            
    type MaterialEfficiency = MaterialEfficiency of int 

    type TimeEfficiency = TimeEfficiency of int
                        
    type Activities = 
    | Copying of Time
    | ResearchMaterial of Time
    | ResearchTime of Time
    | Manufacturing of Time * MfgMaterial * MfgProduct * MfgSkill
    | Invention of Time * MfgMaterial * MfgProduct * MfgSkill

    type CopyType = 
    | Original
    | Copy
    | InventedT2
    | InventedT3
