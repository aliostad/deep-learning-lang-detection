import {inject} from 'aurelia-framework';
import ApiBaseService from 'resources/services/api-base-service';
import OperationService from 'resources/services/operation-service';

@inject(ApiBaseService, OperationService)
export default class WardenService {
  constructor(apiBaseService, operationService)  {
    this.apiBaseService = apiBaseService;
    this.operationService = operationService;
  }

  async get(organizationId, wardenId) {
    return await this.apiBaseService.get(`organizations/${organizationId}/wardens/${wardenId}`);
  }

  async create(organizationId, name, enabled=true) {
    const request = { name, enabled };

    return await this.operationService.execute(async ()
      => await this.apiBaseService.post(`organizations/${organizationId}/wardens`, request));
  }
}
