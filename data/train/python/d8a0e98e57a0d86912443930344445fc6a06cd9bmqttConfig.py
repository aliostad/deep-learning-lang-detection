class config():      
    MsgPrefix  = '<'  #string to send at the start of each message   
    timeStamp  = 'LocalTime'  #append time stamp, options are 'LocalTime','UTCTime', or 'None' if no timestamp is wanted
    smoothData = 3    # samples to average
    mqtt    = {
                'Broker':'192.168.1.4',  
                #'Broker':'iot.eclipse.org',
                #'Broker':'test.mosquitto.org',                  
                'Topic' :'VicaSimple/Hastings'
              }
   
    streams = [          
                ({'stream':1, 'type':int, 'scale':(0,767,0,255)}),
                ({'stream':2, 'type':int, 'scale':(-64,64,0,255)})
                #({'stream':1}),
                #({'stream':2})
               ]