using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SisOpe.Domain.Interfaces.Repositories;
using SisOpe.Data.Contexto;

namespace SisOpe.Data.Repository.Repositories
{
    public class UnitOfWork : IUnitOfWork
    {
        #region propriedades
        private IAcessoRepository _acessoRepository;
        private IAcessoUsuarioRepository _acessoUsuarioRepository;
        private IArquivosOrdemServicoRepository _arquivosOrdemServicoRepository;
        private IContato_PJRepository _contato_PJRepository;
        private ICotacaoRepository _cotacaoRepository;
        private IDepartamentoRepository _departamentoRepository;
        private IEmailRepository _emailRepository;
        private IEnderecoRepository _enderecoRepository;
        private IEntradaProdutoNFRepository _entradaProdutoNFRepository;
        private IEntradaProdutoRepository _entradaProdutoRepository;
        private IEquipeOrdemServicoRepository _equipeOrdemServicoRepository;
        private IFinalidadeRepository _finalidadeRepository;
        private IFormaPagamentoRepository _formaPagamentoRepository;
        private IFornecedorCotacaoRepository _fornecedorCotacaoRepository;
        private IFuncionarioRepository _funcionarioRepository;
        private IHistoricoOrdemServicoRepository _historicoOrdemServicoRepository;
        private IHistoricoStatusCotacaoRepository _historicoStatusCotacaoRepository;
        private IItemEntradaEstoqueRepository _itemEntradaEstoqueRepository;
        private IItemEstoqueRepository _itemEstoqueRepository;
        private IItemPedidoCompraCotacaoRepository _itemPedidoCompraCotacaoRepository;
        private IItemPedidoCompraRepository _itemPedidoCompraRepository;
        private IItemProdutoNotaFiscalRepository _itemProdutoNotaFiscalRepository;
        private IItemReservaVendaProdutoRepository _itemReservaVendaProdutoRepository;
        private IItemRetornoCotacaoRepository _itemRetornoCotacaoRepository;
        private IItemSolicitacaoCompraCotacaoRepository _itemSolicitacaoCompraCotacaoRepository;
        private IItemSolicitacaoCompraRepository _itemSolicitacaoCompraRepository;
        private IItemTransferenciaEstoqueRepository _itemTransferenciaEstoqueRepository;
        private IItemVendaEstoqueRepository _itemVendaEstoqueRepository;
        private IMarcaProdutoRepository _marcaProdutoRepository;
        private INotaFiscalRepository _notaFiscalRepository;
        private IOrdemServicoRepository _ordemServicoRepository;
        private IPagamentoOrdemServicoRepository _pagamentoOrdemServicoRepository;
        private IPagamentoPedidoCompraRepository _pagamentoPedidoCompraRepository;
        private IPagamentoRetornoCotacaoRepository _pagamentoRetornoCotacaoRepository;
        private IPedidoCompraRepository _pedidoCompraRepository;
        private IPessoaFisicaRepository _pessoaFisicaRepository;
        private IPessoaJuridicaRepository _pessoaJuridicaRepository;
        private IPessoaRepository _pessoaRepository;
        private IProdutoCotacaoRepository _produtoCotacaoRepository;
        private IProdutoRepository _produtoRepository;
        private IProfissaoFuncionarioRepository _profissaoFuncionarioRepository;
        private IProfissaoRepository _profissaoRepository;
        private IReservaRepository _reservaRepository;
        private ISolicitacaoCompraRepository _solicitacaoCompraRepository;
        private ISolicitacaoPedidoCompraRepository _solicitacaoPedidoCompraRepository;
        private IStatusCotacaoRepository _statusCotacaoRepository;
        private IStatusOrdemServicoRepository _statusOrdemServicoRepository;
        private ITabelaPrecoRepository _tabelaPrecoRepository;
        private ITelefoneRepository _telefoneRepository;
        private ITipoProdutoRepository _tipoProdutoRepository;
        private ITransferenciaEstoqueRepository _transferenciaEstoqueRepository;
        private IUnidadeMedidaRepository _unidadeMedidaRepository;
        private IUnidadeRepository _unidadeRepository;
        private IUsuarioRepository _usuarioRepository;
        private IVendaProdutoNFRepository _vendaProdutoNFRepository;
        private IVendaProdutoRepository _vendaProdutoRepository;

        #endregion

        public void Dispose()
        {

        }
        private readonly SysOpContext _db;

        public  UnitOfWork(SysOpContext db)
        {
            _db = db;
        }

        //public UnitOfWork()
        //{
        //    _db = new SysOpContext();
        //}

        #region Metodos

        public IAcessoRepository AcessoRepository
        {
            get { return _acessoRepository ??  (_acessoRepository = new AcessoRepository(_db)); }
        }

        public IAcessoUsuarioRepository  AcessoUsuarioRepository
        {
            get { return _acessoUsuarioRepository ?? (_acessoUsuarioRepository = new AcessoUsuarioRepository(_db)); }

        }

        public  IArquivosOrdemServicoRepository  ArquivosOrdemServicoRepository
        {
            get { return _arquivosOrdemServicoRepository ?? (_arquivosOrdemServicoRepository = new ArquivosOrdemServicoRepository(_db)); }
        }

        public IContato_PJRepository Contato_PJRepository
        {
            get { return _contato_PJRepository ?? (_contato_PJRepository = new Contato_PJRepository(_db)); }
        }

        public ICotacaoRepository CotacaoRepository
        {
            get { return _cotacaoRepository ?? (_cotacaoRepository = new CotacaoRepository(_db)); }
        }

        public IDepartamentoRepository  DepartamentoRepository
        {
            get { return _departamentoRepository ?? (_departamentoRepository = new DepartamentoRepository(_db)); }

        }

        public IEmailRepository EmailRepository
        {
            get { return _emailRepository ?? (_emailRepository = new EmailRepository(_db)); }
        }

        public IEnderecoRepository EnderecoRepository
        {
            get { return _enderecoRepository ?? (_enderecoRepository = new EnderecoRepository(_db)); }
        }

        public IEntradaProdutoNFRepository  EntradaProdutoNFRepository
        {
            get { return _entradaProdutoNFRepository ?? (_entradaProdutoNFRepository = new EntradaProdutoNFRepository(_db)); }
        }

        public IEntradaProdutoRepository EntradaProdutoRepository
        {
            get { return _entradaProdutoRepository ?? (_entradaProdutoRepository = new EntradaProdutoRepository(_db)); }
        }
        public IEquipeOrdemServicoRepository EquipeOrdemServicoRepository
        {
            get { return _equipeOrdemServicoRepository ?? (_equipeOrdemServicoRepository = new EquipeOrdemServicoRepository(_db)); }
        }
        public IFinalidadeRepository FinalidadeRepository
        {
            get { return _finalidadeRepository ?? (_finalidadeRepository = new FinalidadeRepository(_db)); }
        }
        public IFormaPagamentoRepository  FormaPagamentoRepository
        {
            get { return _formaPagamentoRepository ?? (_formaPagamentoRepository = new FormaPagamentoRepository(_db));  }
        }

        public IFornecedorCotacaoRepository  FornecedorCotacaoRepository
        {
            get { return _fornecedorCotacaoRepository ?? (_fornecedorCotacaoRepository = new FornecedorCotacaoRepository(_db)); }
        }

        public IFuncionarioRepository FuncionarioRepository
        {
            get { return _funcionarioRepository ?? (_funcionarioRepository = new FuncionarioRepository(_db)); }
        }

        public IHistoricoOrdemServicoRepository HistoricoOrdemServicoRepository
        {
            get { return _historicoOrdemServicoRepository ?? (_historicoOrdemServicoRepository = new HistoricoOrdemServicoRepository(_db)); }
        }

        public IHistoricoStatusCotacaoRepository HistoricoStatusCotacaoRepository
        {
            get { return _historicoStatusCotacaoRepository ?? (_historicoStatusCotacaoRepository = new HistoricoStatusCotacaoRepository(_db)); }
        }
        public IItemEntradaEstoqueRepository ItemEntradaEstoqueRepository
        {
            get { return _itemEntradaEstoqueRepository ?? (_itemEntradaEstoqueRepository = new ItemEntradaEstoqueRepository(_db)); }
        }
        public IItemEstoqueRepository ItemEstoqueRepository
        {
            get { return _itemEstoqueRepository ?? (_itemEstoqueRepository = new ItemEstoqueRepository(_db)); }
        }
        public IItemPedidoCompraCotacaoRepository ItemPedidoCompraCotacaoRepository
        {
            get { return _itemPedidoCompraCotacaoRepository ?? (_itemPedidoCompraCotacaoRepository = new ItemPedidoCompraCotacaoRepository(_db)); }
        }
        public IItemPedidoCompraRepository ItemPedidoCompraRepository
        {
            get { return _itemPedidoCompraRepository ?? (_itemPedidoCompraRepository = new ItemPedidoCompraRepository(_db)); }
        }

        public IItemProdutoNotaFiscalRepository ItemProdutoNotaFiscalRepository
        {
            get { return _itemProdutoNotaFiscalRepository ?? (_itemProdutoNotaFiscalRepository = new ItemProdutoNotaFiscalRepository(_db)); }
        }

        public IItemReservaVendaProdutoRepository ItemReservaVendaProdutoRepository
        {
            get { return _itemReservaVendaProdutoRepository ?? (_itemReservaVendaProdutoRepository = new ItemReservaVendaProdutoRepository(_db)); }
        }

        public IItemRetornoCotacaoRepository ItemRetornoCotacaoRepository
        {
            get { return _itemRetornoCotacaoRepository ?? (_itemRetornoCotacaoRepository = new ItemRetornoCotacaoRepository(_db)); }
        }
        public IItemSolicitacaoCompraCotacaoRepository ItemSolicitacaoCompraCotacaoRepository
        {
            get { return _itemSolicitacaoCompraCotacaoRepository ?? (_itemSolicitacaoCompraCotacaoRepository = new ItemSolicitacaoCompraCotacaoRepository(_db)); }
        }

        public IItemSolicitacaoCompraRepository ItemSolicitacaoCompraRepository
        {
            get { return _itemSolicitacaoCompraRepository ?? (_itemSolicitacaoCompraRepository = new ItemSolicitacaoCompraRepository(_db)); }
        }
        public IItemTransferenciaEstoqueRepository ItemTransferenciaEstoqueRepository
        {
            get { return _itemTransferenciaEstoqueRepository ?? (_itemTransferenciaEstoqueRepository = new ItemTransferenciaEstoqueRepository(_db)); }
        }
        public IItemVendaEstoqueRepository ItemVendaEstoqueRepository
        {
            get { return _itemVendaEstoqueRepository ?? (_itemVendaEstoqueRepository = new ItemVendaRepository(_db)); }
        }

        public IMarcaProdutoRepository MarcaProdutoRepository
        {
            get { return _marcaProdutoRepository ?? (_marcaProdutoRepository = new MarcaProdutoRepository(_db)); }
        }

        public INotaFiscalRepository NotaFiscalRepository
        {
            get { return _notaFiscalRepository ?? (_notaFiscalRepository = new NotaFiscalRepository(_db)); }
        }

        public IOrdemServicoRepository OrdemServicoRepository
        {
            get { return _ordemServicoRepository ?? (_ordemServicoRepository = new OrdemServicoRepository(_db)); }
        }

        public IPagamentoOrdemServicoRepository PagamentoOrdemServicoRepository
        {
            get { return _pagamentoOrdemServicoRepository ?? (_pagamentoOrdemServicoRepository = new PagamentoOrdemServicoRepository(_db)); }
        }

        public IPagamentoPedidoCompraRepository PagamentoPedidoCompraRepository
        {
            get { return _pagamentoPedidoCompraRepository ?? (_pagamentoPedidoCompraRepository = new PagamentoPedidoCompraRepository(_db)); }
        }

        public IPagamentoRetornoCotacaoRepository PagamentoRetornoCotacaoRepository
        {
            get { return _pagamentoRetornoCotacaoRepository ?? (_pagamentoRetornoCotacaoRepository = new PagamentoRetornoCotacaoRepository(_db)); }
        }

        public IPedidoCompraRepository PedidoCompraRepository
        {
            get { return _pedidoCompraRepository ?? (_pedidoCompraRepository = new PedidoCompraRepository(_db)); }
        }

        public IPessoaFisicaRepository PessoaFisicaRepository
        {
            get { return _pessoaFisicaRepository ?? (_pessoaFisicaRepository = new PessoaFisicaRepository(_db)); }
        }

        public IPessoaJuridicaRepository PessoaJuridicaRepository
        {
            get { return _pessoaJuridicaRepository ?? (_pessoaJuridicaRepository = new PessoaJuridicaRepository(_db)); }
        }

        public IPessoaRepository PessoaRepository
        {
            get { return _pessoaRepository ?? (_pessoaRepository = new PessoaRepository(_db)); }
        }

        public IProdutoCotacaoRepository ProdutoCotacaoRepository
        {
            get { return _produtoCotacaoRepository ?? (_produtoCotacaoRepository = new ProdutoCotacaoRepository(_db)); }
        }
        public IProdutoRepository ProdutoRepository
        {
            get { return _produtoRepository ?? (_produtoRepository = new ProdutoRepository(_db)); }
        }
        public IProfissaoFuncionarioRepository ProfissaoFuncionarioRepository
        {
            get { return _profissaoFuncionarioRepository ?? (_profissaoFuncionarioRepository = new ProfissaoFuncionarioRepository(_db)); }
        }
        public IProfissaoRepository ProfissaoRepository
        {
            get { return _profissaoRepository ?? (_profissaoRepository = new ProfissaoRepository(_db)); }
        }
        public IReservaRepository ReservaRepository
        {
            get { return _reservaRepository ?? (_reservaRepository = new ReservaRepository(_db)); }
        }

        public ISolicitacaoCompraRepository SolicitacaoCompraRepository
        {
            get { return _solicitacaoCompraRepository ?? (_solicitacaoCompraRepository = new SolicitacaoCompraRepository(_db)); }
        }

        public ISolicitacaoPedidoCompraRepository SolicitacaoPedidoCompraRepository
        {
            get { return _solicitacaoPedidoCompraRepository ?? (_solicitacaoPedidoCompraRepository = new SolicitacaoPedidoCompraRepository(_db)); }
        }
        public IStatusCotacaoRepository StatusCotacaoRepository
        {
            get { return _statusCotacaoRepository ?? (_statusCotacaoRepository = new StatusCotacaoRepository(_db)); }
        }
        public IStatusOrdemServicoRepository StatusOrdemServicoRepository
        {
            get { return _statusOrdemServicoRepository ?? (_statusOrdemServicoRepository = new StatusOrdemServicoRepository(_db)); }
        }
        public ITabelaPrecoRepository TabelaPrecoRepository
        {
            get { return _tabelaPrecoRepository ?? (_tabelaPrecoRepository = new TabelaPrecoRepository(_db)); }
        }
        public ITelefoneRepository TelefoneRepository
        {
            get { return _telefoneRepository ?? (_telefoneRepository = new TelefoneRepository(_db)); }
        }
        public ITipoProdutoRepository TipoProdutoRepository
        {
            get { return _tipoProdutoRepository ?? (_tipoProdutoRepository = new TipoProdutoRepository(_db)); }
        }
        public ITransferenciaEstoqueRepository TransferenciaEstoqueRepository
        {
            get { return _transferenciaEstoqueRepository ?? (_transferenciaEstoqueRepository = new TransferenciaEstoqueRepository(_db)); }
        }
        public IUnidadeMedidaRepository UnidadeMedidaRepository
        {
            get { return _unidadeMedidaRepository ?? (_unidadeMedidaRepository = new UnidadeMedidaRepository(_db)); }
        }
        public IUnidadeRepository UnidadeRepository
        {
            get { return _unidadeRepository ?? (_unidadeRepository = new UnidadeRepository(_db)); }
        }

        public IUsuarioRepository UsuarioRepository
        {
            get { return _usuarioRepository ?? (_usuarioRepository = new UsuarioRepository(_db)); }
        }
        public IVendaProdutoNFRepository VendaProdutoNFRepository
        {
            get { return _vendaProdutoNFRepository ?? (_vendaProdutoNFRepository = new VendaProdutoNFRepository(_db)); }
        }

        public IVendaProdutoRepository VendaProdutoRepository
        {
            get { return _vendaProdutoRepository ?? (_vendaProdutoRepository = new VendaProdutoRepository(_db)); }
        }
        #endregion
    }
}
