from xodb.net.broker import Broker, run


class ReadBroker(Broker):

    def handle_worker(self):
        """Handle a request from the front end, passing it to the backend. """
        client_addr, empty, request= self.frontend.recv_multipart()
        assert empty == ''
        
        # pop a worker, mark it busy.
        worker_name, worker_addr = self.workers.popitem(last=False)
        self.busy[worker_name] = client_addr, request, 0

        self.backend.send_multipart([worker_addr, "", client_addr, request])


if __name__ == "__main__":
    run('read_broker', ReadBroker)
