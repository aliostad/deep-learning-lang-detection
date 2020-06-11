package com.foodtrip.ftmodeldb;

import org.neo4j.graphdb.GraphDatabaseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.neo4j.config.EnableNeo4jRepositories;
import org.springframework.data.neo4j.config.Neo4jConfiguration;
import org.springframework.data.neo4j.support.Neo4jTemplate;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import com.foodtrip.ftmodeldb.repo.CityRepository;
import com.foodtrip.ftmodeldb.repo.CompanyRepository;
import com.foodtrip.ftmodeldb.repo.FarmRepository;
import com.foodtrip.ftmodeldb.repo.NotificationRepository;
import com.foodtrip.ftmodeldb.repo.OrderRepository;
import com.foodtrip.ftmodeldb.repo.PersonRepository;
import com.foodtrip.ftmodeldb.repo.ProductRepository;
import com.foodtrip.ftmodeldb.repo.StepRepository;


@EnableTransactionManagement
@Configuration
@EnableNeo4jRepositories(basePackages="com.foodtrip.ftmodeldb.repo")
public class Neo4JConnector extends Neo4jConfiguration {
	public Neo4JConnector()
	{
		setBasePackage("com.foodtrip");
	}

	@Autowired private Neo4jTemplate template;

	@Autowired PersonRepository personRepository;
	@Autowired CityRepository cityRepository;
	@Autowired OrderRepository orderRepository;
	@Autowired ProductRepository productRepository;
	@Autowired FarmRepository farmRepository;
	@Autowired StepRepository stepRepository;
	@Autowired NotificationRepository notificationRepository;
	
	public NotificationRepository getNotificationRepository() {
		return notificationRepository;
	}


	public void setNotificationRepository(
			NotificationRepository notificationRepository) {
		this.notificationRepository = notificationRepository;
	}


	public PersonRepository getPersonRepository() {
		return personRepository;
	}


	public void setPersonRepository(PersonRepository personRepository) {
		this.personRepository = personRepository;
	}


	public CityRepository getCityRepository() {
		return cityRepository;
	}


	public void setCityRepository(CityRepository cityRepository) {
		this.cityRepository = cityRepository;
	}


	public OrderRepository getOrderRepository() {
		return orderRepository;
	}


	public void setOrderRepository(OrderRepository orderRepository) {
		this.orderRepository = orderRepository;
	}


	public ProductRepository getProductRepository() {
		return productRepository;
	}


	public void setProductRepository(ProductRepository productRepository) {
		this.productRepository = productRepository;
	}


	public FarmRepository getFarmRepository() {
		return farmRepository;
	}

	public StepRepository getStepRepository() {
		return stepRepository;
	}


	public void setFarmRepository(FarmRepository farmRepository) {
		this.farmRepository = farmRepository;
	}

	@Autowired 
	private CompanyRepository companyRepository;
	
	public CompanyRepository getCompanyRepository() {
		return companyRepository;
	}


	public void setCompanyRepository(CompanyRepository companyRepository) {
		this.companyRepository = companyRepository;
	}


	
	@Bean
	public GraphDatabaseService graphDatabaseService() {
		return template.getGraphDatabaseService();
	}
	

	public Neo4jTemplate getTemplate() {
		return template;
	}


	public void setTemplate(Neo4jTemplate template) {
		this.template = template;
	}	
}
