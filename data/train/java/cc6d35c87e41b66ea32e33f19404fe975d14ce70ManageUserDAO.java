package edu.neu.cs5200.project.orm.dao;

import java.util.Date;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.persistence.Query;

import edu.neu.cs5200.project.orm.models.ManageUser;

public class ManageUserDAO {
	
	EntityManagerFactory factory = Persistence.createEntityManagerFactory("GOATrip");
	EntityManager em = factory.createEntityManager();
	
	// crud
	
	// createManageUser
	public ManageUser createManageUser(ManageUser manageUser) {
		em.getTransaction().begin();
		em.persist(manageUser);
		em.getTransaction().commit();
		return manageUser;
	}
	
	// findManageUserById
	public ManageUser findManageUserById(Integer id)
	{
		return em.find(ManageUser.class, id); 
	}
	
	// findAllManageUsers
	public List<ManageUser> findAllManageUsers()
	{
		Query query = em.createQuery("select manageUser from ManageUser manageUser");
		return (List<ManageUser>)query.getResultList();
	}
	// updateManageUser
	public ManageUser updateManageUser(ManageUser manageUser)
	{
		em.getTransaction().begin();
		em.merge(manageUser);
		em.getTransaction().commit();
		return manageUser;
	}
	// deleteManageUser
	public void deleteManageUser(int id) {
		em.getTransaction().begin();
		ManageUser manageUser = em.find(ManageUser.class, id);
		em.remove(manageUser);
		em.getTransaction().commit();
	}

	public static void main(String[] args) {
		ManageUserDAO dao = new ManageUserDAO();
		
		//	createManageUser test
//		ManageUser manageUser = new ManageUser(null, "manage", new Date());
//		dao.createManageUser(manageUser);
		
		//	findManageUserById test
//		ManageUser manageUser = dao.findManageUserById(1);
//		System.out.println(manageUser.getContent());
		
		// findAllManageUsers test
//		List<ManageUser> manageUsers = dao.findAllManageUsers();
//		for(ManageUser manageUser : manageUsers)
//		{
//			System.out.println(manageUser.getContent());
//		}
		
		// updateManageUser test
//		ManageUser check = dao.findManageUserById(1);
//		check.setContent("check");
//		System.out.println(dao.updateManageUser(check).getContent());
		
		// deleteManageUser test
//		dao.deleteManageUser(1);
		
	}

}
