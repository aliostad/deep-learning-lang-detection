import fs from 'fs';
import path from 'path';

export default function registerServices(app) {
  let fetchr = app.getPlugin('FetchrPlugin');

  let services = fs.readdirSync(path.join(app.root, 'services'));

  services.forEach((serviceName) => {
    let servicePath = path.join(app.root, 'services', serviceName);
    let Service = require(servicePath);

    const service = new Service({
      serviceName: Service.serviceName,
      collection: Service.collection
    });

    fetchr.registerService(service);
  });

  return fetchr;
}
