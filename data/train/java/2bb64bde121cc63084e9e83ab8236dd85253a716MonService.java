package com.m2i.formation.element.service;

import com.m2i.formation.element.entities.Semiconductor;
import com.m2i.formation.element.repositorys.ElementChimiRepository;
import com.m2i.formation.element.repositorys.SemiconducorRepository;

public class MonService implements Iservice {

	private ElementChimiRepository ElementChimiRepository;
	private SemiconducorRepository SemiconducorRepository;

	public ElementChimiRepository getElementChimiRepository() {
		return ElementChimiRepository;
	}

	public void setElementChimiRepository(ElementChimiRepository elementChimiRepository) {
		ElementChimiRepository = elementChimiRepository;
	}

	public SemiconducorRepository getSemiconducorRepository() {
		return SemiconducorRepository;
	}

	public void setSemiconducorRepository(SemiconducorRepository semiconducorRepository) {
		SemiconducorRepository = semiconducorRepository;
	}

	@Override
	public void addSemiconductorToElementchimi(Semiconductor a, int ElementId) {

	}

}
