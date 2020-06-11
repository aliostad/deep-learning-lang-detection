;(function() {
    "use strict";

    module.exports = function aliasServices(service) {
        return  service === "Wood"                                      ? "Christmas Trees"
                : service === "Batteries"                               ? "Household batteries"
                : service === "Cardboard and paper"                     ? "Cardboard"
                : service === "Clothing and textiles"                   ? "Textiles and shoes"
                : service === "Nappies"                                 ? "Nappies"
                : service === "Furniture"                                ? "Furniture (not reusable)"
                : service === "Garden waste"                            ? "Grass cuttings and leaves"
                : service === "Light bulbs"                             ? "Light bulbs"
                : service === "Glass"                                   ? "Glass bottles and jars (all colours)"
                : service === "Clinical waste"                          ? "Sharps" 
                : service === "Paint"                                   ? "Paint"
                : service === "Chemical and hazardous waste"            ? "Household chemicals"
                : service === "Aluminium cans"                          ? "Aluminium cans"
                : service === "Vehicles"                                ? "Cars and end of life vehicles"
                : service === "Foil"                                    ? "Foil"
                : service === "Scrap metal"                             ? "Scrap metal"
                : service === "Spectacles"                              ? "Spectacles"
                : service === "Cooking oil"                             ? "Cooking oil"
                : service === "Plastic"                                 ? "Plastic containers"

            // Below alias are for encoding issues
                : service === "Residents and tenants association"       ? "Residents%2Ftenants association"
                : service === "Marriage and civil partnership venues"   ? "Marriage%2Fcivil partnership venue"
                : service === "Pay and display"                         ? "Pay and display%2Fmeter"
                : service === "Household electronics and appliances"    ? "Microwaves"
                : service;
    }
}());
