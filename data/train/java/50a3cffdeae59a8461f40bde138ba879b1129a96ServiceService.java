/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package yakhospital.service;

import yakhospital.hibernate.Lit;
import yakhospital.hibernate.Service;
import yakhospital.hibernate.Titulaire;
import yakhospital.hibernate.dao.impl.LitDAOImpl;
import yakhospital.hibernate.dao.impl.ServiceDAOImpl;
import yakhospital.hibernate.dao.impl.TitulaireDAOImpl;



/**
 *
 * @author Morgane
 */
public class ServiceService {
    
    public static Integer creerService (String nom_service) {
        Service service = new Service (nom_service);
        return ServiceDAOImpl.getInstance().save(service);
        
    }
    public static Boolean modifierService (Service service, String nom_service) {
        service.setNom_service(nom_service);
        return ServiceDAOImpl.getInstance().update(service);
    }
    public static Boolean modifierService (Integer id_service, String nom_service) {
        Service s = ServiceDAOImpl.getInstance().get(id_service);
        s.setNom_service(nom_service);
        return ServiceDAOImpl.getInstance().update(s);
    }
    public static Boolean supprimerService (Service service) {
        return ServiceDAOImpl.getInstance().delete(service.getId_service());
    }
    public static Boolean supprimerService (Integer id_service) {
        return ServiceDAOImpl.getInstance().delete(id_service);
    }
    public static Boolean ajouterTitulaire (Titulaire titulaire, Service service) {
        titulaire.setService(service);
        service.ajouterTitulaire(titulaire);
        return ServiceDAOImpl.getInstance().update(service);
    }
        public static Boolean ajouterTitulaire (Integer id_titulaire, Service service) {
        Titulaire t = TitulaireDAOImpl.getInstance().get(id_titulaire);
        t.setService(service);
        service.ajouterTitulaire(t);
        return ServiceDAOImpl.getInstance().update(service);
    }
    public static Boolean ajouterLit (Lit lit, Service service) {
       lit.setService(service);
       service.ajouterLit(lit);
       return ServiceDAOImpl.getInstance().update(service);
    }
    public static Boolean ajouterLit (Integer id_lit, Service service) {
       Lit lit = LitDAOImpl.getInstance().get(id_lit);
       lit.setService(service);
       service.ajouterLit(lit);
       return ServiceDAOImpl.getInstance().update(service);
    }
    public static Boolean ajouterServiceComp (Service serviceComp, Service service) {
        service.ajouterServiceComp(serviceComp);
        return ServiceDAOImpl.getInstance().update(service);
    }
    public static Boolean ajouterServiceComp (Integer id_serviceComp, Service service) {
        Service serviceComp = ServiceDAOImpl.getInstance().get(id_serviceComp);
        service.ajouterServiceComp(serviceComp);
        return ServiceDAOImpl.getInstance().update(service);
    }
}
