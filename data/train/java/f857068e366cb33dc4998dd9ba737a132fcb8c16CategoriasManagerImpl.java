package com.mawape.aimant.services.impl;

import java.util.List;

import android.content.Context;

import com.mawape.aimant.entities.Categoria;
import com.mawape.aimant.repository.CategoriasRepository;
import com.mawape.aimant.repository.impl.CategoriasRepositoryJSONImpl;
import com.mawape.aimant.services.CategoriasManager;

public class CategoriasManagerImpl implements CategoriasManager {

	private CategoriasRepository categoriasRepository;

	public CategoriasManagerImpl(Context context) {
		this.categoriasRepository = new CategoriasRepositoryJSONImpl(context);
	}

	@Override
	public List<Categoria> getCategorias() {
		return getCategoriasRepository().getCategorias();
	}

	public CategoriasRepository getCategoriasRepository() {
		return categoriasRepository;
	}

	public void setCategoriasRepository(
			CategoriasRepository categoriasRepository) {
		this.categoriasRepository = categoriasRepository;
	}
}
