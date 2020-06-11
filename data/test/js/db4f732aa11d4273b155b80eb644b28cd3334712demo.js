$(document).ready(function () {
    $("#message1").message();
    $("#message2").message({ type: "error" });
    $("#message3").message({ type: "info", message: "Here's an info message with dynamic content." });
    $("#message4").message({ dismiss: false });
    $("#message5").message();
    $("#message6").message({ dismiss: false });

    $("#message5-button").click(function () {
        $("#message5").message('options', { type: "error", message: "This is now an error message." });
    });

    $("#message6-hide").click(function () {
        $("#message6").message("hide");
    });

    $("#message6-show").click(function () {
        $("#message6").message("show");
    });

    $(".info-message").message();
});