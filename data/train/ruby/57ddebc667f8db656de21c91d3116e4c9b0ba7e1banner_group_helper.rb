#encoding: utf-8
module Manage::BannerGroupHelper

	def link_banner_show(page_name, position)
		link = case page_name
      when '首页'
      	"/manage/banner_home?position=#{position}&page_name=#{page_name}"
      when /图库首页|图库列表页|图库内页|图库专题导购/
      	"/manage/banner_images?position=#{position}&page_name=#{page_name}"
      when /刷新实录|刷新实录视频页|刷新生活精彩资讯|刷新效果|刷新服务/
        "/manage/banner_refresh?position=#{position}&page_name=#{page_name}"
      when /设计快查|装修贴士|装修咨询/
        "/manage/banner_channel?position=#{position}&page_name=#{page_name}"
      else
      	"/manage/banner_group"
    end
    link
	end
end
