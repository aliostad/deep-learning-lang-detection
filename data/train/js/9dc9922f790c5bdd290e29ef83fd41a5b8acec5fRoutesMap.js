module.exports = {
    common: {
        index: {
            controller: "IndexController"
        },
        chat: {
            index: {
                controller: "ChatController"
            },
            private: {
                controller: "ChatController"//fake
            },
            ":action": {
                controller: "ChatController"
            }
        },
        blog: {
            index: {
                controller: "ChatController"//fake
            }
        },
        user: {
            register: {
                controller: "RegisterController"
            },
            'login': {
                controller: "LoginController"
            },
            logout: {
                controller: "LoginController"
            }
        },
        test: {
            controller: "TestController"
        }
    }
};