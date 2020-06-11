CREATE  PROCEDURE [dbo].[InsertNewPersonLanguageProficiency]
    @PersonLanguageProficiencyId int output ,
    @PersonId int,
    @LanguageId int,
    @CanRead bit,
    @CanWrite bit,
    @CanSpeak bit
AS
INSERT INTO [Person].[PersonLanguageProficiency] (
    [PersonId],
    [LanguageId],
    [CanRead],
    [CanWrite],
    [CanSpeak])
Values (
    @PersonId,
    @LanguageId,
    @CanRead,
    @CanWrite,
    @CanSpeak)
Set @PersonLanguageProficiencyId = SCOPE_IDENTITY()
IF @@ROWCOUNT > 0
Select * from Person.PersonLanguageProficiency
Where [PersonLanguageProficiencyId] = @@identity
