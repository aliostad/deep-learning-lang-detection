# --- !Ups

ALTER TABLE company_model ADD marquee_s varchar(255);
ALTER TABLE company_model ADD name_s varchar(255);
ALTER TABLE company_model ADD description_s varchar(255);
ALTER TABLE content_model ADD name_s varchar(255);
ALTER TABLE content_model ADD description_s varchar(255);

# --- !Downs

ALTER TABLE company_model DROP marquee_s;
ALTER TABLE company_model DROP name_s;
ALTER TABLE company_model DROP description_s;
ALTER TABLE content_model DROP name_s;
ALTER TABLE content_model DROP description_s;
