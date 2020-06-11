function Service()
{
this.ServiceId="";
this.ServiceName="";
this.Description="";

}

Service.prototype.setService = function(ServiceId_,ServiceName_,Description_)
{
this.ServiceId=ServiceId_;
this.ServiceName=ServiceName_;
this.Description=Description_;

},

Service.prototype.createServicePacket = function()
{
	var packet = "";	
	packet += this.ServiceId+";";
	packet += this.ServiceName+";";
	packet += this.Description;

	return packet;
}


Service.prototype.getServiceData = function()
{
	var packet = "";	
	packet += this.ServiceId+";";
	packet += this.ServiceName+";";
	packet += this.Description;

	return packet;
}

