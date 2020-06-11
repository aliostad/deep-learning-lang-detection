/*
	SlideShow banerow wraz z funckją inicjujaca.
	Kraków 2010-02-05
*/

  jQuery.fn.log = function (msg) {
      console.log("%s: %o", msg, this);
      return this;
  };

var slideShow={
	banners:null,
	timer:null,
	interval:3000,
	current:0,
	max:0,
	_allow:true,
	
	showNext:function(){
	if(this._allow){
		
		this.timer=setTimeout("slideShow.renderEffect()",slideShow.interval);
		this.current++;
		if(this.current>=this.max){this.current=0}
	}
	},
		
	renderEffect:function(){
		slideShow.points.removeClass("active").eq(slideShow.current).addClass("active");
		if(slideShow.current==0){
			slideShow.banners.eq(0).show();
			slideShow.banners.not(":first, :last").hide();
			slideShow.banners.eq(slideShow.max-1).fadeOut(2000,function(){slideShow.showNext()})
		}
		else{
			slideShow.banners.eq(slideShow.current).fadeIn(2000,function(){slideShow.showNext()})
		}
	},
		
	init:function(){
		this.banners=$('.pictures .banners li');
		this.max=this.banners.length;
		if(this.max){if(this.max>1){
			this.banners.not(":first").hide();
			this.showNext()
			}
		}
		this.points=$('.pictures .items li');	
		$('.pictures .items li a').click(function(){
			slideShow.current=parseInt(this.innerHTML)-1;
			slideShow.points.removeClass("active").eq(slideShow.current).addClass("active");
			slideShow.banners.not(slideShow.current).hide();
			slideShow.banners.eq(slideShow.current).show();
			
		})
			
	},

	toggle:function(){
		if(this.timer){
			clearTimeout(this.timer);
			this.timer=null;
			this._allow=false
		}else{
			this.timer=setTimeout("slideShow.renderEffect()",this.interval);
			this._allow=true}
		}
	};

$(document).ready(function(){
	$('.pictures .banners').show(1500);	
	slideShow.init()
})
