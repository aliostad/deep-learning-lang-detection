using AppTeste.Backend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AppTeste.Backend.Repository
{
    public partial class UnitOfWork : UnitOfWorkBase
    {
        private BaseRepository<Talento> talentoRepository;
        public BaseRepository<Talento> TalentoRepository
        {
            get
            {
                if (this.talentoRepository == null)
                {
                    this.talentoRepository = new BaseRepository<Talento>(context);
                }
                return talentoRepository;
            }
        }

        private BaseRepository<Conhecimento> conhecimentoRepository;
        public BaseRepository<Conhecimento> ConhecimentoRepository
        {
            get
            {
                if (this.conhecimentoRepository == null)
                {
                    this.conhecimentoRepository = new BaseRepository<Conhecimento>(context);
                }
                return conhecimentoRepository;
            }
        }

        private BaseRepository<TalentoConhecimento> talentoConhecimentoRepository;
        public BaseRepository<TalentoConhecimento> TalentoConhecimentoRepository
        {
            get
            {
                if (this.talentoConhecimentoRepository == null)
                {
                    this.talentoConhecimentoRepository = new BaseRepository<TalentoConhecimento>(context);
                }
                return talentoConhecimentoRepository;
            }
        }

        private BaseRepository<TalentoInformacaoBancaria> talentoInformacaoBancariaRepository;
        public BaseRepository<TalentoInformacaoBancaria> TalentoInformacaoBancariaRepository
        {
            get
            {
                if (this.talentoInformacaoBancariaRepository == null)
                {
                    this.talentoInformacaoBancariaRepository = new BaseRepository<TalentoInformacaoBancaria>(context);
                }
                return talentoInformacaoBancariaRepository;
            }
        }

        private BaseRepository<Horario> horarioRepository;
        public BaseRepository<Horario> HorarioRepository
        {
            get
            {
                if (this.horarioRepository == null)
                {
                    this.horarioRepository = new BaseRepository<Horario>(context);
                }
                return horarioRepository;
            }
        }

        private BaseRepository<TalentoHorario> talentoHorarioRepository;
        public BaseRepository<TalentoHorario> TalentoHorarioRepository
        {
            get
            {
                if (this.talentoHorarioRepository == null)
                {
                    this.talentoHorarioRepository = new BaseRepository<TalentoHorario>(context);
                }
                return talentoHorarioRepository;
            }
        }

        private BaseRepository<Disponibilidade> disponibilidadeRepository;
        public BaseRepository<Disponibilidade> DisponibilidadeRepository
        {
            get
            {
                if (this.disponibilidadeRepository == null)
                {
                    this.disponibilidadeRepository = new BaseRepository<Disponibilidade>(context);
                }
                return disponibilidadeRepository;
            }
        }

        private BaseRepository<TalentoDisponibilidade> talentoDisponibilidadeRepository;
        public BaseRepository<TalentoDisponibilidade> TalentoDisponibilidadeRepository
        {
            get
            {
                if (this.talentoDisponibilidadeRepository == null)
                {
                    this.talentoDisponibilidadeRepository = new BaseRepository<TalentoDisponibilidade>(context);
                }
                return talentoDisponibilidadeRepository;
            }
        }

    }
}
