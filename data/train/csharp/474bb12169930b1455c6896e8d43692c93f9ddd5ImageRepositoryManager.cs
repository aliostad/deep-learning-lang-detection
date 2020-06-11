using ImageAccessor.DiskRepository;

namespace ImageAccessor
{
    public class ImageRepositoryManager
    {
        private static ImageRepositoryManager instance = new ImageRepositoryManager();
        private IImageRepository imageRepository;

        public ImageRepositoryManager()
        {
            imageRepository = new DiskImageRepository();
        }

        public static ImageRepositoryManager Instance
        {
            get { return instance; }
        }

        public IImageRepository GetRepository()
        {
            return imageRepository;
        }
    }
}