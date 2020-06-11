export default class ModalLoginController {
    /* @ngInject */
    constructor(modalsService, userHelperFactory, userService, toastrService) {
        this._modalsService = modalsService;
        this._userService = userService;
        this._toastr = toastrService;

        this.config = userHelperFactory.createLoginForm();
    }

    handleSubmit({ obj }) {
        return this._userService.login(obj.username, obj.password)
            .then(() => this._modalsService.close())
            .catch(() => {
                this._toastr.apply('uncorrect_signin');
            });
    }
}
