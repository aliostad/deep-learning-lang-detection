class ObjectAccess:
    def __init__(self):
        pass

    def InsertData(self, uipart, LsDest, strLsValue, countStart) :
       uipart.Edit()
       LsValue = eval(strLsValue)
       i = countStart
       for FieldDest in LsDest :
         uipart.SetFieldValue(FieldDest,LsValue[i])
         i += 1
         
    def ClearuipartData(self, uipart, LsSave, SaveData = 0) :
       if SaveData == 0  :
         SaveData = ()
         for FieldSave in LsSave :
           SaveData += (uipart.GetFieldValue(FieldSave),)
       uipart.ClearData()
       uipart.Edit()
       i = 0
       for FieldSave in LsSave :
         uipart.SetFieldValue(FieldSave,SaveData[i])
         i += 1
