/**
 * 顯示自訂輸入欄位
 */
function showCustomInput() {
    $('#param').show();
    $('#isGenerateNewPoints').show();
    $('#travelPointCount').show();
    $('#isShowBest').hide();
};

/**
 * 固定輸入欄位
 */
function showFixInput() {
    triggerParam();
    $('#isGenerateNewPoints').hide();
    $('#travelPointCount').hide();
    $('#isShowBest').show();
}

/**
 * 判斷是否顯示參數輸入欄位
 */
function triggerParam() {
    if ($('#isShowBestInput').attr('checked') == 'checked') {
        $('#param').hide();
    } else {
        $('#param').show();
    }
}

// 判斷要如何顯示參數
if ($('#dataSource').val() == 'custom') {
    showCustomInput();
} else {
    showFixInput();
}

// 選擇隨機產生模式，隱藏產生新的旅行點、旅行點數量欄位
$('#dataSource').change(function() {
    if ($(this).val() == 'custom') {
        showCustomInput();
    } else {
        showFixInput();
    }
});

// 修改旅行點數量自動勾選產生新的旅行點
$('#travelPointCountInput').change(function() {
    $('#isGenerateNewPointsInput').attr('checked', 'checked');
});

// 勾選顯示最佳值，移除參數顯示
$('#isShowBestInput').change(function() {
    triggerParam();
});
