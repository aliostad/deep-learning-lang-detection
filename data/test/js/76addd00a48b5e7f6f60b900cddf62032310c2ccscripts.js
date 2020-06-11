$(document).ready(function () {
//        $(".code").click(function () {
//            $("#code").modal('show');
//        });
//
//        $(".creative").click(function () {
//            $("#creative").modal('show');
//        });
//
//        $(".deliverymethod").click(function () {
//            $("#deliverymethod").modal('show');
//        });
//
//        $(".brand").click(function () {
//            $("#brand").modal('show');
//        });
//
//        $(".service").click(function () {
//            $("#service").modal('show');
//        });
//
//        $(".color").click(function () {
//            $("#color").modal('show');
//        });

//    $(".contactus-click").click(function () {
//        $("#modal_contactus").modal('show');
//    });

    $(".contactus-click").each(function () {
        $(this).click(function () {
            $("#modal_contactus").modal('show');
        });
    });
});
