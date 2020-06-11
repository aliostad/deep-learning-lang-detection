DROP TABLE if exists ims_new_feature;
CREATE TABLE ims_new_feature
(
   item_code                       char(18),
   mps_code                        varchar(25),
   grade                           varchar(20),																																																																
   status                          varchar(20),
   body                            varchar(30),
   edge                            varchar(30),
   surface_type                    varchar(30),   
   surface_finish                  varchar(30),
   surface_application             varchar(30),
   design_style                    varchar(30),   
   design_look                     varchar(30),
   recommended_grout_joint_min     varchar(10),
   recommended_grout_joint_max     varchar(10),
   warranty                        numeric(4),
   created_date                    date,
   launched_date                   date,
   dropped_date                    date,
   last_modified_date              date,
   version                         numeric(15),
   
   PRIMARY KEY (item_code),
   
   CONSTRAINT new_feature_ims_fkey FOREIGN KEY (item_code)
      REFERENCES ims (itemcd) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE         
);

CREATE INDEX ims_new_feature_mps_code_idx ON ims_new_feature USING btree (mps_code);
CREATE INDEX ims_new_feature_status_idx ON ims_new_feature USING btree (status);
CREATE INDEX ims_new_feature_grade_idx ON ims_new_feature USING btree (grade);

COMMIT;   

