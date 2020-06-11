// JavaScript source code

function showTab(id) {
    $('.selectedtab').removeClass('selectedtab');
    $('.tab').hide();
    $('#' + id + '_tab').show();
    $('#' + id + '_ti').addClass('selectedtab');
}

$(document).ready(function () {
    showTab('solutions');


    $('#solutions_ti').click(function () {
        showTab('solutions');
    });

    $('#precipitation_ti').click(function () {
        showTab('precipitation');
    });

    $('#chroma_ti').click(function () {
        showTab('chroma');
    });

    $('#sdspage2d_ti').click(function () {
        showTab('sdspage2d');
    });

    $('#sdspage_ti').click(function () {
        showTab('sdspage');
    });
});
