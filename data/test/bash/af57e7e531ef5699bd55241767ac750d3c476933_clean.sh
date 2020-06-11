#!/bin/sh


function append_config_xml() {
    echo "$1" >> ${CWD}/_config.yml
}


CWD=$(cd `dirname $0` && pwd )
SPACE="    "

echo "" > "${CWD}/_config.yml"
# 删除 _posts/*
rm -rf  ${CWD}/_posts/*

# 删除无用的配置选项
append_config_xml "comments:"
append_config_xml "${SPACE}provide: duoshuo"
append_config_xml "${SPACE}duoshuo:"
append_config_xml "${SPACE}${SPACE}short_name: 请到多说网站申请"
append_config_xml "title: 你的网站名称"
append_config_xml "safe: false"
append_config_xml "highlighter: pygments"
append_config_xml "site_domain: 网站地址"
append_config_xml "author: IntoHole"
append_config_xml "code_type: manni #代码类型"
append_config_xml "page_limit:10 #每个子tab显示内容条数"
append_config_xml "indexs:"
append_config_xml " - site: 首页"
append_config_xml "   url: index.html" 
append_config_xml " - site: 测试"
append_config_xml "   url: test.html"
append_config_xml "   tag: test"
append_config_xml "page_404:"
append_config_xml " refresh_time: 7"
append_config_xml " btns:"
append_config_xml "   - info: 看看我的Github"
append_config_xml "     url: https://github.com/xxxx"
append_config_xml "   - info: 看看首页"
append_config_xml "     url: /index.html"
append_config_xml ""
append_config_xml "resume:"
append_config_xml " Desc:"
append_config_xml "   - info: \" 介绍信息 \""
append_config_xml ""
append_config_xml " Jobs:"
append_config_xml "   -"
append_config_xml "     type: Github"
append_config_xml "     name: xxxxxx" 
append_config_xml "     url: https://github.com/xxxxx"
append_config_xml "   -" 
append_config_xml "     type: Weibo"
append_config_xml "     name: xxxxxxx" 
append_config_xml "     url: http://weibo.com/1152049780"



echo "xxxxxx" > ${CWD}/CNAME
