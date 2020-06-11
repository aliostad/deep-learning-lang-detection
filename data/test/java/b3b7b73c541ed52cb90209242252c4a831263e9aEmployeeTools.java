package com.ourownjava.atg.repository;

import atg.nucleus.GenericService;
import atg.repository.Query;
import atg.repository.QueryBuilder;
import atg.repository.QueryExpression;
import atg.repository.Repository;
import atg.repository.RepositoryException;
import atg.repository.RepositoryItem;
import atg.repository.RepositoryView;

/**
 * 
 * @author ourownjava.com
 *
 */
public class EmployeeTools extends GenericService {

    private Repository repository;

    public void setRepository(Repository repository) {
        this.repository = repository;
    }

    public RepositoryItem[] findByIds(String[] ids) throws RepositoryException {

        final RepositoryView employeeView = repository.getView("EMPLOYEE");
        final QueryBuilder queryBuilder = employeeView.getQueryBuilder();
        final QueryExpression propertyExpression = queryBuilder.createPropertyQueryExpression("EMPLOYEE_ID");
        final QueryExpression valueExpression = queryBuilder.createConstantQueryExpression(ids);
        final Query employeeQuery = queryBuilder.createIncludesQuery(valueExpression, propertyExpression);
        final RepositoryItem[] repositoryItems = employeeView.executeQuery(employeeQuery);

        return repositoryItems;
    }
}
