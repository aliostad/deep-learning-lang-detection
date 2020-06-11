using EstudioCapra.Backend.Repository;
using System;

namespace EstudioCapra.Backend
{
    public interface IUnitOfWork
    {
        ServicioRepository ServicioRepository
        {
            get;
        }

        ClienteRepository ClienteRepository
        {
            get;
        }

        ContratoRepository ContratoRepository
        {
            get;
        }

        TipoServicioRepository TipoServicioRepository
        {
            get;
        }

        TareaEmpleadoRepository TareaEmpleadoRepository
        {
            get;
        }

        ObjetoMultimediaRepository ObjetoMultimediaRepository
        {
            get;
        }

        TareaRepository TareaRespository
        {
            get;
        }

        TipoTareaRepository TipoTareaReposiory
        {
            get;
        }

        EmpleadoRepository EmpleadoRepository
        {
            get;
        }

        UsuarioRepository UsuarioRepository
        {
            get;
        }

        UsuarioRolRepository UsuarioRolRepository
        {
            get;
        }

        RolRepository RolRepository
        {
            get;
        }

        ItemMenuRepository ItemMenuRepository
        {
            get;
        }

        ContratoEmpleadoRepository ContratoEmpleadoRepository
        {
            get;
        }

        PagoRepository PagoRepository
        {
            get;
        }
        
        void Save();

        void Dispose();
    }
}
