package ClientRunner;

import Book.BookService;
import Member.MemberService;
import Promotion.PromotionService;
import RMI.UserAgent;
import Sale.SaleService;
import User.UserService;

public class Agent {
	public static BookService bookService;
	public static MemberService memberService;
	public static PromotionService promotionService;
	public static SaleService saleService;
	public static UserService userService;
	public static UserAgent userAgent;

//	public Agent(BookService bookService, MemberService memberService,
//			PromotionService promotionService, SaleService saleService,
//			UserService userService) {
//		Agent.bookService = bookService;
//		Agent.memberService = memberService;
//		Agent.promotionService = promotionService;
//		Agent.saleService = saleService;
//		Agent.userService = userService;
//	}
}
