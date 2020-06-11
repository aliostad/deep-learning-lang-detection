/**
 * 
 */
package org.openwis.metadataportal.model.metadata.source;

/**
 * Short Description goes here. <P>
 * Explanation goes here. <P>
 * 
 */
public abstract class AbstractSource {
   
   private ProcessType processType;

   /**
    * Gets the processType.
    * @return the processType.
    */
   public ProcessType getProcessType() {
      return processType;
   }

   /**
    * Sets the processType.
    * @param processType the processType to set.
    */
   public void setProcessType(ProcessType processType) {
      this.processType = processType;
   }
   
}
