DCTLogEnabled = {'client':['dct_client.reg'],'agent':['dct_agent.reg']}
ThinPrintLogEnabled = {'client':['thinprint_client.reg'],'agent':['thinprint_agent.reg']}
BlastLogEnabled = {'agent':['blast_agent.reg']}
H264LogEnabled = {'agent':['h264_agent.reg']}
# Define log source dirs
DCTLogDir = {'client':['C:\\Users\\<username>\\AppData\\Local\\VMware\\VDM\\logs','C:\\Users\\<username>\\AppData\\Local\\Temp\\vmware-<username>','C:\\ProgramData\\VMware\\VDM\\logs'],
             'agent':['C:\\ProgramData\\VMware\\VDM\\logs','C:\\ProgramData\\VMware\\VMware Blast']}
ThinPrintLogDir = {'client':['C:\\Temp',],
                   'agent':['C:\\Temp',]}
USBArbitratorDir = {'client':['C:\\Windows\\Temp\\vmware-SYSTEM']}

BrokerLogDir = {'broker':['C:\\Program Files\\VMware\\VMware View\\Server\\broker\\logs']}

LogDirs = {'client':
               set(DCTLogDir['client'] + ThinPrintLogDir['client'] + USBArbitratorDir['client']),
           'agent':
               set(DCTLogDir['agent'] + ThinPrintLogDir['agent']),
           'broker':
               set(BrokerLogDir['broker'])}

