'use strict';

describe('Calculator Service', function () {

    var service;

    beforeEach(function () {
        service = new CalculatorService();
    });

    it('should display 0 when loaded', function () {
        expect(service.getDisplay()).toEqual('0');
    });

    it('should display 15 when calculate 12 + 3', function () {
        service.enterDigit('one');
        expect(service.getDisplay()).toEqual('1');
        service.enterDigit('two');
        expect(service.getDisplay()).toEqual('12');
        service.enterOperation('+');
        expect(service.getDisplay()).toEqual('12');
        service.enterDigit('three');
        expect(service.getDisplay()).toEqual('3');
        service.enterEquals();
        expect(service.getDisplay()).toEqual('15');
    });

    it('should automatic enter when chain operation : 12 + 3 % 5', function () {
        service.enterDigit('one');
        expect(service.getDisplay()).toEqual('1');
        service.enterDigit('two');
        expect(service.getDisplay()).toEqual('12');
        service.enterOperation('+');
        expect(service.getDisplay()).toEqual('12');
        service.enterDigit('three');
        expect(service.getDisplay()).toEqual('3');
        service.enterOperation('%');
        expect(service.getDisplay()).toEqual('15');
        service.enterDigit('five');
        expect(service.getDisplay()).toEqual('5');
        service.enterEquals();
        expect(service.getDisplay()).toEqual('0');
    });

    it('should handle dot : 5 / 2 = 2.5', function () {
        service.enterDigit('five');
        expect(service.getDisplay()).toEqual('5');
        service.enterOperation('/');
        expect(service.getDisplay()).toEqual('5');
        service.enterDigit('two');
        expect(service.getDisplay()).toEqual('2');
        service.enterEquals();
        expect(service.getDisplay()).toEqual('2.5');
    });

    it('should handle decimal on enterDot() : 12.34 + 1', function () {
        service.enterDigit('one');
        expect(service.getDisplay()).toEqual('1');
        service.enterDigit('two');
        expect(service.getDisplay()).toEqual('12');
        service.enterDot();
        expect(service.getDisplay()).toEqual('12');
        service.enterDigit('three');
        expect(service.getDisplay()).toEqual('12.3');
        service.enterDigit('four');
        expect(service.getDisplay()).toEqual('12.34');
        service.enterOperation('+');
        expect(service.getDisplay()).toEqual('12.34');
        service.enterDigit('one');
        expect(service.getDisplay()).toEqual('1');
        service.enterEquals();
        expect(service.getDisplay()).toEqual('13.34');
    });

    //this test case will always fail
    it('should display 12345 when loaded', function () {
      expect(service.getDisplay()).toEqual('12345');
    });

});

