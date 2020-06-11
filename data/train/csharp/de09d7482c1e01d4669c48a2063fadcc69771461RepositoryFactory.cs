using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using ePortafolioMVC.Models.Repository;

namespace ePortafolioMVC.Models
{
    public static class RepositoryFactory
    {
        private static AlumnoRepository myAlumnoRepository = null;
        public static AlumnoRepository GetAlumnoRepository()
        {
            if (myAlumnoRepository == null)
            {
                myAlumnoRepository = new AlumnoRepository();
            }
            return myAlumnoRepository;
        }

        private static ArchivoRepository myArchivoRepository = null;
        public static ArchivoRepository GetArchivoRepository()
        {
            if (myArchivoRepository == null)
            {
                myArchivoRepository = new ArchivoRepository();
            }
            return myArchivoRepository;
        }

        private static CursoRepository myCursoRepository = null;
        public static CursoRepository GetCursoRepository()
        {
            if (myCursoRepository == null)
            {
                myCursoRepository = new CursoRepository();
            }
            return myCursoRepository;
        }

        private static GrupoRepository myGrupoRepository = null;
        public static GrupoRepository GetGrupoRepository()
        {
            if (myGrupoRepository == null)
            {
                myGrupoRepository = new GrupoRepository();
            }
            return myGrupoRepository;
        }

        private static ProfesorRepository myProfesorRepository = null;
        public static ProfesorRepository GetProfesorRepository()
        {
            if (myProfesorRepository == null)
            {
                myProfesorRepository = new ProfesorRepository();
            }
            return myProfesorRepository;
        }

        private static ResultadoProgramaRepository myResultadoProgramaRepository = null;
        public static ResultadoProgramaRepository GetResultadoProgramaRepository()
        {
            if (myResultadoProgramaRepository == null)
            {
                myResultadoProgramaRepository = new ResultadoProgramaRepository();
            }
            return myResultadoProgramaRepository;
        }

        private static ResultadoRubricaRepository myResultadoRubricaRepository = null;
        public static ResultadoRubricaRepository GetResultadoRubricaRepository()
        {
            if (myResultadoRubricaRepository == null)
            {
                myResultadoRubricaRepository = new ResultadoRubricaRepository();
            }
            return myResultadoRubricaRepository;
        }

        private static TrabajoRepository myTrabajoRepository = null;
        public static TrabajoRepository GetTrabajoRepository()
        {
            if (myTrabajoRepository == null)
            {
                myTrabajoRepository = new TrabajoRepository();
            }
            return myTrabajoRepository;
        }

        private static SeccionRepository mySeccionRepository = null;
        public static SeccionRepository GetSeccionRepository()
        {
            if (mySeccionRepository == null)
            {
                mySeccionRepository = new SeccionRepository();
            }
            return mySeccionRepository;
        }

        private static RubricaRepository myRubricaRepository = null;
        public static RubricaRepository GetRubricaRepository()
        {
            if (myRubricaRepository == null)
            {
                myRubricaRepository = new RubricaRepository();
            }
            return myRubricaRepository;
        }

        private static CriterioRepository myCriterioRubricaRepository = null;
        public static CriterioRepository GetCriterioRubricaRepository()
        {
            if (myCriterioRubricaRepository == null)
            {
                myCriterioRubricaRepository = new CriterioRepository();
            }
            return myCriterioRubricaRepository;
        }

        private static PeriodoRepository myPeriodoRepository = null;
        public static PeriodoRepository GetPeriodoRepository()
        {
            if (myPeriodoRepository == null)
            {
                myPeriodoRepository = new PeriodoRepository();
            }
            return myPeriodoRepository;
        }
    }
}
