using System;
using System.Collections.Generic;
using System.Linq;
using Middleware.Model.API;
using Middleware.Model.Local;

namespace Middleware.Controller
{
    public static class ComparisonController
    {
        #region Sesion
        public static List<VFPSesion> GetNewObjects(List<VFPSesion> vfpList, List<APISesion> apiList)
        {
            return vfpList.Where(vfp => !apiList.Exists(api => api.numero == vfp.numero && api.linea == vfp.linea)).ToList();
        }
        public static List<Tuple<int, VFPSesion>> GetUpdatedObjects(List<VFPSesion> vfpList, List<APISesion> apiList)
        {
            return (from vfp in vfpList from api in apiList.Where(api => api.numero == vfp.numero && vfp.linea == api.linea) where !vfp.tipo.Equals(api.tipo) || vfp.correl != api.correl || vfp.va_ifrs != api.va_ifrs || vfp.canbco != api.canbco || !vfp.banco.Equals(api.banco) || !vfp.cuenta.Equals(api.cuenta) || vfp.cheque != api.cheque || !vfp.fecha.Equals(api.fecha) || !vfp.glosa.Equals(api.glosa) || !vfp.benefi.Equals(api.benefi) || !vfp.fechach.Equals(api.fechach) || !vfp.area.Equals(api.area) || !vfp.codigo.Equals(api.codigo) || !vfp.tipdoc.Equals(api.tipdoc) || !vfp.fechafac.Equals(api.fechafac) || vfp.fac != api.fac || vfp.corrfac != api.corrfac || !vfp.detalle1.Equals(api.detalle1) || !vfp.detalle2.Equals(api.detalle2) || !vfp.detalle3.Equals(api.detalle3) || !vfp.detalle4.Equals(api.detalle4) || !vfp.imp.Equals(api.imp) || vfp.debe != api.debe || vfp.haber != api.haber || vfp.estado != api.estado select new Tuple<int, VFPSesion>(api.id, vfp)).ToList();
        }
        public static List<APISesion> GetDeletedObjects(List<VFPSesion> vfpList, List<APISesion> apiList)
        {
            return apiList.Where(api => !vfpList.Exists(vfp => vfp.numero == api.numero && vfp.linea == api.linea)).ToList();
        }
        #endregion
        #region Tabanco
        public static List<VFPTabanco> GetNewObjects(List<VFPTabanco> vfpList, List<APITabanco> apiList)
        {
            return vfpList.Where(vfp => !apiList.Exists(api => api.codbanco.Equals(vfp.codbanco))).ToList();
        }
        public static List<Tuple<int, VFPTabanco>> GetUpdatedObjects(List<VFPTabanco> vfpList, List<APITabanco> apiList)
        {
            return (from vfp in vfpList from api in apiList.Where(api => api.codbanco.Equals(vfp.codbanco)) where !vfp.codempre.Equals(api.codempre) || !vfp.codbanco.Equals(api.codbanco) || !vfp.nombanco.Equals(api.nombanco) || !vfp.codctacc.Equals(api.codctacc) || !vfp.ctacc.Equals(api.ctacc) || !vfp.ctacontab.Equals(api.ctacontab) || vfp.chequeact != api.chequeact || vfp.chequefin != api.chequefin || vfp.ingreact != api.ingreact || vfp.ingrefin != api.ingrefin || vfp.egreact != api.egreact || vfp.egrefin != api.egrefin || vfp.trasact != api.trasact || vfp.trasfin != api.trasfin || vfp.compact != api.compact || vfp.compfin != api.compfin || vfp.ventact != api.ventact || vfp.ventfin != api.ventfin || vfp.uniact != api.uniact || vfp.estado != api.estado || vfp.ano != api.ano || vfp.flg_ing != api.flg_ing select new Tuple<int, VFPTabanco>(api.id, vfp)).ToList();
        }
        public static List<APITabanco> GetDeletedObjects(List<VFPTabanco> vfpList, List<APITabanco> apiList)
        {
            return apiList.Where(api => !vfpList.Exists(vfp => vfp.codbanco.Equals(api.codbanco))).ToList();
        }
        #endregion
        #region MaeCue
        public static List<VFPMaeCue> GetNewObjects(List<VFPMaeCue> vfpList, List<APIMaeCue> apiList)
        {
            return vfpList.Where(vfp => !apiList.Exists(api => api.codigo.Equals(vfp.codigo))).ToList();
        }
        public static List<Tuple<int, VFPMaeCue>> GetUpdatedObjects(List<VFPMaeCue> vfpList, List<APIMaeCue> apiList)
        {
            return (from vfp in vfpList from api in apiList.Where(api => api.codigo.Equals(vfp.codigo)) where !vfp.codigofecu.Equals(api.codigofecu) || !vfp.clase.Equals(api.clase) || !vfp.nivel.Equals(api.nivel) || !vfp.subcta.Equals(api.subcta) || !vfp.ctacte.Equals(api.ctacte) || !vfp.ctacte2.Equals(api.ctacte2) || !vfp.ctacte3.Equals(api.ctacte3) || !vfp.ctacte4.Equals(api.ctacte4) || !vfp.estado.Equals(api.estado) || !vfp.estado2.Equals(api.estado2) || !vfp.nombre.Equals(api.nombre) || vfp.codi != api.codi || vfp.debe0 != api.debe0 || vfp.haber0 != api.haber0 || vfp.debe1 != api.debe1 || vfp.haber1 != api.haber1 || vfp.debe2 != api.debe2 || vfp.haber2 != api.haber2 || vfp.debe3 != api.debe3 || vfp.haber3 != api.haber3 || vfp.debe4 != api.debe4 || vfp.haber4 != api.haber4 || vfp.debe5 != api.debe5 || vfp.haber5 != api.haber5 || vfp.debe6 != api.debe6 || vfp.haber6 != api.haber6 || vfp.debe7 != api.debe7 || vfp.haber7 != api.haber7 || vfp.debe8 != api.debe8 || vfp.haber8 != api.haber8 || vfp.debe9 != api.debe9 || vfp.haber9 != api.haber9 || vfp.debe10 != api.debe10 || vfp.haber10 != api.haber10 || vfp.debe11 != api.debe11 || vfp.haber11 != api.haber11 || vfp.debe12 != api.debe12 || vfp.haber12 != api.haber12 || vfp.debep0 != api.debep0 || vfp.haberp0 != api.haberp0 || vfp.debep1 != api.debep1 || vfp.haberp1 != api.haberp1 || vfp.debep2 != api.debep2 || vfp.haberp2 != api.haberp2 || vfp.debep3 != api.debep3 || vfp.haberp3 != api.haberp3 || vfp.debep4 != api.debep4 || vfp.haberp4 != api.haberp4 || vfp.debep5 != api.debep5 || vfp.haberp5 != api.haberp5 || vfp.debep6 != api.debep6 || vfp.haberp6 != api.haberp6 || vfp.debep7 != api.debep7 || vfp.haberp7 != api.haberp7 || vfp.debep8 != api.debep8 || vfp.haberp8 != api.haberp8 || vfp.debep9 != api.debep9 || vfp.haberp9 != api.haberp9 || vfp.debep10 != api.debep10 || vfp.haberp10 != api.haberp10 || vfp.debep11 != api.debep11 || vfp.haberp11 != api.haberp11 || vfp.debep12 != api.debep12 || vfp.haberp12 != api.haberp12 select new Tuple<int, VFPMaeCue>(api.id, vfp)).ToList();
        }
        public static List<APIMaeCue> GetDeletedObjects(List<VFPMaeCue> vfpList, List<APIMaeCue> apiList)
        {
            return apiList.Where(api => !vfpList.Exists(vfp => vfp.codigo.Equals(api.codigo))).ToList();
        }
        #endregion
        #region Tabaux10
        public static List<VFPTabaux10> GetNewObjects(List<VFPTabaux10> vfpList, List<APITabaux10> apiList)
        {
            return vfpList.Where(vfp => !apiList.Exists(api => api.kod.Equals(vfp.kod))).ToList();
        }
        public static List<Tuple<int, VFPTabaux10>> GetUpdatedObjects(List<VFPTabaux10> vfpList, List<APITabaux10> apiList)
        {
            return (from vfp in vfpList from api in apiList.Where(api => api.kod.Equals(vfp.kod)) where !vfp.tipo.Equals(api.tipo) || !vfp.sucur.Equals(api.sucur) || !vfp.desc.Equals(api.desc) || vfp.orden_patr != api.orden_patr || !vfp.estado.Equals(api.estado) || !vfp.giro.Equals(api.giro) || vfp.tipo_calle != api.tipo_calle || !vfp.direccion.Equals(api.direccion) || !vfp.num.Equals(api.num) || !vfp.depto.Equals(api.depto) || !vfp.sector.Equals(api.sector) || !vfp.edificio.Equals(api.edificio) || vfp.num_piso != api.num_piso || !vfp.entre_call.Equals(api.entre_call) || !vfp.codcom.Equals(api.codcom) || !vfp.comuna.Equals(api.comuna) || !vfp.nom_region.Equals(api.nom_region) || vfp.region != api.region || !vfp.codciu.Equals(api.codciu) || !vfp.ciudad.Equals(api.ciudad) || !vfp.cod_postal.Equals(api.cod_postal) || !vfp.mail.Equals(api.mail) || !vfp.telefono.Equals(api.telefono) || !vfp.anexo.Equals(api.anexo) || !vfp.fax.Equals(api.fax) || !vfp.telefono_c.Equals(api.telefono_c) || !vfp.fax_c.Equals(api.fax_c) || !vfp.internet.Equals(api.internet) || !vfp.cod_area.Equals(api.cod_area) || !vfp.celular.Equals(api.celular) || !vfp.casilla.Equals(api.casilla) || !vfp.fecha.Equals(api.fecha) || !vfp.fpago.Equals(api.fpago) || !vfp.contacto.Equals(api.contacto) || !vfp.telconta.Equals(api.telconta) || !vfp.vendedor.Equals(api.vendedor) || !vfp.observ.Equals(api.observ) || vfp.saldoau != api.saldoau || !vfp.exporta.Equals(api.exporta) || vfp.credito != api.credito || !vfp.zona.Equals(api.zona) || !vfp.direccions.Equals(api.direccions) || !vfp.telefonos.Equals(api.telefonos) || !vfp.mails.Equals(api.mails) || !vfp.contactos.Equals(api.contactos) || !vfp.codcoms.Equals(api.codcoms) || !vfp.comunas.Equals(api.comunas) || !vfp.codcius.Equals(api.codcius) || !vfp.ciudads.Equals(api.ciudads) || vfp.concredito != api.concredito || !vfp.codpais.Equals(api.codpais) || !vfp.pais.Equals(api.pais) || !vfp.segmento.Equals(api.segmento) select new Tuple<int, VFPTabaux10>(api.id, vfp)).ToList();
        }
        public static List<APITabaux10> GetDeletedObjects(List<VFPTabaux10> vfpList, List<APITabaux10> apiList)
        {
            return apiList.Where(api => !vfpList.Exists(vfp => vfp.kod.Equals(api.kod))).ToList();
        }
        #endregion
    }
}
