using System;
using System.Threading.Tasks;

namespace DevDay2016SmartGallery.DAL
{
    public class UnitOfWork : IDisposable
    {
        public AppDbContext Context;

        public UnitOfWork()
        {
            Context = AppDbContext.Create();
        }

        private PictureRepository _pictureRepository;
        public PictureRepository PictureRepository =>
            _pictureRepository ?? (_pictureRepository = new PictureRepository(Context));

        private TagRepository _tagRepository;
        public TagRepository TagRepository =>
            _tagRepository ?? (_tagRepository = new TagRepository(Context));

        private PersonRepository _personRepository;
        public PersonRepository PersonRepository =>
            _personRepository ?? (_personRepository = new PersonRepository(Context));

        private FaceRepository _faceRepository;
        public FaceRepository FaceRepository =>
            _faceRepository ?? (_faceRepository = new FaceRepository(Context));

        public void Dispose()
        {
            Context?.Dispose(); 
        }
    }
}