# --- Sample dataset

# --- !Ups

insert into image (id ,data) values(1, FILE_READ('conf/evolutions/default/images/DSC_0015.JPG'));
insert into image (id ,data) values(2, FILE_READ('conf/evolutions/default/images/DSC_0015.JPG'));
insert into image (id ,data) values(3, FILE_READ('conf/evolutions/default/images/DSC_0015.JPG'));
insert into image (id ,data) values(4, FILE_READ('conf/evolutions/default/images/DSC_0015.JPG'));
insert into image (id ,data) values(5, FILE_READ('conf/evolutions/default/images/DSC_0015.JPG'));
insert into image (id ,data) values(6, FILE_READ('conf/evolutions/default/images/DSC_0015.JPG'));

# --- !Downs

delete from image;
