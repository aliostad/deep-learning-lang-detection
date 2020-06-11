package utils

import (
	_ "fmt"
	_ "math/rand"
	_ "strings"
)

func GetNeedsStatus(status int) string {
	var txt string
	switch status {
	case 1:
		txt = "草稿"
	case 2:
		txt = "激活"
	case 3:
		txt = "已变更"
	case 4:
		txt = "待关闭"
	case 5:
		txt = "已关闭"
	}
	return txt
}

func GetNeedsSource(source int) string {
	var txt string
	switch source {
	case 1:
		txt = "用户"
	case 2:
		txt = "售后技术服务"
	case 3:
		txt = "销售"
	case 4:
		txt = "运维"
	case 5:
		txt = "研发"
	case 6:
		txt = "其他"
	}
	return txt
}

func GetNeedStage(stage int) string {
	var txt string
	switch stage {
	case 1:
		txt = "未开始"
	case 2:
		txt = "已计划"
	case 3:
		txt = "方案设计"
	case 4:
		txt = "方案确认"
	case 5:
		txt = "项目开始"
	case 6:
		txt = "项目测试"
	case 7:
		txt = "项目测试完毕"
	case 8:
		txt = "项目已验收"
	case 9:
		txt = "项目已完成"
	case 10:
		txt = "项目售中"
	case 11:
		txt = "项目售后"
	}
	return txt
}

func GetTestStatus(status int) string {
	var txt string
	switch status {
	case 1:
		txt = "设计如此"
	case 2:
		txt = "重复问题"
	case 3:
		txt = "外部原因"
	case 4:
		txt = "已解决"
	case 5:
		txt = "无法重现"
	case 6:
		txt = "延期处理"
	case 7:
		txt = "不予解决"
	}
	return txt
}

func GetOs(os string) string {
	var txt string
	switch os {
	case "all":
		txt = "全部"
	case "windows":
		txt = "windows"
	case "win8":
		txt = "Windows 8"
	case "vista":
		txt = "Windows Vista"
	case "win7":
		txt = "Windows 7"
	case "winxp":
		txt = "Windows XP"
	case "win2012":
		txt = "Windows 2012"
	case "win2008":
		txt = "Windows 2008"
	case "win2003":
		txt = "Windows 2003"
	case "win2000":
		txt = "Windows 2000"
	case "android":
		txt = "Android"
	case "ios":
		txt = "IOS"
	case "wp8":
		txt = "WP8"
	case "wp7":
		txt = "WP7"
	case "symbian":
		txt = "Symbian"
	case "linux":
		txt = "Linux"
	case "freebsd":
		txt = "FreeBSD"
	case "osx":
		txt = "OS X"
	case "unix":
		txt = "Unix"
	case "other":
		txt = "其他"
	}
	return txt
}

func GetBrowser(browser string) string {
	var txt string
	switch browser {
	case "all":
		txt = "全部"
	case "ie":
		txt = "IE系列"
	case "ie11":
		txt = "IE11"
	case "ie10":
		txt = "IE10"
	case "ie9":
		txt = "IE9"
	case "ie8":
		txt = "IE8"
	case "ie7":
		txt = "IE7"
	case "ie6":
		txt = "IE6"
	case "chrome":
		txt = "chrome"
	case "firefox":
		txt = "firefox"
	case "opera":
		txt = "opera"
	case "safari":
		txt = "safari"
	case "maxthon":
		txt = "傲游"
	case "uc":
		txt = "UC"
	case "other":
		txt = "其他"
	}
	return txt
}
