namespace OpenDriver
{
    public interface IDriveInteractiable
    {
        ApiData DriveMeta();
        
        ApiData FileOrFolderMeta();
        
        ApiData DeleteFileOrFolder();
        
        ApiData PatchFileOrFolder();
        
        ApiData CopyFileOrFolder();
        
        ApiData GetDownloadLink();
        
        ApiData GetFilesList(ApiSortingParameters sortingParameters);
        
        ApiData MoveFileOrFolder();
        
        ApiData GetPublishedResources();
        
        ApiData PublishResource();
        
        ApiData UnpublishResource();
        
        ApiData UploadFileViaUrl();
        
        ApiData GetLinkToUploadFile();

        ApiData CleanTrash();

        ApiData RestoreFromTrash();

        ApiData GetTrashContent();
    }
}