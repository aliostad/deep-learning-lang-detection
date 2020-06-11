'use strict';

/* ------------------------------------------------------------------------------------
  SERVICES 
------------------------------------------------------------------------------------- */

/* CALCULATOR SERVICE */ 

templates.service('CalculatorService', function(MathService){

  this.square = function(a) { return MathService.multiply(a,a); };

  this.cube = function(a) { return MathService.multiply(a, MathService.multiply(a,a)); };
})

/* MATH SERVICE */

templates.service('MathService', function() {
  
  this.add = function(a, b) { return a + b };
   
  this.subtract = function(a, b) { return a - b };
   
  this.multiply = function(a, b) { return a * b };
   
  this.divide = function(a, b) { return a / b };
})



