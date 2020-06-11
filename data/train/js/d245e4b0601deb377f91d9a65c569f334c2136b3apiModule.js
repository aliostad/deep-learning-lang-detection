/*
  About:
  - Deals with all the BitGo API requests
*/
angular.module('BitGo.API', [
  // Modules for BitGo.API composition
  'BitGo.API.AccessTokensAPI',
  'BitGo.API.ApprovalsAPI',
  'BitGo.API.AuditLogAPI',
  'BitGo.API.EnterpriseAPI',
  'BitGo.API.IdentityAPI',
  'BitGo.API.KeychainsAPI',
  'BitGo.API.LabelsAPI',
  'BitGo.API.JobsAPI',
  'BitGo.API.MarketDataAPI',
  'BitGo.API.PolicyAPI',
  'BitGo.API.ProofsAPI',
  'BitGo.API.ReportsAPI',
  'BitGo.API.SDK',
  'BitGo.API.SettingsAPI',
  'BitGo.API.StatusAPI',
  'BitGo.API.TransactionsAPI',
  'BitGo.API.UserAPI',
  'BitGo.API.WalletsAPI',
  'BitGo.API.WalletSharesAPI',
  'BitGo.API.MatchwalletAPI',
  'BitGo.API.ssAPI',

  // Dependencies for this module
  'BitGo.Model',
  'BitGo.Utility',
  'feature-flags'
  
]);
