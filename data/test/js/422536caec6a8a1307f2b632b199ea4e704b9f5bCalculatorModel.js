function Calculator() {

    var facade = new Facade();
        
    this.add = function (operand1, operand2, showResponse) {
	
        facade.action(operand1, operand2, "add", showResponse);
	};	
	
	  this.subtract = function (operand1, operand2, showResponse) {
	
        facade.action(operand1, operand2, "subtract", showResponse);
	};	
	
	  this.multiply = function (operand1, operand2, showResponse) {
	
        facade.action(operand1, operand2, "multiply", showResponse);
	};	
	
	  this.divide = function (operand1, operand2, showResponse) {
	
        facade.action(operand1, operand2, "divide", showResponse);
	};	
	    
	return this;	
}