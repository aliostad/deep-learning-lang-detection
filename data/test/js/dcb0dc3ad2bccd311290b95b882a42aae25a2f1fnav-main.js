(function () {

    var catalogLink = document.querySelector(".nav-main__item--catalog a");
    var catalogNav = document.querySelector(".nav-sub__block--catalog");
    var serviceLink = document.querySelector(".nav-main__item--services a");
    var serviceNav = document.querySelector(".nav-sub__block--services");

    function showSubMenu(link, subNav) {

        var navTimer = null;
        var allLinks = document.querySelectorAll(".nav-main .nav__link");
        var allSubNav = document.querySelectorAll(".nav-sub .nav-sub__block");

        function doNav(elem) {
            elem.addEventListener("mouseover", function () {

                // Clear Timeout
                clearTimeout(navTimer);

                // Remove Class Active From All Links
                for (let count = 0; count < allLinks.length; count++)
                {
                    let currentLink = allLinks[count];
                    currentLink.classList.remove("nav-main__item--active");
                }
                link.classList.add("nav-main__item--active");

                // Remove Class Active From All Sub Blocks
                for (let count = 0; count < allSubNav.length; count++)
                {
                    let currentNav = allSubNav[count];
                    currentNav.classList.remove("nav-sub--active");
                }
                subNav.classList.add("nav-sub--active");

            });

            elem.addEventListener("mouseout", function () {

                navTimer = setTimeout(function () {
                    link.classList.remove("nav-main__item--active");
                    subNav.classList.remove("nav-sub--active");
                }, 500);

            });
        }
        doNav(link);
        doNav(subNav);

    }

    showSubMenu(catalogLink, catalogNav);
    showSubMenu(serviceLink, serviceNav);

}());