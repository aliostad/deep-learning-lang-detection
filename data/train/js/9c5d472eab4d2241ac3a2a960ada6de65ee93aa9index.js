// that sweet sweet angular
import angular from 'angular'

import AppController from './AppController'
import CarrierDetailController from './CarrierDetailController'
import CarrierListController from './CarrierListController'
import CustomerDetailController from './CustomerDetailController'
import CustomerListController from './CustomerListController'
import DrawingDetailController from './DrawingDetailController'
import DrawingListController from './DrawingListController'
import JobDetailController from './JobDetailController'
import JobListController from './JobListController'
import LoginController from './LoginController'
import ManufacturerDetailController from './ManufacturerDetailController'
import ManufacturerListController from './ManufacturerListController'
import MarkDetailController from './MarkDetailController'
import MarkZoneDetailController from './MarkZoneDetailController'
import MarkListController from './MarkListController'
import PartDetailController from './PartDetailController'
import PartListController from './PartListController'
import PartOrderDetailController from './PartOrderDetailController'
import PartOrderListController from './PartOrderListController'
import SalespersonDetailController from './SalespersonDetailController'
import SalespersonListController from './SalespersonListController'
import ShipmentDetailController from './ShipmentDetailController'
import ShipmentListController from './ShipmentListController'
import ShipmentItemDetailController from './ShipmentItemDetailController'
import ShipmentItemListController from './ShipmentItemListController'
import ShippingGroupDetailController from './ShippingGroupDetailController'
import ShippingGroupListController from './ShippingGroupListController'
import ShippingGroupItemDetailController from './ShippingGroupItemDetailController'
import ShippingGroupItemZoneDetailController from './ShippingGroupItemZoneDetailController'
import ShippingGroupItemListController from './ShippingGroupItemListController'
import ShopDetailController from './ShopDetailController'
import ShopListController from './ShopListController'
import SpecialtyItemDetailController from './SpecialtyItemDetailController'
import SpecialtyItemListController from './SpecialtyItemListController'
import SystemTypeDetailController from './SystemTypeDetailController'
import SystemTypeListController from './SystemTypeListController'
import UserDetailController from './UserDetailController'
import UserListController from './UserListController'
import VendorDetailController from './VendorDetailController'
import VendorListController from './VendorListController'
import ZoneDetailController from './ZoneDetailController'
import ZoneListController from './ZoneListController'
import ReportController from './ReportController'
import ModalJobReportController from './ModalJobReportController'
import ResetController from './ResetController'

export const controllers = {
  AppController,
  CarrierDetailController,
  CarrierListController,
  CustomerDetailController,
  CustomerListController,
  DrawingDetailController,
  DrawingListController,
  JobDetailController,
  JobListController,
  LoginController,
  ManufacturerDetailController,
  ManufacturerListController,
  MarkDetailController,
  MarkListController,
  MarkZoneDetailController,
  PartDetailController,
  PartListController,
  PartOrderDetailController,
  PartOrderListController,
  SalespersonDetailController,
  SalespersonListController,
  ShipmentDetailController,
  ShipmentListController,
  ShipmentItemDetailController,
  ShipmentItemListController,
  ShippingGroupDetailController,
  ShippingGroupListController,
  ShippingGroupItemDetailController,
  ShippingGroupItemZoneDetailController,
  ShippingGroupItemListController,
  ShopDetailController,
  ShopListController,
  SpecialtyItemDetailController,
  SpecialtyItemListController,
  SystemTypeDetailController,
  SystemTypeListController,
  UserDetailController,
  UserListController,
  VendorDetailController,
  VendorListController,
  ZoneDetailController,
  ZoneListController,
  ReportController,
  ModalJobReportController,
  ResetController
}

export default
  angular
    .module('ssi.controllers.old', [])
      .controller('AppController', AppController)
      .controller('CarrierDetailController', CarrierDetailController)
      .controller('CarrierListController', CarrierListController)
      .controller('CustomerDetailController', CustomerDetailController)
      .controller('CustomerListController', CustomerListController)
      .controller('DrawingDetailController', DrawingDetailController)
      .controller('DrawingListController', DrawingListController)
      .controller('JobDetailController', JobDetailController)
      .controller('JobListController', JobListController)
      .controller('LoginController', LoginController)
      .controller('ManufacturerDetailController', ManufacturerDetailController)
      .controller('ManufacturerListController', ManufacturerListController)
      .controller('MarkDetailController', MarkDetailController)
      .controller('MarkZoneDetailController', MarkZoneDetailController)
      .controller('MarkListController', MarkListController)
      .controller('PartDetailController', PartDetailController)
      .controller('PartListController', PartListController)
      .controller('PartOrderDetailController', PartOrderDetailController)
      .controller('PartOrderListController', PartOrderListController)
      .controller('SalespersonDetailController', SalespersonDetailController)
      .controller('SalespersonListController', SalespersonListController)
      .controller('ShipmentDetailController', ShipmentDetailController)
      .controller('ShipmentListController', ShipmentListController)
      .controller('ShipmentItemDetailController', ShipmentItemDetailController)
      .controller('ShipmentItemListController', ShipmentItemListController)
      .controller('ShippingGroupDetailController', ShippingGroupDetailController)
      .controller('ShippingGroupListController', ShippingGroupListController)
      .controller('ShippingGroupItemDetailController', ShippingGroupItemDetailController)
      .controller('ShippingGroupItemZoneDetailController', ShippingGroupItemZoneDetailController)
      .controller('ShippingGroupItemListController', ShippingGroupItemListController)
      .controller('ShopDetailController', ShopDetailController)
      .controller('ShopListController', ShopListController)
      .controller('SpecialtyItemDetailController', SpecialtyItemDetailController)
      .controller('SpecialtyItemListController', SpecialtyItemListController)
      .controller('SystemTypeDetailController', SystemTypeDetailController)
      .controller('SystemTypeListController', SystemTypeListController)
      .controller('UserDetailController', UserDetailController)
      .controller('UserListController', UserListController)
      .controller('VendorDetailController', VendorDetailController)
      .controller('VendorListController', VendorListController)
      .controller('ZoneDetailController', ZoneDetailController)
      .controller('ZoneListController', ZoneListController)
      .controller('ReportController', ReportController)
      .controller('ModalJobReportController', ModalJobReportController)
      .controller('ResetController', ResetController)
