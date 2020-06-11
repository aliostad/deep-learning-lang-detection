<script>
    var showYear,showWeek,showHour,showDay,showMin,showSec,endtime,showZero,periTime,showPeri,showTextTime;
    <?php
        echo " showPeri = 0;";
        // Показывать с периодичностью
        if ($showPeri){echo " var showPeri =  $showPeri;";}
        // Отображение
        echo "var showYear = showWeek = showDay = showMin = showSec = 0;";

        if (strpos($showFormatDate,'Y')!== false) {echo " var showYear =  1;";}
        if (strpos($showFormatDate,'W')!== false) {echo " var showWeek =  1;";}
        if (strpos($showFormatDate,'H')!== false) {echo " var showHour =  1;";}
        if (strpos($showFormatDate,'D')!== false) {echo " var showDay  =  1;";}
        if (strpos($showFormatDate,'M')!== false) {echo " var showMin  =  1;";}
        if (strpos($showFormatDate,'S')!== false) {echo " var showSec  =  1;";}

        // Время для обратного отсчета
        echo " endtime  =  $endtime;";
        echo " showZero =  $showZero;";
        // Текст для отображения
        if($showText){ echo " var showTextTime =  '$showTextTimer';"; }
        else { echo " var showTextTime =  '';";}
    ?>
    var divShowText = document.getElementById('ShowText');
    divShowText.innerHTML = showTextTime;

    if (showYear == 0){ hideElement('tYear')};
    if (showWeek == 0){ hideElement('tWeek')};
    if (showHour == 0){ hideElement('tHour')};
    if (showDay == 0) { hideElement('tDay')};
    if (showMin == 0) { hideElement('tMin')};
    if (showSec == 0) { hideElement('tSec')};

    if(showPeri){
        var endDay = new Date();
        endDay.setHours(23,59,59,999);
        endtime = Math.floor(endDay.getTime() / 1000);
    }
    setInterval('ShowTime()', 1000);
</script>

