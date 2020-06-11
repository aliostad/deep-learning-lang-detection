export class serviceService {
    /* @ngInject */
    constructor(requestService) {
        this._requestService = requestService;

        this.services = null;
        this.count = 0;
        this.countPerPage = 15;
    }

    get() {
        return this.services;
    }
    set(services) {
        this.services = services;
    }

    getList(page, size = this.countPerPage) {
        return this._requestService
            .fetch('service', 'services_list', {
                page, size
            })
            .catch(() => []);
    }

    put(service) {
        return this._requestService
            .fetch('service', 'edit', null, service);
    }

    post(service) {
        return this._requestService
            .fetch('service', 'add', null, service);
    }

    remove(id) {
        return this._requestService
            .fetch('service', 'remove', {
                id
            })
            .catch(() => null);
    }

    // todo after doctors
    // getServiceDoctorsList(id, page, size = this.countPerPage) {
    //     return this._requestService
    //         .fetch('service', 'doctors_list', {
    //             id, page, size
    //         })
    //         .catch(() => []);
    // }

    fetchCount() {
        return this._requestService
            .fetch('service', 'count')
            .catch(() => null);
    }

    fetchAllServices() {
        return this._requestService
            .fetch('service', 'services')
            .catch(() => null);
    }
}
