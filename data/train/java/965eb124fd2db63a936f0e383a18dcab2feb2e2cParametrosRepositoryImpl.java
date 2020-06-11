package br.com.consultweb.repository.parametros.impl;

import javax.ejb.Stateless;

import br.com.consultweb.domain.parametros.Parametros;
import br.com.consultweb.repository.parametros.spec.ParametrosRepository;
import br.com.consultweb.repository.spec.AbstractConsultWebRepository;

@Stateless(name = "parametrosRepository")
public class ParametrosRepositoryImpl extends AbstractConsultWebRepository<Parametros> implements
		ParametrosRepository {

    public ParametrosRepositoryImpl() {
    	super(Parametros.class);
    }

}
