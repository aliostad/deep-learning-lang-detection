package com.storemanager.service;

public enum ServiceName {
    USER_SERVICE("userService"),
    MENU_SERVICE("menuService"),
    CATEGORY_SERVICE("categoryService"),
    PRODUCT_SERVICE("productService"),
    INVENTORY_SERVICE("inventoryService"),
    SUPPLY_SERVICE("supplyService"),
    XREF_MENU_ROLE_SERVICE("xrefMenuRoleService"),
    ROLE_SERVICE("roleService"),
    SALE_SERVICE("saleService"),
    STOCK_SERVICE("stockService"),
    ZREPORT_SERVICE("zreportService"),
    REPORT_SERVICE("reportService"),
    DISCOUNT_SERVICE("discountReportService"),
    SETTINGS_SERVICE("settingsService");

    private String beanName;

    private ServiceName(String beanName) {
        this.beanName = beanName;
    }

    public String getBeanName() {
        return beanName;
    }
}
