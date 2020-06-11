package cn.javaplus.twolegs.base;

import cn.javaplus.twolegs.handlers.CommitBestScoreHandler;
import cn.javaplus.twolegs.handlers.LoginHandler;
import cn.javaplus.twolegs.handlers.OneKeyRegistHandler;
import cn.javaplus.twolegs.handlers.RankingListHandler;

public class HandlerInitor {

	public void init(GameServer s) {
		s.addHandler("login", new LoginHandler());
		s.addHandler("oneKeyRegist", new OneKeyRegistHandler());
		s.addHandler("rankingList", new RankingListHandler());
		s.addHandler("commitBestScore", new CommitBestScoreHandler());
	}

}
