'use strict';

function NavPanelController(MdNav) {
    this.menus = MdNav.menus;
}

function NavMenuController() {
    this.sref = function (menuitem) {
        // Generating the ui-sref has some logic. Let's do it here instead
        // of inline.
        var uiSref = menuitem.state;
        if (menuitem.params) {
            uiSref = uiSref + '({' + menuitem.params + '})';
        }
        return uiSref;
    };
}

function NavSubmenuController() {
    this.isCollapsed = true;
}

module.exports = {
    NavPanelController: NavPanelController,
    NavMenuController: NavMenuController,
    NavSubmenuController: NavSubmenuController
};
