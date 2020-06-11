import DashboardController from 'user/controllers/DashboardController';
import LoginController from 'user/controllers/LoginController';
import RegistrationController from 'user/controllers/RegistrationController';
import ConfirmEmailController from 'user/controllers/ConfirmEmailController';
import UpdateProfileController from 'user/controllers/UpdateProfileController';
import ResendConfirmationController from 'user/controllers/ResendConfirmationController';
import ForgotPasswordController from 'user/controllers/ForgotPasswordController';
import ConfirmForgotPasswordController from 'user/controllers/ConfirmForgotPasswordController';
import ResetPasswordController from 'user/controllers/ResetPasswordController';
import userConfig from 'user/config/UserConfig';
import UserService from 'user/services/UserService';
import userConstants from 'user/constants/UserConstants';

export var userModule = {
    controllers: [DashboardController, LoginController, RegistrationController,
        ConfirmEmailController, UpdateProfileController, ResendConfirmationController,
        ForgotPasswordController, ConfirmForgotPasswordController, ResetPasswordController],
    config: userConfig,
    services: [UserService],
    constants: userConstants
}



