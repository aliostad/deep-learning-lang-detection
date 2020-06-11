using Standartstyle.AppCode.DAL.Model;
using Standartstyle.AppCode.DAL.Repository.EntityRepositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Standartstyle.AppCode.DAL.Repository
{
    public class GeneralRepository : IDisposable
    {
        private Entities context = new Entities();

        private CBDCollectionRepository _CBDCollectionRepository;
        public CBDCollectionRepository CBDCollectionRepository
        {
            get
            {
                if (this._CBDCollectionRepository == null)
                    this._CBDCollectionRepository = new CBDCollectionRepository(context);
                return _CBDCollectionRepository;
            }
        }

        private CBDColorRepository _CBDColorRepository;
        public CBDColorRepository CBDColorRepository
        {
            get
            {
                if (this._CBDColorRepository == null)
                    this._CBDColorRepository = new CBDColorRepository(context);
                return _CBDColorRepository;
            }
        }

        private CBDManufacturerRepository _CBDManufacturerRepository;
        public CBDManufacturerRepository CBDManufacturerRepository
        {
            get
            {
                if (this._CBDManufacturerRepository == null)
                    this._CBDManufacturerRepository = new CBDManufacturerRepository(context);
                return _CBDManufacturerRepository;
            }
        }

        private GoodColorRepository _GoodColorRepository;
        public GoodColorRepository GoodColorRepository
        {
            get
            {
                if (this._GoodColorRepository == null)
                    this._GoodColorRepository = new GoodColorRepository(context);
                return _GoodColorRepository;
            }
        }

        private GoodsCategoryRepository _GoodsCategoryRepository;
        public GoodsCategoryRepository GoodsCategoryRepository
        {
            get
            {
                if (this._GoodsCategoryRepository == null)
                    this._GoodsCategoryRepository = new GoodsCategoryRepository(context);
                return _GoodsCategoryRepository;
            }
        }

        private GoodsRepository _GoodsRepository;
        public GoodsRepository GoodsRepository
        {
            get
            {
                if (this._GoodsRepository == null)
                    this._GoodsRepository = new GoodsRepository(context);
                return _GoodsRepository;
            }
        }

        private ImageRepository _ImageRepository;
        public ImageRepository ImageRepository
        {
            get
            {
                if (this._ImageRepository == null)
                    this._ImageRepository = new ImageRepository(context);
                return _ImageRepository;
            }
        }

        private ReplyRepository _ReplyRepository;
        public ReplyRepository ReplyRepository
        {
            get
            {
                if (this._ReplyRepository == null)
                    this._ReplyRepository = new ReplyRepository(context);
                return _ReplyRepository;
            }
        }

        private UsersRepository _UsersRepository;
        public UsersRepository UsersRepository
        {
            get
            {
                if (this._UsersRepository == null)
                    this._UsersRepository = new UsersRepository(context);
                return _UsersRepository;
            }
        }

        private AttributesRepository _AttributesRepository;
        public AttributesRepository AttributesRepository
        {
            get
            {
                if (this._AttributesRepository == null)
                    this._AttributesRepository = new AttributesRepository(context);
                return _AttributesRepository;
            }
        }

        private GoodAttributesRepository _GoodAttributesRepository;
        public GoodAttributesRepository GoodAttributesRepository
        {
            get
            {
                if (this._GoodAttributesRepository == null)
                    this._GoodAttributesRepository = new GoodAttributesRepository(context);
                return _GoodAttributesRepository;
            }
        }

        private RolesRepository _RolesRepository;
        public RolesRepository RolesRepository
        {
            get
            {
                if (this._RolesRepository == null)
                    this._RolesRepository = new RolesRepository(context);
                return _RolesRepository;
            }
        }

        public void Save()
        {
            context.SaveChanges();
        }

        private bool disposed = false;

        protected virtual void Dispose(bool disposing)
        {
            if (!this.disposed)
            {
                if (disposing)
                {
                    context.Dispose();
                }
            }
            this.disposed = true;
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
    }
}