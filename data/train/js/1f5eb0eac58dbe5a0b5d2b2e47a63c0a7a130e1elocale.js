var operaI18N = {
	getMessage : function (key) {
		var value = '';
		if (localeMessage[key]) {
			value = localeMessage[key].message;
		}
		return value;
	}
}

var localeMessage = {
	"AuthenticationFailure": {
		"message": "在你剪辑该页面之前，请先点击保存到wiz工具栏按钮登陆"
	},
	"Completed": {
		"message": "已完成"
	},
	"DeletedItems": {
		"message": "已删除"
	},
	"Inbox": {
		"message": "收集箱"
	},
	"MyContacts": {
		"message": "我的联系人"
	},
	"MyDrafts": {
		"message": "我的草稿"
	},
	"MyEmails": {
		"message": "我的邮件"
	},
	"MyEvents": {
		"message": "我的事件"
	},
	"MyJournals": {
		"message": "我的日记"
	},
	"MyMobiles": {
		"message": "我的手机"
	},
	"MyNotes": {
		"message": "我的笔记"
	},
	"MyPhotos": {
		"message": "我的照片"
	},
	"MyStickyNotes": {
		"message": "我的桌面便笺"
	},
	"MyTasks": {
		"message": "我的任务"
	},
	"actionName": {
		"message": "为知笔记网页剪辑器"
	},
	"add_comment": {
		"message": "添加评论"
	},
	"add_tag": {
		"message": "输入标签"
	},
	"article_save": {
		"message": "保存文章"
	},
	"category_loading": {
		"message": "加载中，请稍后"
	},
	"category_tip": {
		"message": "文件夹: "
	},
	"clipResult_clipping": {
		"message": "正在剪辑"
	},
	"clipResult_error": {
		"message": "保存失败"
	},
	"clipResult_success": {
		"message": "已剪辑"
	},
	"clipResult_sync": {
		"message": "正在同步"
	},
	"comment_tip": {
		"message": "评论: "
	},
	"contentPreview_clipArticle": {
		"message": "剪辑文章"
	},
	"contentPreview_expandSelection": {
		"message": "扩大选取区域"
	},
	"contentPreview_moveSelection": {
		"message": "移动选取区域"
	},
	"contentPreview_shrinkSelection": {
		"message": "缩小选取区域"
	},
	"contextMenus_clipPage": {
		"message": "保存到为知笔记"
	},
	"contextMenus_clipSelection": {
		"message": "剪辑选择"
	},
	"contextMenus_clipUrl": {
		"message": "剪辑 URL"
	},
	"create_account_link": {
		"message": "创建为知笔记账号"
	},
	"description": {
		"message": "使用“为知笔记”扩展程序，将网络上你需要的内容与网页保存到你自己的帐户"
	},
	"extName": {
		"message": "为知笔记网页剪辑器"
	},
	"fullpage_save": {
		"message": "保存整页"
	},
	"install_client_notify": {
		"message": "该功能需要安装最新版的wiz客户端，是否跳转到下载页面?"
	},
	"keep_password_tip": {
		"message": "记住密码"
	},
	"login_msg": {
		"message": "   登录   "
	},
	"logining": {
		"message": "正在登录"
	},
	"logout": {
		"message": "注销"
	},
	"network_wrong": {
		"message": "网络不可用，请检查后重试"
	},
	"note_submit": {
		"message": "   保存   "
	},
	"note_title_tip": {
		"message": "标题: "
	},
	"pageClipFailure": {
		"message": "无法剪辑该页面"
	},
	"password_error": {
		"message": "密码错误"
	},
	"password_tip": {
		"message": "密码: "
	},
	"popup_wating": {
		"message": "等待页面..."
	},
	"retry_clip_button": {
		"message": "重试"
	},
	"save_more": {
		"message": "更多"
	},
	"save_to_native": {
		"message": "保存到本地"
	},
	"save_to_server": {
		"message": "保存到云端(服务器)"
	},
	"select_save": {
		"message": "保存选择"
	},
	"tag_input": {
		"message": "输入标签: "
	},
	"tag_tip": {
		"message": "标签: "
	},
	"url_save": {
		"message": "保存URL"
	},
	"user_id_help": {
		"message": "(Email或手机号)"
	},
	"user_id_tip": {
		"message": "账号: "
	},
	"userid_error": {
		"message": "用户名输入错误"
	}
}