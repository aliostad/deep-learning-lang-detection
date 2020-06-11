select Users.UserUVID as 'User UVID', Users.UserFName + ' ' + Users.UserLName as 'User''s Name', Equipment.UVUInvID as 'UVU Inventory ID', Mfg.MfgName + ' ' + Model.ModelName as 'Model', EquipType.EquipTypeName as 'Type', Equipment.SerialNum as 'Computer Serial #'
from Equipment
Inner Join Model on Equipment.ModelID = Model.ModelID
Inner Join EquipType on Equipment.EquipTypeID = EquipType.EquipTypeID
Inner Join Users on Equipment.UserUVID = Users.UserUVID
Inner Join Mfg on Mfg.MfgID = Model.MfgID
order by 'User UVID'