package com.cooper.model.repository;

import com.cooper.model.entity.Orcamento;
import com.cooper.model.entity.Usuario;
import com.strutstool.repository.LookupRepository;
import com.strutstool.repository.RepositoryException;
import java.util.List;

public interface OrcamentoRepository extends LookupRepository<Orcamento, Integer>  {
    public List<Orcamento> findAllByUsuario(Usuario usuario) throws RepositoryException;
    public Integer getTotalOrcamentosPendentes() throws RepositoryException;
}
