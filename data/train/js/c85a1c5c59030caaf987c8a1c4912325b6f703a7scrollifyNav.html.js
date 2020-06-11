module.exports =`
    <div class="nav-container">
        <!--<a href="#menu"><span>Menu</span></a>-->
        <span v-if="navConfig.displayMenuIcon" class="nav-menu-icon"></span>
        <button v-for="navItem in navItems" class="nav-button">
            <scrollify-nav-element 
            :tag="navItem.tag" 
            :active="navItem.active" 
            :name="navItem.name" 
            :icon="navItem.icon"
            :colorClass="navConfig.currentColorClass">
                            
            </scrollify-nav-element>
        </button>
    </div>
`;
