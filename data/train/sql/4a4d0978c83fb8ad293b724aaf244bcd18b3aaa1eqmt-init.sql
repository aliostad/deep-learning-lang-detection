-- Copyright (c) 2003 by Jeff Weisberg
-- Author: Jeff Weisberg <jaw @ tcp4me.com>
-- Date: 2003-May-03 14:24 (EDT)
-- Function: 
--
-- $Id: eqmt-init.sql,v 1.7 2010/01/15 18:13:19 jaw Exp $


select mi_g_object_type__new( 'eqmt/facility',
			   'eqmt/view-facility',
			   'mi_facility',
			   'fac_id',
			   'mi_facility_name',
			   NULL,
			   NULL );

select mi_g_object_type__new( 'eqmt/eqmt',
			   'eqmt/view-eqmt',
			   'mi_eqmt',
			   'eqmt_id',
			   'mi_eqmt_name',
			   NULL,
			   NULL );

select mi_g_object_type__new( 'eqmt/iface',
			   'eqmt/view-iface',
			   'mi_interface',
			   'iface_id',
			   'mi_iface_name',
			   NULL,
			   NULL);

select mi_fac_type__new( 'telco CO' );
select mi_fac_type__new( 'colo facility' );
select mi_fac_type__new( 'server room' );
select mi_fac_type__new( 'office' );
select mi_fac_type__new( 'other' );

select mi_hw_type__new('unk',  'unknown');
select mi_hw_type__new('srvr', 'server');
select mi_hw_type__new('gw',   'router');
select mi_hw_type__new('sw',   'ethernet switch');
select mi_hw_type__new('csu',  'csu/dsu');
select mi_hw_type__new('chbk', 'channel bank');
select mi_hw_type__new('mux',  'circuit mux');
select mi_hw_type__new('lb',   'load balancer');
select mi_hw_type__new('fw',   'firewall');
select mi_hw_type__new('hub',  'ethernet hub');
select mi_hw_type__new('fr',   'frame switch');
select mi_hw_type__new('atm',  'atm switch');
select mi_hw_type__new('cvtr', 'media converter');
select mi_hw_type__new('wkst', 'desktop computer');
select mi_hw_type__new('opsw', 'optical switch');
select mi_hw_type__new('opmx', 'optical mux');
select mi_hw_type__new('dax',  'digital cross connect');
select mi_hw_type__new('lptp', 'laptop');
select mi_hw_type__new('pda',  'pda');
select mi_hw_type__new('ts',   'terminal server');
select mi_hw_type__new('pwr',  'power strip');
select mi_hw_type__new('wap',  'wireless access point');
select mi_hw_type__new('nas',  'network attached storage');
select mi_hw_type__new('dpy',  'display system');
select mi_hw_type__new('tele', 'telephone');


select mi_manufacturer__new( 'unknown');
select mi_manufacturer__new( 'cisco' );
select mi_manufacturer__new( 'lucent' );
select mi_manufacturer__new( 'sun' );
select mi_manufacturer__new( 'intel' );
select mi_manufacturer__new( 'dell' );
select mi_manufacturer__new( '3com' );
select mi_manufacturer__new( 'HP' );
select mi_manufacturer__new( 'juniper' );
select mi_manufacturer__new( 'bay' );
select mi_manufacturer__new( 'adtran' );
select mi_manufacturer__new( 'generic pc' );
select mi_manufacturer__new( 'nortel' );


select mi_importance__new( 'ghetto',	10 );
select mi_importance__new( 'normal',	20 );
select mi_importance__new( 'special - VIP',30 );
select mi_importance__new( 'critical',	40 );

select mi_eqmt_status__new( 'pending install' );
select mi_eqmt_status__new( 'active' );
select mi_eqmt_status__new( 'pending termination' );
select mi_eqmt_status__new( 'decommsioned' );
select mi_eqmt_status__new( 'out for repair' );

select mi_operating_system__new( 'Solaris' );
select mi_operating_system__new( 'NetBSD' );
select mi_operating_system__new( 'FreeBSD' );
select mi_operating_system__new( 'OpenBSD' );
select mi_operating_system__new( 'Linux/RedHat' );
select mi_operating_system__new( 'Linux/Debian' );
select mi_operating_system__new( 'Linux/Suse' );
select mi_operating_system__new( 'Linux/Other' );
select mi_operating_system__new( 'Windows' );
select mi_operating_system__new( 'HP-UX' );
select mi_operating_system__new( 'Irix' );
select mi_operating_system__new( 'BeOS' );
select mi_operating_system__new( 'MacOS' );
select mi_operating_system__new( 'ComOS' );
select mi_operating_system__new( 'IOS' );
select mi_operating_system__new( 'JunOS' );


