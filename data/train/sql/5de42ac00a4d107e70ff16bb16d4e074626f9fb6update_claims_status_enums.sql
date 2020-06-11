/*
 * kwc 05/08/2009
 *
 * Copied from a script done by Ali Asad Lotia to reflect the
 * changes made to the code in SVN r53972.
 */

/*
 * These changes must be made to the database before
 * code implementing OERDEV-162 (the "lite" fix edition)
 * is run on the system.
 * We aren't deleting any values, so it apparently isn't
 * a big deal to make this change.
 */

/*
 * I verified that altering the enum with a new value
 * "in the middle" does not change existing values,
 * as long as the existing values remain in the new
 * enum list.
 */
ALTER TABLE `ocw_claims_commission` MODIFY COLUMN `status` 
      ENUM (
       'new',
       'request sent',
       'in progress',
       'done' ) 
     NOT NULL default 'new' collate utf8_unicode_ci;

UPDATE `ocw_claims_commission` SET
       `status`='request sent' WHERE
       `status`='new';

ALTER TABLE `ocw_claims_fairuse` MODIFY COLUMN `status` 
      ENUM (
       'new',
       'request sent',
       'in progress',
       'ip review',
       'done' ) 
     NOT NULL default 'new' collate utf8_unicode_ci;

UPDATE `ocw_claims_fairuse` SET
       `status`='request sent' WHERE
       `status`='new';

ALTER TABLE `ocw_claims_permission` MODIFY COLUMN `status` 
      ENUM (
       'new',
       'request sent',
       'in progress',
       'done' ) 
     NOT NULL default 'new' collate utf8_unicode_ci;

UPDATE `ocw_claims_permission` SET
       `status`='request sent' WHERE
       `status`='new';

ALTER TABLE `ocw_claims_retain` MODIFY COLUMN `status` 
      ENUM (
       'new',
       'request sent',
       'in progress',
       'ip review',
       'done' ) 
     NOT NULL default 'new' collate utf8_unicode_ci;

UPDATE `ocw_claims_retain` SET
       `status`='request sent' WHERE
       `status`='new';

