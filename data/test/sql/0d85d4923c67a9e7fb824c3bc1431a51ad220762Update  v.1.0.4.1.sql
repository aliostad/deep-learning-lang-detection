1. 

alter table Price
drop column OldPurchasePrice,
drop column NewPurchasePrice;

alter table Price
add column FlagUpDown1 Flag,
add column FlagUpDown2 Flag,
add column FlagUpDown3 Flag,
add column FlagUpDown4 Flag,
add column FlagUpDown5 Flag;

alter table Price
drop column NewQty1,
drop column NewQty2,
drop column NewQty3,
drop column NewQty4,
drop column NewQty5,
drop column NewUnitMeasure1,
drop column NewUnitMeasure2,
drop column NewUnitMeasure3,
drop column NewUnitMeasure4,
drop column NewUnitMeasure5;

2. Backup Restore Database