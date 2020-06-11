
CREATE PROCEDURE OT_IMPORT_HRFeedUpdate(
	@HRFeedID int,
	@CompanyID int,
	@ImportName varchar(255) = null,
	@StandardFormat bit,
	@IsActive bit = null,
	@Server varchar(60) = null,
	@ImportType varchar(60) = null,
	@Version varchar(60) = null,
	@ftpShareName varchar(60) = null,
	@PasswordDefault varchar(255) = null,
	@PasswordAppendYear bit = null,
	@PasswordExpire bit = null,
	@PasswordMode int = null,
	@StatusActive varchar(60) = null,
	@StatusInactive varchar(60) = null,
	@CustomFieldNames varchar(2000) = null,
	@FilenameDecrypt varchar(60) = null,
	@FilenameEncrypt varchar(60) = null,
	@pgpFile bit = null,
	@pgpPassphrase varchar(255) = null,
	@Delimiter varchar(60) = null,
	@ftpLocation int = null,
	@ftpPath varchar(60) = null,
	@ftpHost varchar(60) = null,
	@ftpUserid varchar(60) = null,
	@ftpPassword varchar(255) = null,
	@isTest bit = null,
	@UpdateOnly bit = null,
	@UpdateName bit = null,
	@UniqueIdentifier int = null,
	@SyncToGDS bit = null,
	@CreateGDSProfile bit,
	@LogRecipients varchar(255) = null,
	@LastModBy int,
	@LastRunDate smalldatetime = null
	
)
AS
/*
This update proc is used as part of the Cliqbook HR Feed process. This allows
for paramters to be updated based on the provided company_id and hr_feed_id.
Required parameters: @HRFeedID, @CompanyID, @LastModBy
*/
BEGIN
	--update
	update outtask_import_hr_feed
	set
		COMPANY_ID = @CompanyID,
		IMPORT_NAME = isnull(@ImportName, IMPORT_NAME),
		STANDARD_FORMAT = isnull(@StandardFormat, STANDARD_FORMAT),
		IS_ACTIVE = isnull(@IsActive, IS_ACTIVE),
		SERVER = isnull(@Server, SERVER),
		IMPORT_TYPE = isnull(@ImportType, IMPORT_TYPE),
		VERSION = isnull(@Version, VERSION),
		FTP_SHARE_NAME = isnull(@ftpShareName, FTP_SHARE_NAME),
		PASSWORD_DEFAULT = isnull(@PasswordDefault, PASSWORD_DEFAULT),
		PASSWORD_APPEND_YEAR = isnull(@PasswordAppendYear, PASSWORD_APPEND_YEAR),
		PASSWORD_EXPIRE = isnull(@PasswordExpire, PASSWORD_EXPIRE),
		PASSWORD_MODE = isnull(@PasswordMode, PASSWORD_MODE),
		STATUS_ACTIVE = isnull(@StatusActive, STATUS_ACTIVE),
		STATUS_INACTIVE = isnull(@StatusInactive, STATUS_INACTIVE),
		CUSTOM_FIELD_NAMES = isnull(@CustomFieldNames, CUSTOM_FIELD_NAMES),
		FILENAME_DECRYPT = isnull(@FilenameDecrypt, FILENAME_DECRYPT),
		FILENAME_ENCRYPT = isnull(@FilenameEncrypt, FILENAME_ENCRYPT),
		PGP_FILE = isnull(@pgpFile, PGP_FILE),
		PGP_PASSPHRASE = isnull(@pgpPassphrase, PGP_PASSPHRASE),
		DELIMITER = isnull(@Delimiter, DELIMITER),
		FTP_LOCATION = isnull(@ftpLocation, FTP_LOCATION),
		FTP_PATH = isnull(@ftpPath, FTP_PATH),
		FTP_HOST = isnull(@ftpHost, FTP_HOST),
		FTP_USERID = isnull(@ftpUserid, FTP_USERID),
		FTP_PASSWORD = isnull(@ftpPassword, FTP_PASSWORD),
		IS_TEST = isnull(@isTest, IS_TEST),
		UPDATE_ONLY = isnull(@UpdateOnly, UPDATE_ONLY),
		UPDATE_NAME = isnull(@UpdateName, UPDATE_NAME),
		UNIQUE_IDENTIFIER = isnull(@UniqueIdentifier, UNIQUE_IDENTIFIER),
		SYNC_TO_GDS = isnull(@SyncToGDS, SYNC_TO_GDS),
		CREATE_GDS_PROFILE = isnull(@CreateGDSProfile, CREATE_GDS_PROFILE),
		LOG_RECIPIENTS = isnull(@LogRecipients, LOG_RECIPIENTS),
		LAST_MOD_BY = @LastModBy,
		LAST_MOD_DATE = getdate(),
		LAST_RUN_DATE = isnull(@LastRunDate, LAST_RUN_DATE)
	where hr_feed_id = @HRFeedID
END
