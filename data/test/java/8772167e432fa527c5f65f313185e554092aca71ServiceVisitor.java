/*
 * 
 */
package cscie97.asn4.squaredesk.authentication;

/**
 * The Class ServiceVisitor.
 */
public abstract class ServiceVisitor {
        
        /**
         * Instantiates a new service visitor.
         *
         * @param service the service
         */
        public ServiceVisitor(Service service) {
                super();
        }

        /**
         * Visit service list.
         */
        public void visitServiceList(){
                for(Service service : AuthenticationService.getServices()){
                        beforeVisitService(service);
                        visitService(service);
                        afterVisitService(service);
                }
        }

        /**
         * Before visit service.
         *
         * @param service the service
         */
        public void beforeVisitService(Service service) {
                System.out.println("Beginning service Visit.. " + service.getServiceId());
        }

        /**
         * After visit service.
         *
         * @param service the service
         */
        public void afterVisitService(Service service) {
                System.out.println("Ending service Visit.. " + service.getServiceId());

        }

        /**
         * Visit service.
         *
         * @param service the service
         */
        public void visitService(Service service) {
                //this is overridden by the client
                System.out.println("At service visit.. " + service.getServiceId());
        }
}
