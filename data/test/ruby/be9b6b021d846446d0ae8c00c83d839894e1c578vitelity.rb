#!/usr/bin/env ruby
# encoding: utf-8

require 'rest_client'
require 'awesome_print'
require 'active_support/core_ext/hash/conversions'

class Vitelity

  def commands
    {"balance"=>"http://api.vitelity.net/api.php",
     "cdrlist"=>"http://api.vitelity.net/api.php",
     "resetcdrlist"=>"http://api.vitelity.net/api.php",
     "didcdrdetail"=>"http://api.vitelity.net/api.php",
     "subaccountcdrdetail"=>"http://api.vitelity.net/api.php",
     "listtollfree"=>"http://api.vitelity.net/api.php",
     "listlocal"=>"http://api.vitelity.net/api.php",
     "listnpanxx"=>"http://api.vitelity.net/api.php",
     "listratecenters"=>"http://api.vitelity.net/api.php",
     "listavailratecenters"=>"http://api.vitelity.net/api.php",
     "searchtoll"=>"http://api.vitelity.net/api.php",
     "listavailstates"=>"http://api.vitelity.net/api.php",
     "liststates"=>"http://api.vitelity.net/api.php",
     "listdids"=>"http://api.vitelity.net/api.php",
     "didnote"=>"http://api.vitelity.net/api.php",
     "listintlratecenters"=>"http://api.vitelity.net/api.php",
     "listintl"=>"http://api.vitelity.net/api.php",
     "getdidnote"=>"http://api.vitelity.net/api.php",
     "listspecificlocal"=>"http://api.vitelity.net/api.php",
     "listnpa"=>"http://api.vitelity.net/api.php",
     "lidb"=>"http://api.vitelity.net/api.php",
     "lidbavailall"=>"http://api.vitelity.net/api.php",
     "getbackorder"=>"http://api.vitelity.net/api.php",
     "gettollfree"=>"http://api.vitelity.net/api.php",
     "getlocaldid"=>"http://api.vitelity.net/api.php",
     "removedid"=>"http://api.vitelity.net/api.php",
     "requestvanity"=>"http://api.vitelity.net/api.php",
     "localbackorder"=>"http://api.vitelity.net/api.php",
     "getintldid"=>"http://api.vitelity.net/api.php",
     "localbackorderrate"=>"http://api.vitelity.net/api.php",
     "didforcebilling"=>"http://api.vitelity.net/api.php",
     "e911send"=>"http://api.vitelity.net/api.php",
     "e911delete"=>"http://api.vitelity.net/api.php",
     "e911checkaddress"=>"http://api.vitelity.net/api.php",
     "e911getinfo"=>"http://api.vitelity.net/api.php",
     "listincomingfaxes"=>"http://api.vitelity.net/fax.php",
     "getfax"=>"http://api.vitelity.net/fax.php",
     "sentfaxstatus"=>"http://api.vitelity.net/fax.php",
     "sendfax"=>"http://api.vitelity.net/fax.php",
     "faxlistdids"=>"http://api.vitelity.net/fax.php",
     "faxgetdid"=>"http://api.vitelity.net/fax.php",
     "faxlistratecenters"=>"http://api.vitelity.net/fax.php",
     "faxliststates"=>"http://api.vitelity.net/fax.php",
     "faxchangeemail"=>"http://api.vitelity.net/fax.php",
     "newfaxacc"=>"http://api.vitelity.net/fax.php",
     "setfaxacc"=>"http://api.vitelity.net/fax.php",
     "allowdidchangeemail"=>"http://api.vitelity.net/fax.php",
     "allowoutchangeemail"=>"http://api.vitelity.net/fax.php",
     "increasecredits"=>"http://api.vitelity.net/fax.php",
     "setcredits"=>"http://api.vitelity.net/fax.php",
     "getcredits"=>"http://api.vitelity.net/fax.php",
     "setlimit"=>"http://api.vitelity.net/fax.php",
     "faxlistmydids"=>"http://api.vitelity.net/fax.php",
     "delfaxacc"=>"http://api.vitelity.net/api.php",
     "addport"=>"http://api.vitelity.net/lnp.php",
     "uploadsignature"=>"http://api.vitelity.net/lnp.php",
     "uploadbill"=>"http://api.vitelity.net/lnp.php",
     "checkavail"=>"http://api.vitelity.net/lnp.php",
     "checkmultiavail"=>"http://api.vitelity.net/lnp.php",
     "callfromclick"=>"http://api.vitelity.net/api.php",
     "reroute"=>"http://api.vitelity.net/api.php",
     "routeall"=>"http://api.vitelity.net/api.php",
     "getrate"=>"http://api.vitelity.net/api.php",
     "subaccounts"=>"http://api.vitelity.net/api.php",
     "failover"=>"http://api.vitelity.net/api.php",
     "callfw"=>"http://api.vitelity.net/api.php",
     "newvoicemail"=>"http://api.vitelity.net/api.php",
     "resetvoicemail"=>"http://api.vitelity.net/api.php",
     "listvoicemails"=>"http://api.vitelity.net/api.php",
     "addvoicemailtodid"=>"http://api.vitelity.net/api.php",
     "cnamenable"=>"http://api.vitelity.net/api.php",
     "cnamdisable"=>"http://api.vitelity.net/api.php",
     "cnamstatus"=>"http://api.vitelity.net/api.php",
     "addsubacc"=>"http://api.vitelity.net/api.php",
     "delsubacc"=>"http://api.vitelity.net/api.php",
     "lidbavail"=>"http://api.vitelity.net/api.php",
     "lidbcheck"=>"http://api.vitelity.net/api.php",
     "remvoicemail"=>"http://api.vitelity.net/api.php",
     "migratedids"=>"http://api.vitelity.net/api.php",
     "massreroute"=>"http://api.vitelity.net/api.php",
     "checksms"=>"http://api.vitelity.net/api.php",
     "removesms"=>"http://api.vitelity.net/api.php",
     "smsdids"=>"http://api.vitelity.net/api.php",
     "smsenableurl"=>"http://api.vitelity.net/api.php",
     "sendsms"=>"http://smsout-api.vitelity.net/api.php",
     "setsms"=>"http://api.vitelity.net/api.php",
     "smsenablehtt"=>"http://api.vitelity.net/api.php",
     "sendshort"=>"http://smsout-api.vitelity.net/api.php",
     "cnam"=>"http://api.vitelity.net/api.php",
     "npanxxlookup"=>"http://api.vitelity.net/api.php"}
  end

  def initialize(u,p)
    @username = u
    @password = p
  end

  def method_missing(*args)
    options = {
      :login => @username,
      :pass  => @password,
      :cmd   => args.shift,
      :xml   => :yes
    }
    unless self.commands[ options[:cmd].to_s ]
      raise "Invalid API Command: #{options[:cmd]}"
    end

    if args[0].is_a? Hash
      options.merge!(args[0])
    end
    res = RestClient.post(self.commands[ options[:cmd].to_s ], options)
    if res
      return Hash.from_xml(res)
    else
      raise "No data!"
    end
  end
end
