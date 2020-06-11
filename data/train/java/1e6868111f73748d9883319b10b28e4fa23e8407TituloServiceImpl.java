package com.cooper.model.service.impl;

import com.cooper.model.repository.TituloRepository;
import com.cooper.model.repository.hibernate.TituloRepositoryHibernate;
import com.cooper.model.entity.Titulo;
import com.cooper.model.entity.Usuario;
import com.cooper.model.repository.UsuarioRepository;
import com.cooper.model.repository.hibernate.UsuarioRepositoryHibernate;
import com.cooper.model.service.TituloService;
import com.strutstool.repository.RepositoryException;
import com.strutstool.validator.Validator;
import com.strutstool.validator.ValidatorException;
import java.util.List;

public class TituloServiceImpl implements TituloService {
    private TituloRepository tituloRepository;
    private UsuarioRepository usuarioRepository;

    public TituloServiceImpl() {}

    public TituloServiceImpl(TituloRepository tituloRepository) {
        this.tituloRepository = tituloRepository;
    }
    
    // Implemented interface methods ===========================================

    public List<Titulo> findAllByUsuario(String id) throws RepositoryException {
        Usuario usuario = getUsuarioRepository().get(id);
        return getTituloRepository().findAllByUsuario(usuario);
    }

    public double getTotalTitulosByUsuario(String id) throws RepositoryException {
         Usuario usuario = getUsuarioRepository().get(id);
        return getTituloRepository().getTotalTitulosByUsuario(usuario);
    }

    // Getters and Setters =====================================================

    protected TituloRepository getTituloRepository() {
        if (tituloRepository == null) {
            tituloRepository = new TituloRepositoryHibernate();
        }

        return tituloRepository;
    }

    protected UsuarioRepository getUsuarioRepository() {
        if (usuarioRepository == null) {
            usuarioRepository = new UsuarioRepositoryHibernate();
        }
        return usuarioRepository;
    }
}
