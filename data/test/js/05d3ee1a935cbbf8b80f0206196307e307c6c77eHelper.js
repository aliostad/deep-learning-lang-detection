; var ServiceCall = function (serviceName, serviceParams) {
    this._serviceName = serviceName;
    this._serviceParams = serviceParams;
    return this;
};

ServiceCall.prototype = {
    callService: function (serviceCallSuccess) {
        $.ajax({
            type: "POST",
            url: 'ChatService.asmx/' + this._serviceName,
            data: this._serviceParams,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: serviceCallSuccess,
            error: function (e) {
                //alert("Error in caling serice.");
            }
        });
    }
}