using WinstonChurchill.Backend.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WinstonChurchill.Backend.Repository
{
    public partial class UnitOfWork : UnitOfWorkBase
    {
        private BaseRepository<Usuario> usuarioRepository;
        public BaseRepository<Usuario> UsuarioRepository
        {
            get
            {
                if (this.usuarioRepository == null)
                {
                    this.usuarioRepository = new BaseRepository<Usuario>(context);
                }
                return usuarioRepository;
            }
        }

        private BaseRepository<UsuarioXGrupoUsuario> usuarioXGrupoUsuarioRepository;
        public BaseRepository<UsuarioXGrupoUsuario> UsuarioXGrupoUsuarioRepository
        {
            get
            {
                if (this.usuarioXGrupoUsuarioRepository == null)
                {
                    this.usuarioXGrupoUsuarioRepository = new BaseRepository<UsuarioXGrupoUsuario>(context);
                }
                return usuarioXGrupoUsuarioRepository;
            }
        }

        private BaseRepository<GrupoUsuarioRecurso> grupoUsuarioRecursoRepository;
        public BaseRepository<GrupoUsuarioRecurso> GrupoUsuarioRecursoRepository
        {
            get
            {
                if (this.grupoUsuarioRecursoRepository == null)
                {
                    this.grupoUsuarioRecursoRepository = new BaseRepository<GrupoUsuarioRecurso>(context);
                }
                return grupoUsuarioRecursoRepository;
            }
        }

        private BaseRepository<GrupoUsuario> grupoUsuarioRepository;
        public BaseRepository<GrupoUsuario> GrupoUsuarioRepository
        {
            get
            {
                if (this.grupoUsuarioRepository == null)
                {
                    this.grupoUsuarioRepository = new BaseRepository<GrupoUsuario>(context);
                }
                return grupoUsuarioRepository;
            }
        }


        private BaseRepository<Categoria> categoriaRepository;
        public BaseRepository<Categoria> CategoriaRepository
        {
            get
            {
                if (this.categoriaRepository == null)
                {
                    this.categoriaRepository = new BaseRepository<Categoria>(context);
                }
                return categoriaRepository;
            }
        }


        private BaseRepository<CategoriaProduto> categoriaProdutoRepository;
        public BaseRepository<CategoriaProduto> CategoriaProdutoRepository
        {
            get
            {
                if (this.categoriaProdutoRepository == null)
                {
                    this.categoriaProdutoRepository = new BaseRepository<CategoriaProduto>(context);
                }
                return categoriaProdutoRepository;
            }
        }

        private BaseRepository<CategoriaImagem> categoriaImagemRepository;
        public BaseRepository<CategoriaImagem> CategoriaImagemRepository
        {
            get
            {
                if (this.categoriaImagemRepository == null)
                {
                    this.categoriaImagemRepository = new BaseRepository<CategoriaImagem>(context);
                }
                return categoriaImagemRepository;
            }
        }

        private BaseRepository<Produto> produtosRepository;
        public BaseRepository<Produto> ProdutosRepository
        {
            get
            {
                if (this.produtosRepository == null)
                {
                    this.produtosRepository = new BaseRepository<Produto>(context);
                }
                return produtosRepository;
            }
        }


        private BaseRepository<ProdutoImagem> produtoImagensRepository;
        public BaseRepository<ProdutoImagem> ProdutoImagensRepository
        {
            get
            {
                if (this.produtoImagensRepository == null)
                {
                    this.produtoImagensRepository = new BaseRepository<ProdutoImagem>(context);
                }
                return produtoImagensRepository;
            }
        }

        private BaseRepository<CaracteristicaProduto> caracteristicaProdutoRepository;
        public BaseRepository<CaracteristicaProduto> CaracteristicaProdutoRepository
        {
            get
            {
                if (this.caracteristicaProdutoRepository == null)
                {
                    this.caracteristicaProdutoRepository = new BaseRepository<CaracteristicaProduto>(context);
                }
                return caracteristicaProdutoRepository;
            }
        }

        private BaseRepository<Imagem> imagemRepository;
        public BaseRepository<Imagem> ImagemRepository
        {
            get
            {
                if (this.imagemRepository == null)
                {
                    this.imagemRepository = new BaseRepository<Imagem>(context);
                }
                return imagemRepository;
            }
        }

        private BaseRepository<Parametro> parametroRepository;
        public BaseRepository<Parametro> ParametroRepository
        {
            get
            {
                if (this.parametroRepository == null)
                {
                    this.parametroRepository = new BaseRepository<Parametro>(context);
                }
                return parametroRepository;
            }
        }

        private BaseRepository<Endereco> enderecoRepository;
        public BaseRepository<Endereco> EnderecoRepository
        {
            get
            {
                if (this.enderecoRepository == null)
                {
                    this.enderecoRepository = new BaseRepository<Endereco>(context);
                }
                return enderecoRepository;
            }
        }


        private BaseRepository<Grupo> grupoRepository;
        public BaseRepository<Grupo> GrupoRepository
        {
            get
            {
                if (this.grupoRepository == null)
                {
                    this.grupoRepository = new BaseRepository<Grupo>(context);
                }
                return grupoRepository;
            }
        }

        private BaseRepository<ParceiroNegocioGrupo> parceiroNegocioGrupoRepository;
        public BaseRepository<ParceiroNegocioGrupo> ParceiroNegocioGrupoRepository
        {
            get
            {
                if (this.parceiroNegocioGrupoRepository == null)
                {
                    this.parceiroNegocioGrupoRepository = new BaseRepository<ParceiroNegocioGrupo>(context);
                }
                return parceiroNegocioGrupoRepository;
            }
        }

        private BaseRepository<ParceiroNegocioUsuario> parceiroNegocioUsuarioRepository;
        public BaseRepository<ParceiroNegocioUsuario> ParceiroNegocioUsuarioRepository
        {
            get
            {
                if (this.parceiroNegocioUsuarioRepository == null)
                {
                    this.parceiroNegocioUsuarioRepository = new BaseRepository<ParceiroNegocioUsuario>(context);
                }
                return parceiroNegocioUsuarioRepository;
            }
        }

        private BaseRepository<GrupoCategoria> grupoCategoriaRepository;
        public BaseRepository<GrupoCategoria> GrupoCategoriaRepository
        {
            get
            {
                if (this.grupoCategoriaRepository == null)
                {
                    this.grupoCategoriaRepository = new BaseRepository<GrupoCategoria>(context);
                }
                return grupoCategoriaRepository;
            }
        }

        private BaseRepository<CompradorProduto> compradorProdutoRepository;
        public BaseRepository<CompradorProduto> CompradorProdutoRepository
        {
            get
            {
                if (this.compradorProdutoRepository == null)
                {
                    this.compradorProdutoRepository = new BaseRepository<CompradorProduto>(context);
                }
                return compradorProdutoRepository;
            }
        }

        private BaseRepository<Contato> contatoRepository;
        public BaseRepository<Contato> ContatoRepository
        {
            get
            {
                if (this.contatoRepository == null)
                {
                    this.contatoRepository = new BaseRepository<Contato>(context);
                }
                return this.contatoRepository;
            }
        }

        private BaseRepository<ParceiroNegocio> parceiroNegocioRepository;
        public BaseRepository<ParceiroNegocio> ParceiroNegocioRepository
        {
            get
            {
                if (this.parceiroNegocioRepository == null)
                {
                    this.parceiroNegocioRepository = new BaseRepository<ParceiroNegocio>(context);
                }
                return parceiroNegocioRepository;
            }
        }

        private BaseRepository<FornecedorProduto> fornecedorProdutoRepository;
        public BaseRepository<FornecedorProduto> FornecedorProdutoRepository
        {
            get
            {
                if (this.fornecedorProdutoRepository == null)
                {
                    this.fornecedorProdutoRepository = new BaseRepository<FornecedorProduto>(context);
                }
                return fornecedorProdutoRepository;
            }
        }



        private BaseRepository<Leilao> leilaoRepository;
        public BaseRepository<Leilao> LeilaoRepository
        {
            get
            {
                if (this.leilaoRepository == null)
                {
                    this.leilaoRepository = new BaseRepository<Leilao>(context);
                }
                return leilaoRepository;
            }
        }

        private BaseRepository<LeilaoComprador> leilaoCompradorRepository;
        public BaseRepository<LeilaoComprador> LeilaoCompradorRepository
        {
            get
            {
                if (this.leilaoCompradorRepository == null)
                {
                    this.leilaoCompradorRepository = new BaseRepository<LeilaoComprador>(context);
                }
                return leilaoCompradorRepository;
            }
        }

        private BaseRepository<LeilaoFornecedor> leilaoFornecedorRepository;
        public BaseRepository<LeilaoFornecedor> LeilaoFornecedorRepository
        {
            get
            {
                if (this.leilaoFornecedorRepository == null)
                {
                    this.leilaoFornecedorRepository = new BaseRepository<LeilaoFornecedor>(context);
                }
                return leilaoFornecedorRepository;
            }
        }

        private BaseRepository<LeilaoFornecedorRodada> leilaoFornecedorRodadaRepository;
        public BaseRepository<LeilaoFornecedorRodada> LeilaoFornecedorRodadaRepository
        {
            get
            {
                if (this.leilaoFornecedorRodadaRepository == null)
                {
                    this.leilaoFornecedorRodadaRepository = new BaseRepository<LeilaoFornecedorRodada>(context);
                }
                return leilaoFornecedorRodadaRepository;
            }
        }

        private BaseRepository<LeilaoRodada> leilaoRodadaRepository;
        public BaseRepository<LeilaoRodada> LeilaoRodadaRepository
        {
            get
            {
                if (this.leilaoRodadaRepository == null)
                {
                    this.leilaoRodadaRepository = new BaseRepository<LeilaoRodada>(context);
                }
                return leilaoRodadaRepository;
            }
        }



         
    }
}
