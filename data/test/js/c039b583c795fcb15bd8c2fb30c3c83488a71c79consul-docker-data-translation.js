var _ = require("lodash");

module.exports = function () {
    return {
        serviceRegistryObject,
        serviceId,
        serviceTags,
    };

    function serviceRegistryObject (service) {
        var id = serviceId(service);
        var tags = serviceTags(service);
        return {name: service.properties.name, id, tags, address: service.ip, port: service.port};
    }

    function serviceId (service) {
        return [
            "registrator",
            service.properties.name,
            service.properties.descriminator
        ].filter(_.identity).join(":");
    }

    function serviceTags (service) {
        var tags = (service.properties.tags || "").split(",").filter(_.identity);

        if (service.properties.descriminator) {
            tags.push(service.properties.descriminator);
        }
        return tags;
    }
};
