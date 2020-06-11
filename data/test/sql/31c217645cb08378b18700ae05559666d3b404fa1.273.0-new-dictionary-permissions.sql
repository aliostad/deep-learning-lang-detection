INSERT INTO "FieldPermission" (role, model, field, r, w)
SELECT role, 'UrgentServiceReason', field, r, w
FROM "FieldPermission"
WHERE model = 'TowerType';

INSERT INTO "FieldPermission" (role, model, field, r, w)
SELECT role, 'Activity', field, r, w
FROM "FieldPermission"
WHERE model = 'TowerType';

INSERT INTO "FieldPermission" (role, model, field, r, w)
SELECT role, 'RequestType', field, r, w
FROM "FieldPermission"
WHERE model = 'TowerType';

INSERT INTO "FieldPermission" (role, model, field, r, w)
SELECT role, 'DeliveryType', field, r, w
FROM "FieldPermission"
WHERE model = 'TowerType';
