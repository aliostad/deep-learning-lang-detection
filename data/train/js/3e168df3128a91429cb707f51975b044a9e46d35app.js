import {inject} from 'aurelia-framework';
import {NotificationService, Notification} from 'aurelia-notify';

@inject(NotificationService)
export class App {
  constructor(notificationService) {
    this.notificationService = notificationService;
  }

  info() {
    this.notificationService.info('Info Message');
  }

  success() {
    this.notificationService.success('Success Message');
  }

  warning() {
    this.notificationService.warning('Warning Message');
  }

  danger() {
    this.notificationService.danger('Danger Message');
  }

  custom() {
    this.notificationService.notify({notification: 'test'}, {}, 'info');
  }
}
