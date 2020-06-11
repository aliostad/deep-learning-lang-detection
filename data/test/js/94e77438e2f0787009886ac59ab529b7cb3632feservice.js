// Copyright (c) 2015, Evan Summers (twitter.com/evanxsummers)
// ISC license, see http://github.com/evanx/redex/LICENSE

const logger = Loggers.create(module.filename);

export function create() {

   const state = {
      services: new Map()
   };

   const those = {
      pubService(service) {
         return {
            status: service.status,
            alertedStatus: service.alertedStatus,
            debug: service.debug
         }
      },
      pubName(name) {
         let service = state.services.get(name);
         if (!service) {
            throw 'Invalid service: ' + name;
         } else {
            logger.debug('pubName', name, service.name);
            return those.pubService(service);
         }
      },
      async pub() {
         let reply = {};
         for (let [key, service] of state.services) {
            reply[key] = those.pubService(service);
         }
         return reply;
      },
      get services() {
         return state.services;
      },
      add(service) {
         if (state.services.has(service.name)) {
            logger.warn('duplicate', service.name, service.type);
            service.name = service.type + ':' + service.name;
         }
         assert(!state.services.has(service.name), 'unique: ' + service.name);
         assert(service.name, 'name: ' + Object.keys(service).join(', '));
         if (!service.label) {
            service.label = service.name;
         }
         service.debug = service.debug || {};
         state.services.set(service.name, service);
      }
   };

   return those;
}
