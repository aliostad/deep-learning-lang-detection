using Ninject.Modules;
using VoluntariosNaEscola.Domain.Interfaces.Repository;
using VoluntariosNaEscola.Infra.Data.Repository.EntityFramework;

namespace VoluntariosNaEscola.Infra.CrossCutting.InversionOfControl.Modules
{
    public class RepositoryModule : NinjectModule
    {
        public override void Load()
        {
            Bind<IUsuarioRepository>().To<UsuarioRepository>();
            Bind<IAcaoRepository>().To<AcaoRepository>();
            Bind<IDiretorRepository>().To<DiretorRepository>();
            Bind<IEnderecoRepository>().To<EnderecoRepository>();
            Bind<IEscolaRepository>().To<EscolaRepository>();
            Bind<IEventoRepository>().To<EventoRepository>();
            Bind<IHabilidadeRepository>().To<HabilidadeRepository>();
            Bind<ISupervisorRepository>().To<SupervisorRepository>();
            Bind<IVoluntarioRepository>().To<VoluntarioRepository>();
            Bind<IConviteAprovacaoRepository>().To<ConviteAprovacaoRepository>();
        }
    }
}
