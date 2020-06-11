package com.springapp.mvc.repository.dao;

import com.springapp.mvc.model.Task;
import com.springapp.mvc.repository.RepositoryQualifer;
import com.springapp.mvc.repository.RepositoryType;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;

/**
 * Author: Daniel
 */
@Repository
@RepositoryQualifer(repositoryType = RepositoryType.JPA)
public class TaskRepository implements ITaskRepository {
    public void saveTask(Task task) {

    }

    public List<Task> findAllTasks() {
        return new ArrayList<Task>();

    }
}
