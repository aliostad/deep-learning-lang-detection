export default class ModalEditServiceController {
    /* @ngInject */
    constructor(modalsService, serviceHelperFactory, $log, serviceService, $state, $stateParams, userService) {
        this._modalsService = modalsService;
        this._serviceHelperFactory = serviceHelperFactory;
        this._$log = $log;
        this._serviceService = serviceService;
        this._userService = userService;
        this._$state = $state;

        this.page = parseInt($stateParams.page, 10) || 1;
    }

    set service(service) {
        this._service = service;

        this.config = this.createReadForm();
    }

    get service() {
        return this._service;
    }

    handleAction({ name, data }) {
        if (this[name]) {
            return this[name](data);
        }

        this._$log.error(`Unhandled action: ${name}`);
    }

    doctors() {
        this._$state.transitionTo('app.doctor.service', { serviceId: this.service.id });
        this._modalsService.close();
    }

    handleSubmit({ obj }) {
        return this._serviceService.put(obj)
            .then((services) => this._serviceService.getList(this.page))
            .then((services) => {
                this._serviceService.set(services);
                this._modalsService.close();
            })
            .catch(() => null);
    }

    edit() {
        this.config = this._serviceHelperFactory.createSendForm(this._service);
    }

    remove() {
        this._modalsService.openConfirm('Подтвердить удаление', () => {
            return this._serviceService.remove(this._service.id)
                .then((service) => this._serviceService.getList(this.page))
                .then((services) => {
                    this._serviceService.services = services;
                    this._modalsService.close();
                });
        });
    }

    createReadForm() {
        return this._serviceHelperFactory.createReadForm(this._service, {
            canWrite: this.canWrite
        });
    }

    get canWrite() {
        const permission = this._userService.findPermissionsByName('service');

        return permission && permission.canWrite;
    }
}
