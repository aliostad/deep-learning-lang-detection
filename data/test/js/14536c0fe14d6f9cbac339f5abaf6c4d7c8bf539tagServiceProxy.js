"use strict";

import {TagService, Tag} from '../../thriftTypes'

import {thriftServiceName, thriftService, serviceInterface} from '../../annotations';
import BaseServiceProxy from '../baseServiceProxy';

@thriftServiceName("TagService")
@thriftService(TagService)
class TagServiceProxy extends BaseServiceProxy {

    @serviceInterface
    async createTag(args) {
        var tag = new Tag(args);
        tag.id = await this.client.createTagAsync(tag);
        return tag;
    }
}

TagServiceProxy.generateInterfaceMethods(['getTag']);

export default TagServiceProxy;

