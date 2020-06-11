package com.shadowcraft.android;

import android.app.Application;
import android.content.res.Resources;

public class APP extends Application {

    private CharHandler charHandler = null;
    private IconHandler iconHandler = null;

    /**
     * @return the charHandler
     */
    public CharHandler getCharHandler() {
        return charHandler;
    }

    /**
     * @param charHandler the charHandler to set
     */
    public void setCharHandler(CharHandler charHandler) {
        this.charHandler = charHandler;
    }

    /**
     * @return true if charHandler is set.
     */
    public boolean existsCharHandler() {
        return this.charHandler != null;
    }

    /**
     * @return the iconHandler
     */
    public IconHandler getIconHandler() {
        if (iconHandler == null) {
            Resources res = getResources();
            iconHandler = new IconHandler(res);
        }
        return iconHandler;
    }

}
