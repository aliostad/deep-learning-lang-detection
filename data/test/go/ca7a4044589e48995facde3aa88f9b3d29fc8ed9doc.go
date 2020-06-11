/*Package broker Service Broker API

The Cloud Foundry services API defines the contract between the Cloud Controller and the service broker. The broker is expected to implement several HTTP (or HTTPS) endpoints underneath a URI prefix. One or more services can be provided by a single broker, and load balancing enables horizontal scalability of redundant brokers. Multiple Cloud Foundry instances can be supported by a single broker using different URL prefixes and credentials. [Learn more about the Service Broker API.](http://docs.cloudfoundry.org/services/api.html)


    Schemes:
      http
    Host: localhost
    BasePath: /v2
    Version: 2.8

    Consumes:
    - application/json


    Produces:
    - application/json


swagger:meta
*/
package broker
