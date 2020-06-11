package controller;

import java.util.List;

import model.Recepteur;
import service.RecepteurService;
import service.ServiceService;
import service.ServiceServiceImpl;

public class RecepteurBean {

	RecepteurService recepteurService;
	ServiceService serSevice = new ServiceServiceImpl();
	Recepteur recepteur = new Recepteur();
	List<Recepteur> recepteurs;
	Integer service;

	public Integer getService() {
		return service;
	}

	public void setService(Integer service) {
		this.service = service;
	}

	public RecepteurService getRecepteurService() {
		return recepteurService;
	}

	public void setRecepteurService(RecepteurService recepteurService) {
		this.recepteurService = recepteurService;
	}

	public Recepteur getRecepteur() {
		return recepteur;
	}

	public void setRecepteur(Recepteur recepteur) {
		this.recepteur = recepteur;
	}

	public List<Recepteur> getRecepteurs() {
		recepteurs = recepteurService.getAll();
		return recepteurs;
	}

	public void setRecepteurs(List<Recepteur> recepteurs) {
		this.recepteurs = recepteurs;
	}

	public void add(Recepteur rec) {
		rec.setService(serSevice.getById(service));
		recepteurService.add(rec);
	}

	public void delete(int id) {
		recepteurService.delete(id);
	}

}
