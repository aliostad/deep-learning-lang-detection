"use strict";

var assert = require("assert");
var schlub = require("../src/schlub");

describe("schlub", function() {
    it("should be an object", function() {
        assert.ok(typeof schlub === "object", "not an object");
        assert.ok(schlub !== null, "null");
    });

    describe("api", function() {
        function ServiceA() {
            this.name = "service a";
        }

        function ServiceB(serviceA) {
            this.name = "service b";
            this.serviceA = serviceA;
        }

        function ServiceB2() {
            this.name = "service b2";
        }

        function ServiceC(serviceA, serviceB) {
            this.name = "service c";
            this.serviceA = serviceA;
            this.serviceB = serviceB;
        }

        function ServiceD() {
            this.name = "service d";
        }

        function ServiceE(serviceA, serviceB, arg1, arg2) {
            this.name = "service e";
            this.serviceA = serviceA;
            this.serviceB = serviceB;
            this.arg1 = arg1;
            this.arg2 = arg2;
        }

        function ServiceF(serviceA) {
            this.name = "service f";
            this.serviceA = serviceA;
        }

        schlub.point("serviceA", function() {
            return new ServiceA();
        });

        schlub.point("serviceB/typeA", ["serviceA"],
            function(serviceA) {
                return new ServiceB(serviceA);
            }
        );

        schlub.point("serviceB/typeB", function() {
            return new ServiceB2();
        });

        schlub.point("serviceC", ["serviceA", "serviceB/typeA"],
            function(serviceA, serviceB) {
                return new ServiceC(serviceA, serviceB);
            }
        );

        schlub.point("serviceD", function() {
            return new ServiceD();
        });

        schlub.point("serviceD/typeA/instance", new ServiceD());

        schlub.point("serviceE", ["serviceA", "serviceB/typeB"],
            function(serviceA, serviceB, arg1, arg2) {
                return new ServiceE(serviceA, serviceB, arg1, arg2);
            }
        );

        schlub.point("serviceF", ["serviceA"],
            function(serviceA) {
                return new ServiceF(serviceA);
            },
            { singleton: true });

        describe("#get", function() {
            it("can get a service with no dependencies", function() {
                var serviceA = schlub.get("serviceA");

                assert.equal(serviceA.name, "service a", "did not get service a");
            });

            it("can get a service under a directory", function() {
                var serviceB2 = schlub.get("serviceB/typeB");

                assert.equal(serviceB2.name, "service b2", "did not get service b2");
            });

            it("can get all services under a directory", function() {
                let services = schlub.get({ type: "serviceB/*", allowMultiple: true });
                let found = 0;

                assert.equal(services.length, 2, "should be two services");

                for (let i = 0; i < services.length; i++) {
                    switch (true) {
                        case services[i] instanceof ServiceB:
                            found += 2;
                            break;
                        case services[i] instanceof ServiceB2:
                            found += 4;
                            break;
                    }
                }

                assert.equal(found, 6, "did not get all services");
            });

            it("can get a service with a single dependency", function() {
                var serviceB = schlub.get("serviceB/typeA");

                assert.equal(serviceB.name, "service b", "got service b");
                assert.equal(serviceB.serviceA.constructor, ServiceA, "service b did not get ServiceA dependency");
            });

            it("can get a service with a deep dependency tree", function() {
                var serviceC = schlub.get("serviceC");

                assert.equal(serviceC.name, "service c", "instantiated service c");
                assert.equal(serviceC.serviceA.constructor, ServiceA, "service c did not get ServiceA dependency");
                assert.equal(serviceC.serviceB.constructor, ServiceB, "service c did not get ServiceB dependency");
            });

            it("allows none when getting", function() {
                assert.doesNotThrow(function() {
                    assert.strictEqual(schlub.get({ type: "foo", allowNone: true }), null, "did not allow none");
                }, "did not allow none");
            });

            it("throws when none", function() {
                assert.throws(function() {
                    schlub.get("foo");
                });
            });

            it("throws when multiple", function() {
                assert.throws(function() {
                    schlub.get("serviceB/*");
                });
            });

            it("get registered instance", function() {
                var serviceDInstance = schlub.get("serviceD/typeA/instance");

                assert.equal(serviceDInstance.name, "service d", "did not get service d instance");
            });

            it("registering triggers register event", function() {
                var serviceD = new ServiceD();
                var triggered = false;

                schlub.once("register", function(type, service) {
                    assert.equal(type, "serviceD/typeA/instance", "triggered event did not have serviceD/typeA/instance");
                    assert.equal(service, serviceD, "triggered event did not contain the service");
                    triggered = true;
                });
                schlub.point("serviceD/typeA/instance", serviceD);
                assert.ok(triggered, "event wasn't triggered");
            });

            it("pass in dependency", function() {
                var serviceA = schlub.get("serviceA");
                var serviceB = schlub.get("serviceB/typeA", [serviceA]);

                assert.ok(serviceB.serviceA === serviceA, "serviceA isn't the same");
            });

            it("pass in constructor args", function() {
                var arg1 = "this is arg1";
                var arg2 = "this is arg2";
                var serviceE = schlub.get("serviceE", [], [arg1, arg2]);

                assert.equal(serviceE.name, "service e", "wrong service");
                assert.equal(serviceE.serviceA.constructor, ServiceA, "service e got wrong ServiceA dependency");
                assert.equal(serviceE.serviceB.constructor, ServiceB2, "service e got wrong ServiceB dependency");

                assert.equal(serviceE.arg1, arg1, "arg1 is incorrect");
                assert.equal(serviceE.arg2, arg2, "arg2 is incorrect");
            });

            it("pass in specific dependency of multiple dependencies", function() {
                var serviceB = schlub.get("serviceB/typeA");
                var serviceC = schlub.get("serviceC", [null, serviceB]);

                assert.equal(serviceC.name, "service c", "instantiated service c");
                assert.equal(serviceC.serviceA.constructor, ServiceA, "service c got ServiceA dependency");
                assert.ok(serviceC.serviceB === serviceB, "serviceB isn't the same");
            });

            it("pass in specific dependency of multiple dependencies and constructor args", function() {
                var arg1 = "this is arg1";
                var arg2 = "this is arg2";
                var serviceB = schlub.get("serviceB/typeA");
                var serviceE = schlub.get("serviceE", [null, serviceB], [arg1, arg2]);

                assert.equal(serviceE.name, "service e", "wrong service");
                assert.equal(serviceE.serviceA.constructor, ServiceA, "service e got wrong ServiceA dependency");
                assert.ok(serviceE.serviceB === serviceB, "serviceB isn't the same");

                assert.equal(serviceE.arg1, arg1, "arg1 is incorrect");
                assert.equal(serviceE.arg2, arg2, "arg2 is incorrect");
            });

            it("returns the same singleton", function() {
                var serviceF1 = schlub.get("serviceF");
                var serviceF2 = schlub.get("serviceF");

                assert.strictEqual(serviceF2, serviceF1, "serviceF is not a singleton");
            });

            it("returns a different instance of a singleton when asked", function() {
                var serviceF1 = schlub.get("serviceF");
                var serviceF2 = schlub.get({ type: "serviceF", newInstance: true });

                assert.ok(serviceF1 !== serviceF2, "serviceF didn't return a new instance");
            });
        });

        describe("#forget", function() {
            it("can forget all of a type", function() {
                let a = {};
                let b = {};

                schlub.point("forget/foo", a);
                schlub.point("forget/foo", b);

                let services = schlub.get({ type: "forget/foo", allowMultiple: true });

                assert.equal(services.length, 2, "services weren't registered");

                schlub.forget("forget/foo");

                services = schlub.get({ type: "forget/foo", allowNone: true });

                assert.strictEqual(services, null, "services weren't forgotten");
            });
        });
    });
});
