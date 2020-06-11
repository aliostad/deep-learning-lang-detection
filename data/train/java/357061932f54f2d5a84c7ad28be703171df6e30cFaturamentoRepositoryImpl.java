package br.com.consultweb.repository.servico.impl;

import javax.ejb.Stateless;

import br.com.consultweb.domain.servico.Faturamento;
import br.com.consultweb.repository.servico.spec.FaturamentoRepository;
import br.com.consultweb.repository.spec.AbstractConsultWebRepository;

@Stateless(name = "faturamentoRepository")
public class FaturamentoRepositoryImpl extends
		AbstractConsultWebRepository<Faturamento> implements
		FaturamentoRepository {

	public FaturamentoRepositoryImpl() {
		super(Faturamento.class);
	}

}
