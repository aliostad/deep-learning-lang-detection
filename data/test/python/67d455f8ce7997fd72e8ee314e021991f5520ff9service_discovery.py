from __future__ import absolute_import
import dns.resolver


class ServiceFinder(object):
    RESOLVER = dns.resolver.Resolver()

    @classmethod
    def broker_url(cls, domain):
        return cls._get_broker_url(domain, 0)

    @classmethod
    def broker_input_url(cls, domain):
        return cls._get_broker_url(domain, 1)

    @classmethod
    def _get_broker_url(cls, domain, port_offset):
        a = cls.RESOLVER.query('_thingsbus._tcp.%s' % domain, 'SRV')
        rr = a.rrset[0]

        # TODO actually do the priority and weight SRV record thing

        return 'tcp://%s:%d' % (rr.target.to_text(), rr.port + port_offset)
