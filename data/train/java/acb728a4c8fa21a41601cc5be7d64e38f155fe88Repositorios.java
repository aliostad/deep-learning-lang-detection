/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.josan.util;

import com.josan.repository.ClientesRepository;
import com.josan.repository.EncomendaRepository;
import com.josan.repository.ProdutoRepository;
import com.josan.repository.infra.ClientesRepositoryHibernate;
import com.josan.repository.infra.EncomendaRepositoryHibernate;
import com.josan.repository.infra.ProdutoRepositoryHibernate;


public class Repositorios {
    public ProdutoRepository deProduto(){
        return new ProdutoRepositoryHibernate();
    }
    
    public ClientesRepository deCliente(){
        return new ClientesRepositoryHibernate();
    }
    
    public EncomendaRepository deEncomenda(){
        return new EncomendaRepositoryHibernate();
    }
}
