var ServiceMap = {
  target: "http://mysite.com",
  services: [
      { serviceName: "getUsers",    serviceUri: "/api/user",      behavior: "GetUsers" }
    , { serviceName: "getUser",     serviceUri: "/api/user/123",  behavior: "GetUser" }
    , { serviceName: "addUser",     serviceUri: "/api/user",      behavior: "CreateUser" }
    , { serviceName: "updateUser",  serviceUri: "/api/user/123",  behavior: "UpateUser" }
    , { serviceName: "deleteUser",  serviceUri: "/api/user/123",  behavior: "DeleteUser" }
  ]
};

exports.ServiceMap = ServiceMap;