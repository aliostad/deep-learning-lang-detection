create table JsonOrderDetails(BrandID Number(1), TriggerType Number(10), OrderNumber Number(20));
set define off;
Insert into configuration (CONTEXT,SUBCONTEXT,CONFIGKEY,BRANDID,TRIGGERTYPE,CONFIGVALUE,DESCRIPTION) values ('QueueConfig','ReadWriteJson','NumberOfThreads',0,0,'7',null);
Insert into configuration (CONTEXT,SUBCONTEXT,CONFIGKEY,BRANDID,TRIGGERTYPE,CONFIGVALUE,DESCRIPTION) values ('QueueConfig','ReadWriteJson','NumberOfThreads',1,0,'10','Quill');

Insert into configuration (CONTEXT,SUBCONTEXT,CONFIGKEY,BRANDID,TRIGGERTYPE,CONFIGVALUE,DESCRIPTION) values ('QueueConfig','ReadWriteJson','QueueName',1,0,'ReadWriteJson_1_0',null);
Insert into configuration (CONTEXT,SUBCONTEXT,CONFIGKEY,BRANDID,TRIGGERTYPE,CONFIGVALUE,DESCRIPTION) values ('QueueConfig','ReadWriteJson','QueueName',1,1,'ReadWriteJson_1_1','Shipped');
Insert into configuration (CONTEXT,SUBCONTEXT,CONFIGKEY,BRANDID,TRIGGERTYPE,CONFIGVALUE,DESCRIPTION) values ('QueueConfig','ReadWriteJson','QueueName',1,4,'ReadWriteJson_1_4','Out for delivery');
Insert into configuration (CONTEXT,SUBCONTEXT,CONFIGKEY,BRANDID,TRIGGERTYPE,CONFIGVALUE,DESCRIPTION) values ('QueueConfig','ReadWriteJson','QueueName',1,5,'ReadWriteJson_1_5','Delivered');
Insert into configuration (CONTEXT,SUBCONTEXT,CONFIGKEY,BRANDID,TRIGGERTYPE,CONFIGVALUE,DESCRIPTION) values ('QueueConfig','ReadWriteJson','QueueName',1,13,'ReadWriteJson_1_13','Item in Stock:30 day');
Insert into configuration (CONTEXT,SUBCONTEXT,CONFIGKEY,BRANDID,TRIGGERTYPE,CONFIGVALUE,DESCRIPTION) values ('QueueConfig','ReadWriteJson','QueueName',1,14,'ReadWriteJson_1_14','In-stock update:30 day');
Insert into configuration (CONTEXT,SUBCONTEXT,CONFIGKEY,BRANDID,TRIGGERTYPE,CONFIGVALUE,DESCRIPTION) values ('QueueConfig','ReadWriteJson','QueueName',1,15,'ReadWriteJson_1_15','Item Discontinued:30 day');
Insert into configuration (CONTEXT,SUBCONTEXT,CONFIGKEY,BRANDID,TRIGGERTYPE,CONFIGVALUE,DESCRIPTION) values ('QueueConfig','ReadWriteJson','QueueName',1,16,'ReadWriteJson_1_16','Price decrease alert');
Insert into configuration (CONTEXT,SUBCONTEXT,CONFIGKEY,BRANDID,TRIGGERTYPE,CONFIGVALUE,DESCRIPTION) values ('QueueConfig','ReadWriteJson','QueueName',1,17,'ReadWriteJson_1_17','Price target alert');
Insert into configuration (CONTEXT,SUBCONTEXT,CONFIGKEY,BRANDID,TRIGGERTYPE,CONFIGVALUE,DESCRIPTION) values ('QueueConfig','ReadWriteJson','QueueName',1,18,'ReadWriteJson_1_18','Price alert');

Insert into configuration (CONTEXT,SUBCONTEXT,CONFIGKEY,BRANDID,TRIGGERTYPE,CONFIGVALUE,DESCRIPTION) values ('QueueConfig','ReadWriteJson','QueueName',2,0,'ReadWriteJson_2_0',null);
Insert into configuration (CONTEXT,SUBCONTEXT,CONFIGKEY,BRANDID,TRIGGERTYPE,CONFIGVALUE,DESCRIPTION) values ('QueueConfig','ReadWriteJson','QueueName',2,1,'ReadWriteJson_2_1','Shipped');
Insert into configuration (CONTEXT,SUBCONTEXT,CONFIGKEY,BRANDID,TRIGGERTYPE,CONFIGVALUE,DESCRIPTION) values ('QueueConfig','ReadWriteJson','QueueName',2,2,'ReadWriteJson_2_2','DDLV');
Insert into configuration (CONTEXT,SUBCONTEXT,CONFIGKEY,BRANDID,TRIGGERTYPE,CONFIGVALUE,DESCRIPTION) values ('QueueConfig','ReadWriteJson','QueueName',2,4,'ReadWriteJson_2_4','Out for delivery');
Insert into configuration (CONTEXT,SUBCONTEXT,CONFIGKEY,BRANDID,TRIGGERTYPE,CONFIGVALUE,DESCRIPTION) values ('QueueConfig','ReadWriteJson','QueueName',2,5,'ReadWriteJson_2_5','Delivered');
Insert into configuration (CONTEXT,SUBCONTEXT,CONFIGKEY,BRANDID,TRIGGERTYPE,CONFIGVALUE,DESCRIPTION) values ('QueueConfig','ReadWriteJson','QueueName',2,7,'ReadWriteJson_2_7','BOPIS - Ready for Pickup');
Insert into configuration (CONTEXT,SUBCONTEXT,CONFIGKEY,BRANDID,TRIGGERTYPE,CONFIGVALUE,DESCRIPTION) values ('QueueConfig','ReadWriteJson','QueueName',2,8,'ReadWriteJson_2_8','BOPIS - Reminder');
Insert into configuration (CONTEXT,SUBCONTEXT,CONFIGKEY,BRANDID,TRIGGERTYPE,CONFIGVALUE,DESCRIPTION) values ('QueueConfig','ReadWriteJson','QueueName',2,9,'ReadWriteJson_2_9','BOPIS - Item not Available');
Insert into configuration (CONTEXT,SUBCONTEXT,CONFIGKEY,BRANDID,TRIGGERTYPE,CONFIGVALUE,DESCRIPTION) values ('QueueConfig','ReadWriteJson','QueueName',2,10,'ReadWriteJson_2_10','BOPIS - Thank you');
Insert into configuration (CONTEXT,SUBCONTEXT,CONFIGKEY,BRANDID,TRIGGERTYPE,CONFIGVALUE,DESCRIPTION) values ('QueueConfig','ReadWriteJson','QueueName',2,11,'ReadWriteJson_2_11','BOPIS - Canceled');
Insert into configuration (CONTEXT,SUBCONTEXT,CONFIGKEY,BRANDID,TRIGGERTYPE,CONFIGVALUE,DESCRIPTION) values ('QueueConfig','ReadWriteJson','QueueName',2,12,'ReadWriteJson_2_12','Simple Delayed Delivery');
Insert into configuration (CONTEXT,SUBCONTEXT,CONFIGKEY,BRANDID,TRIGGERTYPE,CONFIGVALUE,DESCRIPTION) values ('QueueConfig','ReadWriteJson','QueueName',2,19,'ReadWriteJson_2_19','KLUB');
Insert into configuration (CONTEXT,SUBCONTEXT,CONFIGKEY,BRANDID,TRIGGERTYPE,CONFIGVALUE,DESCRIPTION) values ('QueueConfig','ReadWriteJson','QueueName',2,25,'ReadWriteJson_2_25','STS - RFP');
Insert into configuration (CONTEXT,SUBCONTEXT,CONFIGKEY,BRANDID,TRIGGERTYPE,CONFIGVALUE,DESCRIPTION) values ('QueueConfig','ReadWriteJson','QueueName',2,26,'ReadWriteJson_2_26','STS - RFP Remainder');
Insert into configuration (CONTEXT,SUBCONTEXT,CONFIGKEY,BRANDID,TRIGGERTYPE,CONFIGVALUE,DESCRIPTION) values ('QueueConfig','ReadWriteJson','QueueName',2,27,'ReadWriteJson_2_27','STS - Pickup Confirmation (Thank You)');
Insert into configuration (CONTEXT,SUBCONTEXT,CONFIGKEY,BRANDID,TRIGGERTYPE,CONFIGVALUE,DESCRIPTION) values ('QueueConfig','ReadWriteJson','QueueName',2,28,'ReadWriteJson_2_28','STS - CANCELLED (ABANDONMENT)');
Insert into configuration (CONTEXT,SUBCONTEXT,CONFIGKEY,BRANDID,TRIGGERTYPE,CONFIGVALUE,DESCRIPTION) values ('QueueConfig','ReadWriteJson','QueueName',2,29,'ReadWriteJson_2_29','Return Credit Notification');
Insert into configuration (CONTEXT,SUBCONTEXT,CONFIGKEY,BRANDID,TRIGGERTYPE,CONFIGVALUE,DESCRIPTION) values ('QueueConfig','ReadWriteJson','QueueName',2,30,'ReadWriteJson_2_30','Return Order Notification');

Insert into configuration (CONTEXT,SUBCONTEXT,CONFIGKEY,BRANDID,TRIGGERTYPE,CONFIGVALUE,DESCRIPTION) values ('QueueConfig','ReadWriteJson','QueueName',3,0,'ReadWriteJson_3_0',null);
Insert into configuration (CONTEXT,SUBCONTEXT,CONFIGKEY,BRANDID,TRIGGERTYPE,CONFIGVALUE,DESCRIPTION) values ('QueueConfig','ReadWriteJson','QueueName',3,1,'ReadWriteJson_3_1','Shipped');
Insert into configuration (CONTEXT,SUBCONTEXT,CONFIGKEY,BRANDID,TRIGGERTYPE,CONFIGVALUE,DESCRIPTION) values ('QueueConfig','ReadWriteJson','QueueName',3,2,'ReadWriteJson_3_2','DDLV');
Insert into configuration (CONTEXT,SUBCONTEXT,CONFIGKEY,BRANDID,TRIGGERTYPE,CONFIGVALUE,DESCRIPTION) values ('QueueConfig','ReadWriteJson','QueueName',3,4,'ReadWriteJson_3_4','Out for delivery');
Insert into configuration (CONTEXT,SUBCONTEXT,CONFIGKEY,BRANDID,TRIGGERTYPE,CONFIGVALUE,DESCRIPTION) values ('QueueConfig','ReadWriteJson','QueueName',3,5,'ReadWriteJson_3_5','Delivered');
Insert into configuration (CONTEXT,SUBCONTEXT,CONFIGKEY,BRANDID,TRIGGERTYPE,CONFIGVALUE,DESCRIPTION) values ('QueueConfig','ReadWriteJson','QueueName',3,7,'ReadWriteJson_3_7','BOPIS - Ready for Pickup');
Insert into configuration (CONTEXT,SUBCONTEXT,CONFIGKEY,BRANDID,TRIGGERTYPE,CONFIGVALUE,DESCRIPTION) values ('QueueConfig','ReadWriteJson','QueueName',3,8,'ReadWriteJson_3_8','BOPIS - Reminder');
Insert into configuration (CONTEXT,SUBCONTEXT,CONFIGKEY,BRANDID,TRIGGERTYPE,CONFIGVALUE,DESCRIPTION) values ('QueueConfig','ReadWriteJson','QueueName',3,9,'ReadWriteJson_3_9','BOPIS - Item not Available');
Insert into configuration (CONTEXT,SUBCONTEXT,CONFIGKEY,BRANDID,TRIGGERTYPE,CONFIGVALUE,DESCRIPTION) values ('QueueConfig','ReadWriteJson','QueueName',3,10,'ReadWriteJson_3_10','BOPIS - Thank you');
Insert into configuration (CONTEXT,SUBCONTEXT,CONFIGKEY,BRANDID,TRIGGERTYPE,CONFIGVALUE,DESCRIPTION) values ('QueueConfig','ReadWriteJson','QueueName',3,11,'ReadWriteJson_3_11','BOPIS - Canceled');
Insert into configuration (CONTEXT,SUBCONTEXT,CONFIGKEY,BRANDID,TRIGGERTYPE,CONFIGVALUE,DESCRIPTION) values ('QueueConfig','ReadWriteJson','QueueName',3,12,'ReadWriteJson_3_12','Simple Delayed Delivery');


Insert into configuration (CONTEXT,SUBCONTEXT,CONFIGKEY,BRANDID,TRIGGERTYPE,CONFIGVALUE,DESCRIPTION) values ('QueueConfig','ReadWriteJson','durable',0,0,'True',null);
Insert into configuration (CONTEXT,SUBCONTEXT,CONFIGKEY,BRANDID,TRIGGERTYPE,CONFIGVALUE,DESCRIPTION) values ('QueueConfig','ReadWriteJson','fetchBufferedCount',0,0,'10',null);

