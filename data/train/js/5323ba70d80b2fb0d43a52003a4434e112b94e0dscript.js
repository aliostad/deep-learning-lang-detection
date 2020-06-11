
    $(document).ready(function () {
        var socket = io.connect('http://localhost:8008');

        var message_txt = $(".message_text");
		console.log('.message_text ',$(".message_text"));
		var message_txt2 = $(".message_text2");
		console.log('.message_text ',$(".message_text2"));

        socket.on('message', function (data) {
            console.log('data!', data);
            message_txt.focus();
        });
		$("#message_btn").click(function () {
		});
        $("#message_btn").click(function () {
            var text = "registration"+"|"+$("#login").val()+"|"+$("#password").val()+"|"+$("#email").val()+"|"+$("#country").val()+"|"+$("#city").val()+"|"+$("#photo").val()+"|";
            if (text.length <= 0)
                return;
            message_txt.val("");
			message_txt2.val("");
            socket.emit("message", {message: text});
        });

    });