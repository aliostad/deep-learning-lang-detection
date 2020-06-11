/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao;


import java.util.List;
import model.Repository;

/**
 *
 * @author Maria Magdalena Cabrera Coronilla magdacc05@gmail.com
 */
public interface RepositoryDao {
    void insertarRepository(Repository repository);
    void eliminarRepository(int key);
    void modificarRepository(Repository repository);
    List<Repository> desplegarRepositories();
    Repository elegirRepository(int key);
    
}
