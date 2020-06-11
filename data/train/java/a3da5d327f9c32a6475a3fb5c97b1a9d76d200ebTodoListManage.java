package models.manage;

import models.api.Ownerable;
import models.api.OwnerableManage;
import models.entity.TodoList;

/**
 * TodoListManage.
 *
 * @author itang
 */
public class TodoListManage extends OwnerableManage<TodoList> implements Ownerable<String> {
    public String owner;

    public TodoListManage(String owner) {
        this.owner = owner;
    }

    public String owner() {
        return this.owner;
    }

    public static TodoListManage instance(String owner) {
        return new TodoListManage(owner);
    }

    public static TodoListManage instance() {
        return new TodoListManage(null);
    }
}
