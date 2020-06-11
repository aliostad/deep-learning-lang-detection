
from Versa_Common import *

with open(r'c:\ProgramData\QualiSystems\Shells.log', 'a') as f:
    f.write(time.strftime('%Y-%m-%d %H:%M:%S') + ': ' + __file__.split('\\')[-1].replace('.py', '') + ': ' + str(os.environ) + '\r\n')


resource = json.loads(os.environ['RESOURCECONTEXT'])
resource_name = resource['name']
attrs = resource['attributes']

# General VM config
datastore = attrs['Versa Datastore']
thick_thin = attrs['Versa Disk Mode']
vcenter_user = attrs['vCenter Administrator User']
vcenter_password = attrs['vCenter Administrator Password']
vcenter_ip = attrs['vCenter IP']
datacenter = attrs['Versa Datacenter']
cluster = attrs['Versa Cluster']


# Controller config
# eth 0
controller_portgroup = attrs['Versa Controller NB Portgroup Name']
controller_vmname = attrs['Versa Controller VM Name']
controller_ova_path = attrs['Versa Controller Path']
controller_ip = attrs['Versa Controller NB IP']
controller_dns = attrs['Versa Controller NB DNS']
controller_mask = attrs['Versa Controller NB Mask']
controller_gateway = attrs['Versa Controller NB Gateway']
controller_eth = 'eth0'
# eth 1
controller_1_portgroup = attrs['Versa Controller SB Portgroup Name']
controller_1_ip = ''
controller_1_dns = ''
controller_1_mask = ''
controller_1_gateway = ''
controller_1_eth = 'eth1'
# eth 2
controller_2_portgroup = attrs['Versa Controller SDWAN Portgroup Name']
controller_2_ip = ''
controller_2_dns = ''
controller_2_mask = ''
controller_2_gateway = ''
controller_2_eth = 'eth2'

controller = {
    controller_eth: (controller_ip,controller_portgroup,controller_mask,controller_gateway,controller_dns),
    controller_1_eth: (controller_1_ip,controller_1_portgroup,controller_1_mask,controller_1_gateway,controller_1_dns),
    controller_2_eth: (controller_2_ip,controller_2_portgroup,controller_2_mask,controller_2_gateway,controller_2_dns)
}
dv_switch = str(attrs['Versa SB VDS'])
dv_switchsdwan = str(attrs['Versa SDWAN VDS'])
vds1_num_ports = '128'
vds1_vlanmode = 'none'
vds1_vlan_ids = '0'

try:
    vcenterparams = {
        'IP': vcenter_ip,
        'user': vcenter_user,
        'password': vcenter_password}

    # Set VC session
    session = Vcenter(vcenterparams)
    session.add_dvPort_group(dv_switch, controller_1_portgroup, int(vds1_num_ports), vds1_vlanmode, vds1_vlan_ids)
    session.add_dvPort_group(dv_switchsdwan, controller_2_portgroup, int(vds1_num_ports), vds1_vlanmode, vds1_vlan_ids)
except:
    pass
# Deploy Controller
try:
    command = '--skipManifestCheck --noSSLVerify  --allowExtraConfig --datastore=' + '"' + datastore + '"' + ' --acceptAllEulas --diskMode=' + thick_thin + ' --net:"VM Network"="' + controller_portgroup + '" --name="' + controller_vmname + '" "' + controller_ova_path + '" "vi://' + vcenter_user + ':"' + vcenter_password + '"@' + vcenter_ip + '/' + datacenter + '/host/' + cluster + '/Resources"'
    deployVM(command, controller_vmname, vcenter_ip, vcenter_user, vcenter_password, False)
    time.sleep(5)
    vmPower(controller_vmname, 'start', vcenter_ip, vcenter_user, vcenter_password)
except Exception, e:
    print '\r\n' + str(e)
    sys.exit(1)

loop = 10
script = '\'cat /etc/network/interfaces\''
time.sleep(30)

try:
    controller = setAdapterMAC(controller_vmname, controller, vcenter_ip, vcenter_user, vcenter_password)
    while loop > 0:
        firstNFVEth(controller_vmname, 'admin', 'versa123', controller, 20, 30, vcenter_ip, vcenter_user, vcenter_password)
        ans = invokeScript(script, controller_vmname, 'admin', 'versa123', 20, 30, vcenter_ip, vcenter_user, vcenter_password)
        if 'EOF' in ans:
            loop = 0
        else:
            loop -= 1
    addNFVAdapter(controller_vmname, controller, vcenter_ip, vcenter_user, vcenter_password)
    vmPower(controller_vmname, 'restart', vcenter_ip, vcenter_user, vcenter_password)
except Exception, e:
    print e
