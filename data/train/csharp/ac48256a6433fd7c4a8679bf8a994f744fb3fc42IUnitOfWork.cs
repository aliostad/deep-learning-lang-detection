using Dux.Domain.Interfaces;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;

namespace Dux.Infrastructure
{
    public interface IUnitOfWork
    {
        INomeListaRepository NomeListaRepository { get; }
        IUsuarioListaRepository UsuarioListaRepository { get; }
        IUsuarioCasaSelecRepository UsuarioCasaSelecRepository { get; }
        ICasaRepository CasaRepository { get; }
        IClientRepository ClientRepository { get; }
        IDistribuicaoRepository DistribuicaoRepository { get; }
        IListaRepository ListaRepository { get; }
        IAgendamentoRepository AgendamentoRepository { get; }
        IEventoRepository EventoRepository { get; }
        IGrupoRepository GrupoRepository { get; }
        ILayoutAgendamentoRepository LayoutAgendamentoRepository { get; }
        ILayoutDistribuicaoRepository LayoutDistribuicaoRepository { get; }
        ILayoutListaRepository LayoutListaRepository { get; }
        IPerfilDistribuicaoRepository PerfilDistribuicaoRepository { get; }
        IPerfilListaRepository PerfilListaRepository { get; }
        IRefreshTokenRepository RefreshTokenRepository { get; }
        RoleManager<IdentityRole> RoleManager { get; }
        UsuarioManager UsuarioManager { get; }

        void Dispose();
        int Save();
    }
}