/*
 Copyright 2015 hp.weber GmbH & Co secucard KG (www.secucard.com)
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */
import {SkeletonService} from './skeleton-service';
import {AccountService} from './account-service';
import {AccountDeviceService} from './account-device-service';
import {ContactService} from './contact-service';
import {DeliveryAddressService} from './delivery-address-service';
import {FileAccessService} from './file-access-service';
import {MerchantService} from './merchant-service';
import {NewsService} from './news-service';
import {NotificationService} from './notification-service';
import {PublicMerchantService} from './public-merchant-service';
import {StoreService} from './store-service';
import {TransactionService} from './transaction-service';
import {StoreGroupService} from './store-group-service';

export const General = {};

General.SkeletonService = SkeletonService;
General.AccountService = AccountService;
General.AccountDeviceService = AccountDeviceService;
General.ContactService = ContactService;
General.DeliveryAddressService = DeliveryAddressService;
General.FileAccessService = FileAccessService;
General.MerchantService = MerchantService;
General.NewsService = NewsService;
General.NotificationService = NotificationService;
General.PublicMerchantService = PublicMerchantService;
General.StoreGroupService = StoreGroupService;
General.StoreService = StoreService;
General.TransactionService = TransactionService;

