using AzurePatterns.Repository;
namespace Ais.Internal.Dcm.Web.Service
{
    public interface IMetadataService
    {
        AssetFileRepository GetAssetFileRepository();
        AssetOutputRepository GetAssetOutputRepository();
        AssetRepository GetAssetRepository();
        AssetThumbnailRepository GetAssetThumbnailRepository();
        EncodingTypeRepository GetEncodingTypeRepository();
        MediaServiceRepository GetMediaServiceRepository();
        UnCommittedDataRepository GetUnCommittedDataRepository();
        TagRepository GetTagRepository();
    }
   
}
