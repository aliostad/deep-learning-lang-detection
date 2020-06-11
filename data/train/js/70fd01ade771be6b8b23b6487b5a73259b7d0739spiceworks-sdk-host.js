import Oasis from "oasis";
import EnvironmentService from "environment-service";
import HelpdeskService from "helpdesk-service";
import InventoryService from "inventory-service";
import PeopleService from "people-service";
import ReportingService from "reporting-service";
import LoginService from "login-service";

self.Oasis = Oasis;
var oasis = new self.Oasis();
oasis.autoInitializeSandbox();

export {
  oasis,
  EnvironmentService,
  HelpdeskService,
  InventoryService,
  PeopleService,
  ReportingService,
  LoginService
};
