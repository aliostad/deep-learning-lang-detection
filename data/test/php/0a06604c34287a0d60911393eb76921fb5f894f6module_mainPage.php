<?php

class mainPage { 

var $module_caption=	"Главная";
var $module_group=		"main";
var $module_name=		"mainPage";

var $page;
var $run="\r\n";
var $runn="\r\n\r\n";


function engine() {

	$ms=array();	
	$show="";
	switch ($this->page) {

	case 'mainPage':
		$title="Главная страница";
		$descr="Создание сайтов, управление сайтом, CMS, редактирование информации и стилизации на сайте, качественные сайты, разработка сайтов";
		$keywords="cms, сайты, управление, создание, редактирование, разработка, информация, дизайн, изменение";

		//$show.= 	$this->about();
		$show.= 	$this->show_modules();
		
		$ms['title']=		$title;
		$ms['description']=	$descr;
		$ms['keywords']=	$keywords;
		$ms['html']=		$show;
		$ms['result']=		"TRUE";
	break;
	
	}

	return $ms;
}

function show_modules() {

    $show="";
    $line=$this->show_box("content");
    if ($line['show']!="FALSE") {
        $show.='<div class="clGroupLine">';
        $show.= '<div class="clGroupName">приложения для работы с контентом</div>';
        $show.='</div>';
        $show.='<div class="clGroupBox">';
        $show.=$line['show'];
        $show.='</div>';
    }
    $line=$this->show_box("layout");
    if ($line['show']!="FALSE") {
        $show.='<div class="clGroupLine">';
        $show.= '<div class="clGroupName">приложения для работы с версткой</div>';
        $show.='</div>';
        $show.='<div class="clGroupBox">';
        $show.=$line['show'];
        $show.='</div>';
    }
    $line=$this->show_box("design");
    if ($line['show']!="FALSE") {
        $show.='<div class="clGroupLine">';
        $show.= '<div class="clGroupName">приложения для работы с дизайном</div>';
        $show.='</div>';
        $show.='<div class="clGroupBox">';
        $show.=$line['show'];
        $show.='</div>';
    }
    $line=$this->show_box("modern");
    if ($line['show']!="FALSE") {
        $show.='<div class="clGroupLine">';
        $show.= '<div class="clGroupName">приложения для работы с функционалом сайта</div>';
        $show.='</div>';
        $show.='<div class="clGroupBox">';
        $show.=$line['show'];
        $show.='</div>';
    }
    $line=$this->show_box("settings");
    if ($line['show']!="FALSE") {
        $show.='<div class="clGroupLine">';
        $show.= '<div class="clGroupName">настройки модулей и плагинов</div>';
        $show.='</div>';
        $show.='<div class="clGroupBox">';
        $show.=$line['show'];
        $show.='</div>';
    }
    $line=$this->show_box("another");
    if ($line['show']!="FALSE") {
        $show.='<div class="clGroupLine">';
        $show.= '<div class="clGroupName">другие виды приложений</div>';
        $show.='</div>';
        $show.='<div class="clGroupBox">';
        $show.=$line['show'];
        $show.='</div>';
    }
    return $show;
}

function show_box($obj) {
    
    $ms=array();
    $show="";
    $count=0;
        reset($this->modules);
        foreach ($this->modules as $mdl) {
    		$name=$mdl['name'];
            $this->$name = new $name;
            if (isset($this->$name->module_obj)) {
              if ($this->$name->module_obj==$obj) {
                $show.='<div class="clModuleBox">';
                $show.= '<div class="clModuleIcon"><a title="перейти к этому приложению" href="index.php?page='.$name.'">';
                $ico='modules/'.$name.'/ico_48.png';
                //if (file_exists($ico)) {
                    $show.=     '<img src="modules/'.$name.'/ico_48.png">';
                //}   else {
                //    $show.=     '<img src="modules/mainPage/ico_48.png">';
                //} 
                $show.= '</a></div>';
                $show.= '<div class="clModuleContent">';
                $show.=     '<div class="clModuleName"><a title="перейти к этому приложению" href="index.php?page='.$name.'">';
                if (isset($this->$name->module_caption)) {
                    $caption=$this->$name->module_caption;
                    if (strlen($caption)>18) {
                        $caption=substr($caption,0,17)."...";
                    }
                    $show.=$caption;
                }
                $show.=     '</a></div>';
                $show.=     '<div class="clModuleCaption">';
                if (isset($this->$name->module_key)) {
                    $key=$this->$name->module_key;
                    if (strlen($key)>8) {
                        $key=substr($key,0,7)."...";
                    }
                    $show.=$key;
                }
                $show.=     '</div>';
                $show.= '</div>';
                $show.= '</div>';
                $count++;
              }
            }
		}
    if ($count==0) { $show="FALSE"; }
    $ms['show']=$show;
    $ms['count']=$count;
    
    return $ms;
    
}

function about() {

	$show=	$this->run;
	$show.='<div class="clTextLine">'.$this->run;
	$show.=	'<div class="clSomeText">'.$this->run;
	//$show.=		'<b>CMS Dement</b><br><br>'.$this->run;
	$show.=		'<b>Добро пожаловать</b> в Систему Управления Сайтом <b>Dement</b>!<br>'.$this->run;
	$show.=		'<br>'.$this->run;

	$show.=		'Данная Система полностью <b>автоматизирует работу с дизайном и информацией</b>, находящейся на Вашем веб-сайте.<br>'.$this->run;
	$show.=		'Используя данную Систему, Вы можете полностью контролировать <b>Ваш сайт</b> и данные, которые он содержит.<br>'.$this->run;
	$show.=		'Система также позволяет не только обслуживать текущий сайт, но и <b>создать с чистого листа новый веб-проект</b>.<br>'.$this->run;
	$show.=		'<br>'.$this->run;

	$show.=		'<b>Основные возможности</b> этой Cистемы:<br>'.$this->run;
	$show.=		'-Возможность <b>создать собственный сайт с "чистого листа"</b><br>'.$this->run;
	$show.=		'-Редактирование всей контекстной <b>информации</b>, находящейся на сайте<br>'.$this->run;
	$show.=		'-Возможность полного <b>изменения дизайна</b> сайта<br>'.$this->run;
	$show.=		'-<b>Изменение макета</b> и сруктуры сайта<br>'.$this->run;
	$show.=		'-<b>Управление графическими изображениями</b><br>'.$this->run;
	$show.=		'-<b>Загрузка</b> на сайт любых <b>файлов</b> и документов<br>'.$this->run;
	$show.=		'-Добавление на сайт <b>скриптов и анимации</b><br>'.$this->run;
	$show.=		'<br>'.$this->run;

	$show.=		'<b>Отличия</b> данной Cистемы от других:<br>'.$this->run;
	$show.=		'-<b>Интуитивно-понятный интерфейс</b>, позволяющий быстро освоиться в работе с данной Системой<br>'.$this->run;
	$show.=		'-Возможность делать практически все изменения на сайте через <b>Служебную часть</b><br>'.$this->run;
	$show.=		'-Автоматическая <b>оптимизация сайта под поисковые системы</b><br>'.$this->run;
	$show.=		'-<b>Несложная</b> установка<br>'.$this->run;
	$show.=		'-<b>Простота</b> в обновлении Системы<br>'.$this->run;
	$show.=		'<br>'.$this->run;

	$show.=		'<b>Нашей целью</b> является максимально облегчить дальнейшую работу наших клиентом с веб-проектом, после того как мы его закончим. '.$this->run;
	$show.=		'Безусловно, мы всегда оказываем полную техническую поддержку наших проектов и всегда исправляем и дорабатываем все, что нас попросят, '.$this->run;
	$show.=		'но мы считаем, что <b>для Вас важно</b>, когда вы можете <b>самостоятельно управлять своим проектом</b> и в любое время делать изменения, которые '.$this->run;
	$show.=		'по Вашему мнению будут необходимы.<br>'.$this->run;
	$show.=		'<br>'.$this->run;

	$show.=		'<b>Желаем Вам</b> приятной работы!<br>'.$this->run;

	$show.=	'</div>'.$this->run;
	$show.='</div>'.$this->runn;
	return $show;
}


}



?>