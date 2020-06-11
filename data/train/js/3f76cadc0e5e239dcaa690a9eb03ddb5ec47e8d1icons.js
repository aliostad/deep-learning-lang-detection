
var show_shuiku=1;
var show_hedao=1;	
var citys=1;
function hedao()
{
	if(show_hedao==1)
	{
	marker2.hide();
	marker3.hide();
	marker4.hide();
	marker5.hide();
	marker6.hide();
	marker7.hide();
	marker8.hide();
	marker10.hide();
	show_hedao=0;
	}
	else
	{
	marker2.show();
	marker3.show();
	marker4.show();
	marker5.show();
	marker6.show();
	marker7.show();
	marker8.show();
	marker10.show();
	show_hedao=1;
	}
}
function shuiku()
{
	if(show_shuiku==1)
	{
	marker11.hide();
	marker12.hide();
	marker13.hide();
	marker15.hide();
	marker16.hide();
	marker17.hide();
	show_shuiku=0;
	}
	else
	{
	marker11.show();
	marker12.show();
	marker13.show();
	marker15.show();
	marker16.show();
	marker17.show();
	show_shuiku=1;
	}
}