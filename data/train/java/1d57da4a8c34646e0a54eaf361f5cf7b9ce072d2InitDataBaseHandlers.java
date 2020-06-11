package com.example.avescera.remindme.Classes;

import android.content.Context;

import com.example.avescera.remindme.DBHandlers.DatabaseCategoryHandler;
import com.example.avescera.remindme.DBHandlers.DatabaseContactHandler;
import com.example.avescera.remindme.DBHandlers.DatabaseMoneyHandler;
import com.example.avescera.remindme.DBHandlers.DatabaseObjectHandler;
import com.example.avescera.remindme.DBHandlers.DatabaseReminderHandler;
import com.example.avescera.remindme.DBHandlers.DatabaseTypeHandler;

import java.sql.SQLException;

/**
 * Created by a.vescera on 08/12/2016.
 * This regroups all the databaseHandlers initialization, to only refer to this same class.
 */

public class InitDataBaseHandlers {

    private final DatabaseMoneyHandler dbMoneyHandler;
    private final DatabaseObjectHandler dbObjectHandler;
    private final DatabaseContactHandler dbContactHandler;
    private final DatabaseCategoryHandler dbCategoryHandler;
    private final DatabaseTypeHandler dbTypeHandler;
    private final DatabaseReminderHandler dbReminderHandler;

    public InitDataBaseHandlers(Context context) {
        //Initiate the DBHandlers
        dbMoneyHandler = new DatabaseMoneyHandler(context);
        try {
            dbMoneyHandler.open();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        dbObjectHandler = new DatabaseObjectHandler(context);
        try {
            dbObjectHandler.open();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        dbCategoryHandler = new DatabaseCategoryHandler(context);
        try {
            dbCategoryHandler.open();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        dbTypeHandler = new DatabaseTypeHandler(context);
        try {
            dbTypeHandler.open();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        dbContactHandler = new DatabaseContactHandler(context);
        try {
            dbContactHandler.open();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        dbReminderHandler = new DatabaseReminderHandler(context);
        try {
            dbReminderHandler.open();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    //Getters
    public DatabaseMoneyHandler getDbMoneyHandler() {
        return dbMoneyHandler;
    }

    public DatabaseObjectHandler getDbObjectHandler() {
        return dbObjectHandler;
    }

    public DatabaseContactHandler getDbContactHandler() {
        return dbContactHandler;
    }

    public DatabaseCategoryHandler getDbCategoryHandler() {
        return dbCategoryHandler;
    }

    public DatabaseTypeHandler getDbTypeHandler() {
        return dbTypeHandler;
    }

    public DatabaseReminderHandler getDbReminderHandler() {
        return dbReminderHandler;
    }
}
