package net.guoquan.network.chat.chatRoom.server.service;

public class Services {
	public static Service getByeService(){
		return ByeService.getInstance();
	}
	public static Service getHelloService(){
		return HelloService.getInstance();
	}
	public static Service getLoginService(){
		return LoginService.getInstance();
	}
	public static Service getGetUsersService(){
		return UserListService.getInstance();
	}
	public static Service getPostService(){
		return PostService.getInstance();
	}
	public static Service getNewsService(){
		return NewsService.getInstance();
	}
}
