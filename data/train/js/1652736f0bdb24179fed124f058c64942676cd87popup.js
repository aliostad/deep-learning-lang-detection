// JavaScript Document

$(document).ready(function(){
        //Скрыть PopUp при загрузке страницы    
        PopUpHide();
    });
    //Функция отображения Реквизитов
    function ShowREK(){
        $("#popup-details").show();
		$("#bg-popup").show();
    }
	    //Функция отображения Отложенного платежа
    function ShowDELAY(){
        $("#popup-delay").show();
		$("#bg-popup").show();
    }
		    //Функция отображения Ошибок
    function ShowERR(){
        $("#popup-error").show();
		$("#bg-popup").show();
    }
	//Функция отображения Добавления счетов
    function ShowCARD2(){
        $("#new-card-account").show();
		$("#popup-new-account").show();
		$("#popup-new-card").hide();
		$("#bg-popup").show();
    }
	//Функция отображения Добавления карт
    function ShowCARD(){
        $("#new-card-account").show();
		$("#popup-new-card").show();
		$("#bg-popup").show();
    }
	
	//Функция отображения Подтверждения перевода
    function ShowCONFIRM(){
		$("#popup-confirmation").show();
		$("#bg-popup").show();
    }
	
	//Функция отображения карт
    function allCARD(){
        $(".whom-popup").show();
    }
	
	//Функция отображения Досрочного погашения
    function ShowCycle(){
        $("#popup-cycle").show();
		$(".cycle-complete").show();
		$("#bg-popup").show();
		$(".cycle-part").hide();
    }
	
	//Функция отображения Частичного погашения 
    function ShowPart(){
        $("#popup-cycle").show();
		$(".cycle-complete").hide();
		$("#bg-popup").show();
		$(".cycle-part").show();
    }
	
	//Функция отображения Настроек
    function ShowSet(){
        $("#popup-settings").show();
		$(".new-login").show();
		$("#bg-popup").show();
		$(".new-password").hide();
		$(".new-phone").hide();
    }
	
	//Функция отображения пароля
    function ShowPASS(){
        $("#popup-settings").show();
		$(".new-login").hide();
		$("#bg-popup").show();
		$(".new-password").show();
		$(".new-phone").hide();
    }
	
	//Функция отображения номера
    function ShowPHONE(){
        $("#popup-settings").show();
		$(".new-login").hide();
		$("#bg-popup").show();
		$(".new-password").hide();
		$(".new-phone").show();
    }
    //Функция скрытия PopUp
    function PopUpHide(){
        $("#popup-details").hide();
		$("#popup-confirmation").hide();
		$("#popup-error").hide();
		$("#popup-delay").hide();
		$("#new-card-account").hide();
		$("#popup-new-account").hide();
		$("#bg-popup").hide();
		$(".whom-popup").hide();	
		$("#popup-cycle").hide();
		$(".cycle-complete").hide();
		$(".new-password").hide();
		$(".new-phone").hide();
		$(".new-login").hide();
		$("#popup-settings").hide();
		
    }





