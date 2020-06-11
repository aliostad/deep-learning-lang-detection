package it.polimi.bookshelf.data;

import android.content.Context;

public class DataHandler {

    private Context context;
    private PreferenceHandler ph;
    private DatabaseHandler dbh;
    private CloudHandler cdh;
    private StorageHandler sH;

    public DataHandler(Context context) {
        this.context = context;
        this.ph = new PreferenceHandler(this.context);
        this.dbh = new DatabaseHandler(this.context);
        this.cdh = new CloudHandler();
        this.sH = new StorageHandler(this.context);
    }

    public PreferenceHandler getPreferencesHandler() {
        return this.ph;
    }

    public DatabaseHandler getDatabaseHandler() {
        return this.dbh;
    }

    public CloudHandler getCloudHandler() {
        return this.cdh;
    }

    public StorageHandler getStorageHandler() {
        return this.sH;
    }
}
