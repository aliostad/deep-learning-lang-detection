var NavigationManager = {
    jNavLeft:null,
    jNavRight:null,
    jNavMap:null,
    init:function() {
        this.jNavMap = $("div.navigator");
        this.jNavLeft = $("div.left");
        this.jNavRight = $("div.right");
        
        this.jNavLeft.click(NavigationManager.NAVIGATE_LEFT);
        this.jNavRight.click(NavigationManager.NAVIGATE_RIGHT);
    },
    NAVIGATE_LEFT:function() {
        var currentNav = $(NavigationManager.jNavMap).html();
        NavigationManager.jNavMap.html(currentNav + 0);
        TransitionManager.slideMainLeft();
    },
    NAVIGATE_RIGHT:function() {
        var currentNav = $(NavigationManager.jNavMap).html();
        NavigationManager.jNavMap.html(currentNav + 1);
        TransitionManager.slideMainRight();
    },
    NAVIGATE_BACK:function() {
        
    }
}