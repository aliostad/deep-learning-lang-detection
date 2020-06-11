# Copyright 2015, Rob Lyon <nosignsoflifehere@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import pigs
import gevent
import signal

class MyJob(pigs.Job):
    def run(self):
        import time
        from random import randrange
        time.sleep(randrange(5,20))

class MyProcessor:
    @staticmethod
    def start_worker():
        worker = pigs.Worker()
        worker.connect()
        worker.start()

    @staticmethod
    def start_broker():
        # Instantiate the broker and connect
        broker = pigs.Broker()
        broker.connect()

        # Submit the jobs to the broker
        for i in xrange(1,1000):
            broker.submit(MyJob())

        # Start processing
        broker.start()

# Start up the brokers and workers
worker1 = gevent.spawn(MyProcessor.start_worker)
worker2 = gevent.spawn(MyProcessor.start_worker)
worker3 = gevent.spawn(MyProcessor.start_worker)
worker4 = gevent.spawn(MyProcessor.start_worker)
broker = gevent.spawn(MyProcessor.start_broker)

gevent.joinall([
    broker,
    worker1,
    worker2,
    worker3,
    worker4
])
