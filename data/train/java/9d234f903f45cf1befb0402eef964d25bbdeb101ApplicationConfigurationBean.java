package br.com.vendaslim.web;

import javax.faces.bean.ApplicationScoped;
import javax.faces.bean.ManagedBean;

import br.com.vendaslim.infra.ConstantsRepository;

@ManagedBean(name="applicationConfigurationBean")
@ApplicationScoped
public class ApplicationConfigurationBean {
	private ConstantsRepository constantsRepository = new ConstantsRepository();

	public ConstantsRepository getConstantsRepository() {
		return constantsRepository;
	}

	public void setConstantsRepository(ConstantsRepository constantsRepository) {
		this.constantsRepository = constantsRepository;
	}
	
	
	
	
}
