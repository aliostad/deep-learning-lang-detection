/**
 * Autor: Karsten Beving (ObjectCode)
 * Datum: 14.11.2007
 */
package de.objectcode.canyon.bpe.engine.activities;

/**
 * @author Beving
 *
 */
public class BPECompactProcess {
    
//    final static         long               serialVersionUID     = ;
    
    protected  String        m_processId;
    protected  String          m_processVersion;
    
    
    public BPECompactProcess(String processId, String processVersion) {
        m_processId = processId;
        m_processVersion = processVersion;
    }
    
    public String getM_processId() {
        return m_processId;
    }
    public void setM_processId(String id) {
        m_processId = id;
    }
    public String getM_processVersion() {
        return m_processVersion;
    }
    public void setM_processVersion(String version) {
        m_processVersion = version;
    }

    
}
