var nav ="";
nav += '<link href="http://image.91wan.com/cssCommon/Navigation_new.css?20130606" rel="stylesheet" type="text/css" />';
nav += '<div class="nav_header">';
nav += '<div class="nav_dh1 zz_nav">';
nav += '<div class="fl"><a href="http://www.91wan.com/"><img src="http://image.91wan.com/imgCommon/Navigation/logo.jpg" alt="91wan网页游戏" width="88" height="35"/></a></div>';
nav += '<div class="nav_dh11 fl"><span class="nav_zhs_col1"><strong>推荐游戏：</strong></span>';
nav += '<a href="http://qh.91wan.com/" target="_blank">枪魂</a>&nbsp;|&nbsp;<a href="http://www.91wan.com/jjsg/" target="_blank">街机三国</a>&nbsp;|&nbsp;<a href="http://sgh.91wan.com/" target="_blank">三国魂</a>&nbsp;|&nbsp;<a href="http://wy.91wan.com/" target="_blank">武易</a>&nbsp;|&nbsp<a href="http://xblcx.91wan.com/" target="_blank">新百炼成仙</a>';
nav += '</div>';
nav += '<div class="nav_dh12 fr">';
/*
nav += '<p><a href="http://www.91wan.com/" target="_blank">91wan网页游戏</a>&nbsp;| &nbsp;</p>';
nav += '<p><a href="http://www.91wan.com/user/reg.php" target="_blank">注册</a>&nbsp;| &nbsp;</p>';
nav += '<p><a href="http://www.91wan.com/user/login.php" target="_blank">登录</a>&nbsp; | &nbsp;</p>';
nav += '<p><a href="http://my.91wan.com/" target="_blank">个人中心</a>&nbsp;| &nbsp;</p>';
*/
nav += '<p><a href="http://www.91wan.com/huodong/bind_phone/" target="_blank"><img src="http://image.91wan.com/imgCommon/Navigation/t_ad1.jpg" alt="安全认证" width="230" height="35"/></a></p>';
nav += '<p onmouseout="$(\'#topWX\').hide();" onmouseover="$(\'#topWX\').show();$(\'#topWX\').css({left:$(this).offset().left-4});" class="nav_zhs_col1" style="margin-left:32px;_margin-left:28px;"><b class="icon"></b><a class="green" target="_blank" href="http://www.91wan.com/huodong/91weixin/">官方微信</a><b>|</b></p>';
nav += '<p class="nav_zhs_col1"><a href="http://pay.91wan.com/" target="_blank">账号充值</a>&nbsp;&nbsp;&nbsp;</p>';
nav += '<a onmouseover="showAllGame();" onmouseout="hiddenAllGame();" style="text-decoration:none !important;"><div class="nav_yx_2918 fl cur" style="color:#000000 !important;">91wan所有游戏 </div></a>';
nav += '</div>';
nav += '</div>';
nav += '</div>';

nav += '<div id="topWX"></div>';

nav += '<div class="allgame_91wan" style="width:980px; margin:0 auto; z-index:100000000;  position:relative; " onmouseover="showAllGame();" onmouseout="hiddenAllGame();">';
nav += '<div class="nav_yer_1">';
nav += '<div class="nav_navBox" style="display:none;" id="all_game">';
nav += '<div class="nav_nav">';
nav += '<h2>欢迎来到91wan，现在就开始您的游戏之旅吧!</h2>';
nav += '<div class="nav_lst nav_clear">';

nav += '<a target="_blank" class="nav_lnk nav_apic" href="http://qh.91wan.com/" style="color:red;">枪魂</a>';
nav += '<a target="_blank" class="nav_lnk nav_apic" href="http://qjsh.91wan.com/" style="color:red;">奇迹神话</a>';
nav += '<a target="_blank" class="nav_lnk nav_apic" href="http://www.91wan.com/jjsg/" style="color:red;">街机三国</a>';
nav += '<a target="_blank" class="nav_lnk nav_apic" href="http://www.91wan.com/dpqk/" style="color:red;">斗破乾坤</a>';
nav += '<a target="_blank" class="nav_lnk nav_apic" href="http://sgh.91wan.com/" style="color:red;">三国魂</a>';

nav += '<a target="_blank" class="nav_lnk nav_apic" href="http://wy.91wan.com/">武易</a>';
nav += '<a target="_blank" class="nav_lnk nav_apic" href="http://www.91wan.com/zxy/">醉西游</a>';
nav += '<a target="_blank" class="nav_lnk nav_apic" href="http://frxz2.91wan.com/">凡人修真2</a>';
nav += '<a target="_blank" class="nav_lnk nav_apic" href="http://kt.91wan.com/">开天辟地2</a>';
nav += '<a target="_blank" class="nav_lnk nav_apic" href="http://xblcx.91wan.com/">新百炼成仙</a>';

nav += '<a target="_blank" class="nav_lnk nav_apic" href="http://www.91wan.com/zjcq/">战将风云</a>';
nav += '<a target="_blank" class="nav_lnk nav_apic" href="http://sq.91wan.com/">神曲</a>';
nav += '<a target="_blank" class="nav_lnk nav_apic" href="http://www.91wan.com/by/">霸域</a>';
nav += '<a target="_blank" class="nav_lnk nav_apic" href="http://qisha.91wan.com/">七杀</a>';
nav += '<a target="_blank" class="nav_lnk nav_apic" href="http://cycs.91wan.com/">赤月传说</a>';

nav += '<a target="_blank" class="nav_lnk nav_apic" href="http://www.91wan.com/rxsg/">热血三国</a>';
nav += '<a target="_blank" class="nav_lnk nav_apic" href="http://www.91wan.com/hzw/">热血海贼王</a>';
nav += '<a target="_blank" class="nav_lnk nav_apic" href="http://ahtl.91wan.com/">暗黑屠龙</a>';
nav += '<a target="_blank" class="nav_lnk nav_apic" href="http://zxj.91wan.com/">战仙剑</a>';
nav += '<a target="_blank" class="nav_lnk nav_apic" href="http://www.91wan.com/yxyz/">英雄远征</a>';

nav += '<a target="_blank" class="nav_lnk nav_apic" href="http://www.91wan.com/mccq/">明朝传奇</a>';
nav += '<a target="_blank" class="nav_lnk nav_apic" href="http://yxsd.91wan.com/">英雄神殿</a>';
nav += '<a target="_blank" class="nav_lnk nav_apic" href="http://rxms.91wan.com/">热血魔兽</a>';
nav += '<a target="_blank" class="nav_lnk nav_apic" href="http://tcym.91wan.com/">天才樱木来了</a>';
nav += '<a target="_blank" class="nav_lnk nav_apic" href="http://sg2.91wan.com/">热血三国2</a>';

nav += '<a target="_blank" class="nav_lnk nav_apic" href="http://hhzq.91wan.com/">辉煌足球</a>';
nav += '<a target="_blank" class="nav_lnk nav_apic" href="http://gcld.91wan.com/">攻城掠地</a>';
nav += '<a target="_blank" class="nav_lnk nav_apic" href="http://ns.91wan.com/">女神领域</a>';
nav += '<a target="_blank" class="nav_lnk nav_apic" href="http://mhfx.91wan.com/">梦幻飞仙</a>';
nav += '<a target="_blank" class="nav_lnk nav_apic" href="http://www.91wan.com/lhzs/">烈火战神</a>';

nav += '<a target="_blank" class="nav_lnk nav_apic" href="http://www.91wan.com/smzt/">神魔遮天</a>';
nav += '<a target="_blank" class="nav_lnk nav_apic" href="http://www.91wan.com/ds/">斗圣</a>';
nav += '<a target="_blank" class="nav_lnk nav_apic" href="http://qjlq.91wan.com/">奇迹篮球</a>';
nav += '<a target="_blank" class="nav_lnk nav_apic" href="http://sskc.91wan.com/">死神狂潮</a>';
nav += '<a target="_blank" class="nav_lnk nav_apic" href="http://www.91wan.com/gjqx/">古剑奇侠</a>';

nav += '<a target="_blank" class="nav_lnk nav_apic" href="http://www.91wan.com/sjsg/">神将三国</a>';
nav += '<a target="_blank" class="nav_lnk nav_apic" href="http://mhxx.91wan.com/">梦幻修仙</a>';
nav += '<a target="_blank" class="nav_lnk nav_apic" href="http://sgmj.91wan.com/">三国名将</a>';
nav += '<a target="_blank" class="nav_lnk nav_apic" href="http://www.91wan.com/rxlq/">热血篮球</a>';
nav += '<a target="_blank" class="nav_lnk nav_apic" href="http://www.91wan.com/game/">更多</a>';

nav += '</div>';
nav += '</div>';
nav += '<div class="cl"></div>';
nav += '</div>';
nav += '</div>';
nav += '</div>';

document.writeln(nav);

function showAllGame(){
	var allgame=document.getElementById("all_game");
	allgame.style.display='block';
}
function hiddenAllGame(){
	var allgame=document.getElementById("all_game");
	allgame.style.display='none';
}