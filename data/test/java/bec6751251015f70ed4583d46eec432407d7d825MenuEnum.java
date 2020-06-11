package com.storemanager.util;

import java.awt.event.KeyEvent;

public enum MenuEnum {
    LOGIN("login_app"),
    LOGOUT("logout_app"),
    EXIT("exit_app", KeyEvent.VK_Q),
    MANAGE_ROLES("manage_roles"),
    MANAGE_MENUS("manage_menus"),
    MANAGE_ROLE_MENU("manage_role_menu_xref"),
    MANAGE_USERS("manage_users"),
    MANAGE_SETTINGS("manage_settings"),
    MANAGE_CATEGORIES("manage_categories"),
    MANAGE_PRODUCTS("manage_products"),
    PRODUCT_HISTORY("product_history"),
    MANAGE_INVENTORY("manage_inventory"),
    MANAGE_INVENTORY_FIRST("manage_inventory_first"),
    MANAGE_INVENTORY_SECOND("manage_inventory_second"),
    INVENTORY_REPORT_GOLD("inventory_report_gold"),
    INVENTORY_REPORT_PRODUCTS("inventory_report_products"),
    MANAGE_SUPPLY("manage_supply"),
    MANAGE_SALES("manage_sales"),
    MANAGE_ZREPORT("manage_zreport"),
    MANAGE_STOCK("manage_stock"),
    MANAGE_LABELS("manage_labels"),
    MANAGE_OUT_OF_STOCK("manage_out_of_stock"),
    MANAGE_SMART_SUPPLY("manage_smart_supply"),
    MANAGE_DISCOUNT_REPORTS("manage_discount_reports"),
    MANAGE_SALE_REPORTS("manage_sale_reports"),
    UPDATE_WATCH_DESCRIPTION("update_watch_description"),
    GENERATE_WATCH_STOCK_REPORT("generate_watch_stock_report");

    private String command;
    private int mnemonic;

    private MenuEnum(String command, int mnemonic) {
        this.command = command;
        this.mnemonic = mnemonic;
    }

    private MenuEnum(String command) {
        this(command, -1);
    }

    public String getCommand() {
        return command;
    }

    public int getMnemonic() {
        return mnemonic;
    }
}
