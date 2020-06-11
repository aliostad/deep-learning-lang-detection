package myserver.api.modules;

import javax.annotation.Resource;

import org.springframework.stereotype.Component;

import myserver.api.modules.book.BookService;
import myserver.api.modules.user.UserService;

@Component
public class FacadeService {

	@Resource(name="userService")
	protected UserService userService;

	public UserService getUserService() {
		return userService;
	}

	public void setUserService(UserService userService) {
		this.userService = userService;
	}

	@Resource(name="bookService")
	protected BookService bookService;

	public BookService getBookService() {
		return bookService;
	}

	public void setBookService(BookService bookService) {
		this.bookService = bookService;
	}

}
