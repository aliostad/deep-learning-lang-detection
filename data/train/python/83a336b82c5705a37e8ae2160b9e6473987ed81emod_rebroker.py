import threading

def run_rules_engine():
    if CONTEXT['dry_run']:
        LOGGER.info('(dry run) RULES_ENGINE_NODES: %s' % CONTEXT['RULES_ENGINE_NODES'])
        return
    threads = []
    today = int(round(time.mktime(CONTEXT['today'].timetuple())))

    all_network_list = []
    for node in CONTEXT['RULES_ENGINE_NODES']:
        all_network_list.extend(node['networks'])
        broker = RulesEngineBroker(LOGGER, node['host'], node['port'], CONFIG, today)
        threads.append(broker)
    
    #use Distributer_Broker to manage broker_list(threads)
    lock = threading.Lock()
    distributer = Distributer_Broker(all_network_list,threads,lock)    
    distributer.work()

    errors = distributer.errors
    
    if errors: # Rules Engine returns -1
        for error in errors:
            LOGGER.error(error)
        if CONFIG.has_key('SEND_NOTIFICATION_TO'):
            send_notification_mail(to_addrs=CONFIG['SEND_NOTIFICATION_TO'], body='\n'.join(errors))
    
    
    if distributer.failed_networks and CONTEXT['env'] == 'prd': # Rules Engine crashes
        to_addrs = 'Eng-Core-RPM'
        cc_addrs = 'Eng-RPMA'
        subject = 'Rules Engine Module %s Fail Notification @%s' % (CALCULATION_MODULE.title(), CONTEXT['today'])
        body = '''Hi all,\n\nSorry to inform you that Rules Engine failed during today's daily job.\n\nImpacted networks:\n%s\n\nThis email is sent automatically to give a head-up in time, and Eng will investigate and update ASAP.\n\nSorry for the inconvenience.\n\nThanks,\nRules Engine''' % '\n'.join(map(str, failed_networks))
        send_mail(to_addrs, cc_addrs, subject, body, 'plain')

    LOGGER.info('All rules engine instance(s) job done, res = %s', CONTEXT['plans'])




class Distributer_Broker():
    def __init__(self, network_list,broker_list,lock):
        global g_network_list
        g_network_list = network_list
        self.broker_list = broker_list
        self.lock = lock                       #for broker to lock when fetch a network in network_list
        self.failed_networks = set()
        self.errors = []

    def work(self):
        broker_num = len(self.broker_list)
        while g_network_list:
            for i in range(broker_num):   
                if self.broker_list[i].isAlive():
                    continue
                #one broker finished its single network. collect its error if it failed.    
                if self.broker_list[i].failed_network:
                    self.failed_networks = self.failed_networks.add(self.broker_list[i].failed_network)
                    if not self.broker_list[i].data:
                        self.errors.append('Rules engine %s failed' % self.broker_list[i].host)
                    else:
                        plan = self.broker_list[i].data
                        network = plan['network_id']
                        version = plan['plan_version'].get(CALCULATION_MODULE, -1)
                        if version > 0:
                            CONTEXT['plans'][network] = version
                        else:
                            errors.append('Rules engine %s Module for network %d failed' 
                                % (self.broker_list[i].host, network))

                #setup for a new network-task
                host, port = self.broker_list[i].get_host_port()  
                today = int(round(time.mktime(CONTEXT['today'].timetuple())))
                self.broker_list[i] = RulesEngineBroker(LOGGER, host, port, CONFIG, today, self.lock)  #here to different config
                self.broker_list[i].start()
                break                      #break for-loop to recheck g_network_list is.empty()

            #sleep a while for not monitor too frequently?


def distributer_broker(broker_list)
    broker_num = len(broker_list)
    failed_networks = set()
    errors = []
    lock = threading.Lock()
    
    while g_network_list:
        for i in range(broker_num):   
            if broker_list[i].isAlive():
                continue
            #one broker finished its single network. collect its error if it failed.    
            if broker_list[i].failed_network:
                failed_networks = failed_networks.add(broker_list[i].failed_network)
                if not broker_list[i].data:
                    errors.append('Rules engine %s failed' % broker_list[i].host)
                else:
                    plan = broker_list[i].data
                    network = plan['network_id']
                    version = plan['plan_version'].get(CALCULATION_MODULE, -1)
                    if version > 0:
                        CONTEXT['plans'][network] = version
                    else:
                        errors.append('Rules engine %s Module for network %d failed' 
                            % (broker_list[i].host, network))

            #setup for a new network-task
            host, port = broker_list[i].get_host_port()  
            today = int(round(time.mktime(CONTEXT['today'].timetuple())))
            broker_list[i] = RulesEngineBroker(LOGGER, host, port, CONFIG, today, lock)  #here to different config
            broker_list[i].start()
            break                      #break for-loop to recheck g_network_list is.empty()
        #sleep a while for not monitor too frequently?

    return failed_networks,errors



class RulesEngineBroker(threading.Thread):
    """
    one broker handle one network.
    """
    def __init__(self, logger, host, port, config, today,lock):
        threading.Thread.__init__(self)
        self.logger = logger
        self.host = host
        self.port = port
        self.data = []
        self.config = config
        self.failed_network = ""   
        self.today = today
        self.lock = lock   #lock for fetch_one_network

    def get_host_port(self):
        return self.host,self.port

    def fetch_one_network(self):
        """
        fetch one network from global network_list
        """
        if g_network_list:
            target = g_network_list[0]
            del g_network_list[0]
            return target
        else:
            return ""

    def fetch_one_network_with_lock(self):
        self.lock.acquire()
        target = self.fetch_one_network()
        self.lock.release()
        return target


    def run(self):
        network  = self.fetch_one_network_with_lock()
        if not network:
            return 

        mrm_oltp_conn = fwdb.connect(**self.config['MRM_OLTP'])
        mrm_oltp_conn.set_autocommit(1)
        mrm_oltp_curs = mrm_oltp_conn.cursor()
        status_conn = fwdb.connect(**self.config['RPM_CTL'])
        status_conn.set_autocommit(1)
        status_curs = status_conn.cursor()
        rpt_conn = fwdb.connect(**self.config['RPM_RPT'])
        rpt_conn.set_autocommit(1)
        rpt_curs = rpt_conn.cursor()

        #for network in self.network_list:
        start_time = datetime.datetime.now()
        status_curs.execute('''update system_statistics set current_start_time = '%s' where network_id = %s and name = 'RPM %s Rules Engine' ''' % (start_time.strftime('%F %T'), network, CALCULATION_MODULE.title()))

        url = 'http://%s:%s/dispatch?sys=payment&command=engine::run_plan&network_id=%s&modules=%s&today=%s' % (self.host, self.port, network, CALCULATION_MODULE, self.today)
        self.run_once(url, network)
        rpt_curs.execute('''update h_collected_event set is_calculated = 1 where network_id = %s and is_calculated = 0''' % network)


    def run_once(self, url, network):
        self.logger.info('Start rules engine %s' % url)
        try:
            req = urllib2.Request(url=url, headers={'User-Agent':'FreeWheel RPM Daily Job'})
            conn = urllib2.urlopen(req)
            res = conn.read()
            self.logger.info('Rules engine %s returns %s' % (url, res))
            conn.close()
            self.data.extend(json.loads(res))
        except (urllib2.HTTPError, urllib2.URLError, Exception), e:
            # if error, mark failed_network
            self.failed_network = network
            self.logger.error('Rules engine %s failed, error = %s' % (url, e))