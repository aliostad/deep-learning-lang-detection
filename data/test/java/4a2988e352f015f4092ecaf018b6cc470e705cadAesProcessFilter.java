/**
 * AesProcessFilter.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Dec 20, 2006 (01:34:32 EST) WSDL2Java emitter.
 */

package org.activebpel.rt.axis.bpel.admin.types;

public class AesProcessFilter  extends org.activebpel.rt.axis.bpel.admin.types.AesListingFilter  implements java.io.Serializable {
    private java.util.Calendar processCompleteEnd;

    private java.util.Calendar processCompleteStart;

    private java.util.Calendar processCreateEnd;

    private java.util.Calendar processCreateStart;

    private javax.xml.namespace.QName processName;

    private int processState;

    private java.lang.String advancedQuery;

    public AesProcessFilter() {
    }

    public AesProcessFilter(
           int listStart,
           int maxReturn,
           java.util.Calendar processCompleteEnd,
           java.util.Calendar processCompleteStart,
           java.util.Calendar processCreateEnd,
           java.util.Calendar processCreateStart,
           javax.xml.namespace.QName processName,
           int processState,
           java.lang.String advancedQuery) {
        super(
            listStart,
            maxReturn);
        this.processCompleteEnd = processCompleteEnd;
        this.processCompleteStart = processCompleteStart;
        this.processCreateEnd = processCreateEnd;
        this.processCreateStart = processCreateStart;
        this.processName = processName;
        this.processState = processState;
        this.advancedQuery = advancedQuery;
    }


    /**
     * Gets the processCompleteEnd value for this AesProcessFilter.
     * 
     * @return processCompleteEnd
     */
    public java.util.Calendar getProcessCompleteEnd() {
        return processCompleteEnd;
    }


    /**
     * Sets the processCompleteEnd value for this AesProcessFilter.
     * 
     * @param processCompleteEnd
     */
    public void setProcessCompleteEnd(java.util.Calendar processCompleteEnd) {
        this.processCompleteEnd = processCompleteEnd;
    }


    /**
     * Gets the processCompleteStart value for this AesProcessFilter.
     * 
     * @return processCompleteStart
     */
    public java.util.Calendar getProcessCompleteStart() {
        return processCompleteStart;
    }


    /**
     * Sets the processCompleteStart value for this AesProcessFilter.
     * 
     * @param processCompleteStart
     */
    public void setProcessCompleteStart(java.util.Calendar processCompleteStart) {
        this.processCompleteStart = processCompleteStart;
    }


    /**
     * Gets the processCreateEnd value for this AesProcessFilter.
     * 
     * @return processCreateEnd
     */
    public java.util.Calendar getProcessCreateEnd() {
        return processCreateEnd;
    }


    /**
     * Sets the processCreateEnd value for this AesProcessFilter.
     * 
     * @param processCreateEnd
     */
    public void setProcessCreateEnd(java.util.Calendar processCreateEnd) {
        this.processCreateEnd = processCreateEnd;
    }


    /**
     * Gets the processCreateStart value for this AesProcessFilter.
     * 
     * @return processCreateStart
     */
    public java.util.Calendar getProcessCreateStart() {
        return processCreateStart;
    }


    /**
     * Sets the processCreateStart value for this AesProcessFilter.
     * 
     * @param processCreateStart
     */
    public void setProcessCreateStart(java.util.Calendar processCreateStart) {
        this.processCreateStart = processCreateStart;
    }


    /**
     * Gets the processName value for this AesProcessFilter.
     * 
     * @return processName
     */
    public javax.xml.namespace.QName getProcessName() {
        return processName;
    }


    /**
     * Sets the processName value for this AesProcessFilter.
     * 
     * @param processName
     */
    public void setProcessName(javax.xml.namespace.QName processName) {
        this.processName = processName;
    }


    /**
     * Gets the processState value for this AesProcessFilter.
     * 
     * @return processState
     */
    public int getProcessState() {
        return processState;
    }


    /**
     * Sets the processState value for this AesProcessFilter.
     * 
     * @param processState
     */
    public void setProcessState(int processState) {
        this.processState = processState;
    }


    /**
     * Gets the advancedQuery value for this AesProcessFilter.
     * 
     * @return advancedQuery
     */
    public java.lang.String getAdvancedQuery() {
        return advancedQuery;
    }


    /**
     * Sets the advancedQuery value for this AesProcessFilter.
     * 
     * @param advancedQuery
     */
    public void setAdvancedQuery(java.lang.String advancedQuery) {
        this.advancedQuery = advancedQuery;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof AesProcessFilter)) return false;
        AesProcessFilter other = (AesProcessFilter) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = super.equals(obj) && 
            ((this.processCompleteEnd==null && other.getProcessCompleteEnd()==null) || 
             (this.processCompleteEnd!=null &&
              this.processCompleteEnd.equals(other.getProcessCompleteEnd()))) &&
            ((this.processCompleteStart==null && other.getProcessCompleteStart()==null) || 
             (this.processCompleteStart!=null &&
              this.processCompleteStart.equals(other.getProcessCompleteStart()))) &&
            ((this.processCreateEnd==null && other.getProcessCreateEnd()==null) || 
             (this.processCreateEnd!=null &&
              this.processCreateEnd.equals(other.getProcessCreateEnd()))) &&
            ((this.processCreateStart==null && other.getProcessCreateStart()==null) || 
             (this.processCreateStart!=null &&
              this.processCreateStart.equals(other.getProcessCreateStart()))) &&
            ((this.processName==null && other.getProcessName()==null) || 
             (this.processName!=null &&
              this.processName.equals(other.getProcessName()))) &&
            this.processState == other.getProcessState() &&
            ((this.advancedQuery==null && other.getAdvancedQuery()==null) || 
             (this.advancedQuery!=null &&
              this.advancedQuery.equals(other.getAdvancedQuery())));
        __equalsCalc = null;
        return _equals;
    }

    private boolean __hashCodeCalc = false;
    public synchronized int hashCode() {
        if (__hashCodeCalc) {
            return 0;
        }
        __hashCodeCalc = true;
        int _hashCode = super.hashCode();
        if (getProcessCompleteEnd() != null) {
            _hashCode += getProcessCompleteEnd().hashCode();
        }
        if (getProcessCompleteStart() != null) {
            _hashCode += getProcessCompleteStart().hashCode();
        }
        if (getProcessCreateEnd() != null) {
            _hashCode += getProcessCreateEnd().hashCode();
        }
        if (getProcessCreateStart() != null) {
            _hashCode += getProcessCreateStart().hashCode();
        }
        if (getProcessName() != null) {
            _hashCode += getProcessName().hashCode();
        }
        _hashCode += getProcessState();
        if (getAdvancedQuery() != null) {
            _hashCode += getAdvancedQuery().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

}
