/**
 * Query API tests
 * @author Vincent Lecrubier <vincent.lecrubier@gmail.com>
 * @since  2015-04-19
 */

jest.dontMock('../queryApi.js');

describe('Query API', function() {
 it('fact(a,b,c)', function() {
   var api = require('../queryApi.js');
   expect(api.fact("a", "b","c")).toEqual({x:"fact",a:["a","b","c",true]});
 });
 it('fact(a,b,c,false)', function() {
   var api = require('../queryApi.js');
   expect(api.fact("a", "b","c",false)).toEqual({x:"fact",a:["a","b","c",false]});
 });
 it('the(thing)', function() {
   var api = require('../queryApi.js');
   expect(api.the("stuff")).toEqual({x:"var",a:["stuff"]});
 });
 it('and()', function() {
   var api = require('../queryApi.js');
   expect(api.and()).toEqual({x:"and",a:[]});
 });
 it('and(a)', function() {
   var api = require('../queryApi.js');
   expect(api.and("a")).toEqual({x:"and",a:["a"]});
 });
 it('and(a,b)', function() {
   var api = require('../queryApi.js');
   expect(api.and("a","b")).toEqual({x:"and",a:["a","b"]});
 });
 it('or()', function() {
   var api = require('../queryApi.js');
   expect(api.or()).toEqual({x:"or",a:[]});
 });
 it('or(a)', function() {
   var api = require('../queryApi.js');
   expect(api.or("a")).toEqual({x:"or",a:["a"]});
 });
 it('or(a,b)', function() {
   var api = require('../queryApi.js');
   expect(api.or("a","b")).toEqual({x:"or",a:["a","b"]});
 });
 it('not(a)', function() {
   var api = require('../queryApi.js');
   expect(api.not("a")).toEqual({x:"not",a:["a"]});
 });
 it('implies(a,b)', function() {
   var api = require('../queryApi.js');
   expect(api.implies("a","b")).toEqual({x:"or",a:[{x:"not",a:["a"]},"b"]});
 });
 it('equivalent(a,b)', function() {
   var api = require('../queryApi.js');
   expect(api.equivalent("a","b")).toEqual({x:"and",a:[{x:"or",a:[{x:"not",a:["a"]},"b"]},{x:"or",a:[{x:"not",a:["b"]},"a"]}]});
 });
});
