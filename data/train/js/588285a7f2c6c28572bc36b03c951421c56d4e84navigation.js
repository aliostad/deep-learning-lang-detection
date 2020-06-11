var _ = require('lodash');
var Navigation = require('mongoose').model('Navigation');

exports.getNavigation = function (req, res) {


    Navigation.find({}).lean().exec(function (err, collection) {
        
        var navItems = collection;
        
        var filteredNavItems = [];
        
        var myroles = req.user.roles;
        GetNavItems(navItems, filteredNavItems);


        function GetNavItems(allItems, filteredItems) {
            
            allItems.forEach(function (navItem) {
                //my first lodash call!!!
                var newNavItem = _.cloneDeep(navItem);

                if (navItem.navItems.length > 0) {
                    //console.log('I have navItems');
                    newNavItem.navItems = [];
                    navItem.navItems.forEach(function (subNavItem) {
                        //console.log("I am in a subNavItem loop");
                        if (isReqRolesInNavRoles(myroles, subNavItem.roles)) {
                            //console.log("And i have a proper role");
                            newNavItem.navItems.push(subNavItem);
                        }
                    });
                }
                if (isReqRolesInNavRoles(myroles, navItem.roles)) {
                    addItemToNavigation(newNavItem, filteredItems);
                }
            });
            return filteredItems;
        }

        function addItemToNavigation(item, arr) {
            arr.push(item);
        }

        function isReqRolesInNavRoles(reqRoles, navRoles) {
            //reqRoles loop
            var reqRolesLen = reqRoles.length;
            for (var reqRolesIndx = 0; reqRolesIndx < reqRolesLen; reqRolesIndx++) {
                var navRolesLen = navRoles.length;
                for (var navRolesIndx = 0; navRolesIndx < navRolesLen; navRolesIndx++) {
                    if (reqRoles[reqRolesIndx] === navRoles[navRolesIndx]) return true;
                }
            }
        }
        
        res.send(filteredNavItems);
    });
    





};

