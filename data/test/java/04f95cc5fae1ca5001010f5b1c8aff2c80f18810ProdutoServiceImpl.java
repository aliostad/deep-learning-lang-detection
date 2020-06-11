package com.cooper.model.service.impl;

import com.cooper.model.repository.ProdutoRepository;
import com.cooper.model.repository.hibernate.ProdutoRepositoryHibernate;
import com.cooper.model.entity.Produto;
import com.cooper.model.service.ProdutoService;
import com.strutstool.repository.RepositoryException;
import java.util.List;

public class ProdutoServiceImpl implements ProdutoService {
    private ProdutoRepository produtoRepository;

    public ProdutoServiceImpl() {}

    public ProdutoServiceImpl(ProdutoRepository produtoRepository) {
        this.produtoRepository = produtoRepository;
    }
    
    // Implemented interface methods ===========================================

    public List<Produto> findAll() throws RepositoryException {
        return getProdutoRepository().getAll();
    }

    public Produto load(Integer id) throws RepositoryException {
        return getProdutoRepository().load(id);
    }

    public List<Produto> searchProdutos(String searchString) throws RepositoryException {
        return getProdutoRepository().searchProdutos(searchString);
    }

    // Getters and Setters =====================================================

    protected ProdutoRepository getProdutoRepository() {
        if (produtoRepository == null) {
            produtoRepository = new ProdutoRepositoryHibernate();
        }

        return produtoRepository;
    }
}
