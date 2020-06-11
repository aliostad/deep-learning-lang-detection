"use strict";

import {EntityService, Entity} from '../../thriftTypes'

import {thriftService, thriftServiceName, serviceInterface} from '../../annotations';
import BaseServiceProxy from '../baseServiceProxy';

@thriftService(EntityService)
@thriftServiceName("EntityService")
class EntityServiceProxy extends BaseServiceProxy {

    @serviceInterface
    async createEntity(args) {
        var entity = new Entity(args);
        entity.id = await this.client.createEntityAsync(entity);
        return entity;
    }
}

EntityServiceProxy.generateInterfaceMethods(['getEntity']);

export default EntityServiceProxy;

