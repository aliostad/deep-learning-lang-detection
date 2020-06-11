package ar.com.spsolutions.splibrary.services;

import java.io.Serializable;

import ar.com.spsolutions.splibrary.entity.Entity;

public class EntityService extends TemplateEntityService<Entity> implements
		Serializable {

	private static final long serialVersionUID = 1482098001518685537L;
	private AuthorService authorService;
	private UserService userService;
	private BookService bookService;
	private RoleService roleService;
	private CategoryService categoryService;
	private LoanBookService loanBookService;

	public UserService getUserService() {
		return this.userService;
	}

	public void setUserService(final UserService userService) {
		this.userService = userService;
	}

	public BookService getBookService() {
		return this.bookService;
	}

	public void setBookService(final BookService bookService) {
		this.bookService = bookService;
	}

	public RoleService getRoleService() {
		return this.roleService;
	}

	public void setRoleService(final RoleService roleService) {
		this.roleService = roleService;
	}

	public CategoryService getCategoryService() {
		return this.categoryService;
	}

	public void setCategoryService(final CategoryService categoryService) {
		this.categoryService = categoryService;
	}

	public AuthorService getAuthorService() {
		return this.authorService;
	}

	public void setAuthorService(final AuthorService authorService) {
		this.authorService = authorService;
	}

	public LoanBookService getLoanBookService() {
		return this.loanBookService;
	}

	public void setLoanBookService(final LoanBookService loanBookService) {
		this.loanBookService = loanBookService;
	}

}
