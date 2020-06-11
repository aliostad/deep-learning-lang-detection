update ccm_pagepermission set depapiperms='water.bill.change.editbill#queryforlist,water.bill.change.editbill#create,water.bill.change.editbill#otheract.calcamount,water.bill.change.editbill#insert,water.bill.change.editbill#read,water.bill.change.editbill#read,water.bill.change.editbill#readwateritems'
where moduleno='water.bill.change.billchange' and permission='editbill';

update ccm_pagepermission set depapiperms='water.bill.change.setlatefee#queryforlist,water.bill.change.setlatefee#create,water.bill.change.setlatefee#otheract.calclatefee,water.bill.change.setlatefee#insert,water.bill.change.setlatefee#read'
where moduleno='water.bill.change.billchange' and permission='setlatefee';