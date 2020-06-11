/**
 * User: Eric Buitenhuis 
 * Date: Aug 4, 2008
 * Time: 10:18:57 AM
 */

package com.nitobi.jsf.event;

import com.nitobi.server.handler.SaveHandler;

/**
 * NitobiSaveEvent
 *
 * @author Eric Buitenhuis
 * @version 1.0
 */
public class NitobiSaveEvent {

    private SaveHandler saveHandler;

    public NitobiSaveEvent(SaveHandler saveHandler) {
        this.saveHandler = saveHandler;
    }

    public SaveHandler getSaveHandler() {
        return saveHandler;
    }

    public void setSaveHandler(SaveHandler saveHandler) {
        this.saveHandler = saveHandler;
    }
}
