messages = {
    message: '',
    category: '',
    renderMessage: function() {
        if(this.category == '') {
            this.category = 'info'
        }

        if(this.message == '' || this.message == 'None') {
            $('#message').parent().hide();
            $('#message').html('');
        } else {
            $('#message > a').addClass('alert-link');
            $('#message').html(this.message);
            $('#message').parent().attr('class', 'alert alert-dismissible alert-' + this.category);
            $('#message').parent().show();
        }
    },

    add: function(message, category) {
        this.message = message;
        this.category = category;
        this.renderMessage();
    },

    addInfo: function(message) {
        this.add(message, 'info');
    },

    addSuccess: function(message) {
        this.add(message, 'success');
    },

    addWarning: function(message) {
        this.add(message, 'warning');
    },

    addDanger: function(message) {
        this.add(message, 'danger');
    }
}