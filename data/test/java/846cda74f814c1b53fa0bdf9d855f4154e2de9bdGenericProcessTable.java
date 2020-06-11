package binevi.Resources.PathCaseResources;

import java.util.ArrayList;
import java.util.HashMap;


public class GenericProcessTable {
    public ArrayList<String> getGenericProcessIdList() {
        return new ArrayList<String>(ContentTable.keySet());
    }

    public class GenericProcessTableEntry {
        public String GenericProcessName;
        public String GenericProcessEntityID;
        public boolean isProcessReversible;
        public boolean isTransport;
        public String Tissue;

        public GenericProcessTableEntry(String GenericProcessEntityID, String GenericProcessName, boolean isProcessReversible,boolean isTransport,String Tissue) {
            this.GenericProcessName = GenericProcessName;
            this.isProcessReversible = isProcessReversible;
            this.GenericProcessEntityID = GenericProcessEntityID;
            this.isTransport =isTransport;
            this.Tissue =Tissue;
        }

        public GenericProcessTableEntry(String GenericProcessEntityID, String GenericProcessName, boolean isProcessReversible) {
            this.GenericProcessName = GenericProcessName;
            this.isProcessReversible = isProcessReversible;
            this.GenericProcessEntityID = GenericProcessEntityID;
            this.isTransport =false;
            this.Tissue ="";
        }

        public boolean equals(Object other) {
            return other instanceof GenericProcessTableEntry && ((GenericProcessTableEntry) other).isProcessReversible == isProcessReversible && ((GenericProcessTableEntry) other).GenericProcessName.equals(this.GenericProcessName)&& ((GenericProcessTableEntry) other).GenericProcessEntityID.equals(this.GenericProcessEntityID);
        }
    }

    private HashMap<String, GenericProcessTableEntry> ContentTable;

    public GenericProcessTable() {
        ContentTable = new HashMap<String, GenericProcessTableEntry>();
    }

    public void insertRow(String GenericProcessID, String GenericProcessEntityID, String GenericProcessName, boolean isProcessReversible) {
        this.ContentTable.put(GenericProcessID, new GenericProcessTableEntry(GenericProcessEntityID, GenericProcessName, isProcessReversible));
    }

    public GenericProcessTableEntry getRow(String GenericProcessID) {
        return this.ContentTable.get(GenericProcessID);
    }

    public String getNameById(String GenericProcessID) {
        if(this.ContentTable.get(GenericProcessID).GenericProcessName!=null)
            return this.ContentTable.get(GenericProcessID).GenericProcessName;
        return "null";
    }

    public String getTissueById(String GenericProcessID) {
        return this.ContentTable.get(GenericProcessID).Tissue;
    }

    public boolean getReversibleById(String GenericProcessID) {
        return this.ContentTable.get(GenericProcessID).isProcessReversible;
    }

    public boolean getIsTransportById(String GenericProcessID) {
            return this.ContentTable.get(GenericProcessID).isTransport;
        }    

    public String getEntityIdById(String GenericProcessID) {
        GenericProcessTableEntry entry  = this.ContentTable.get(GenericProcessID);
        if (entry==null) return "NULL_ID";
        return entry.GenericProcessEntityID;
    }
}
