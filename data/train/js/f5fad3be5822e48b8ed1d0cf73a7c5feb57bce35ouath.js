
AccountsOauthServer = {
  config(serviceId) {
    check(serviceId, String);

    let serviceName = serviceId.replace(/Login/g, "");
    const serviceKeys = Systems.findOne({ _id: serviceId });

    if (serviceName === "meteor") serviceName = 'meteor-developer';

    if (serviceKeys) {
      ServiceConfiguration.configurations.remove({ service: serviceName });
      if (serviceName === "facebook") {
        ServiceConfiguration.configurations.insert({
          service: "facebook",
          appId: serviceKeys.appId,
          secret: serviceKeys.secret
        });
        return;
      }
      if (serviceName === "twitter") {
        ServiceConfiguration.configurations.insert({
          service: "twitter",
          consumerKey: serviceKeys.consumerKey,
          secret: serviceKeys.secret
        });
        return;
      }
      if (serviceName === 'kakao') {
        ServiceConfiguration.configurations.insert({
          service: "kakao",
          clientId: serviceKeys.clientId
        });
        return;
      }

      ServiceConfiguration.configurations.insert({
        service: serviceName,
        clientId: serviceKeys.clientId,
        secret: serviceKeys.secret
      });
      return;
    }
  }
};
