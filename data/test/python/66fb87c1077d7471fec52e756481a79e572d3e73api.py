from .. import *
from . import API_KEY, API_SECRET

from dnsmadeeasy.api import Headers, DNSMadeEasyAPI


@test
def Headers_items0():
    """Tests that all required keys are present in headers"""
    assert_eq(
        sorted(k for k, v in Headers(API_KEY, API_SECRET).items()),
        ['x-dnsme-apiKey', 'x-dnsme-hmac', 'x-dnsme-requestDate'])


@test
def Headers_items1():
    """Tests that the API key is correctly set"""
    assert_eq(
        dict(Headers(API_KEY, API_SECRET).items())['x-dnsme-apiKey'],
        API_KEY)


@test
def DNSMadeEasyAPI_dns_managed():
    """Tests that GET for dns/managed returns valid JSON"""
    r = DNSMadeEasyAPI(API_KEY, API_SECRET, True).dns.managed.GET()
    assert_eq(
        r.status_code,
        200)
    r.json()
