CREATE  PROCEDURE [dbo].[UpdatePersonLanguageProficiency]
    @OldPersonLanguageProficiencyId int,
    @PersonId int,
    @LanguageId int,
    @CanRead bit,
    @CanWrite bit,
    @CanSpeak bit
AS
UPDATE [Person].[PersonLanguageProficiency]
SET
    PersonId = @PersonId,
    LanguageId = @LanguageId,
    CanRead = @CanRead,
    CanWrite = @CanWrite,
    CanSpeak = @CanSpeak
WHERE [PersonLanguageProficiencyId] = @OLDPersonLanguageProficiencyId
IF @@ROWCOUNT > 0
Select * From Person.PersonLanguageProficiency 
Where [PersonLanguageProficiencyId] = @OLDPersonLanguageProficiencyId
