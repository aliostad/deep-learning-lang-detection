ACCESSION_WF_XML = <<-EOXML
<workflow id="eemsAccessionWF">
   <process name="register-object" lifecycle="registered" status="completed" attempts="1" />
   <process name="submit-tech-services" lifecycle="inprocess" status="waiting" />
   <process name="eems-transfer" status="waiting" />
   <process name="submit-marc" status="waiting" />
   <process name="check-marc" status="waiting" />
   <process name="catalog-status" status="waiting" />
   <process name="descriptive-metadata" status="waiting" />
   <process name="other-metadata" status="waiting" />
   <process name="sdr-ingest-transfer" status="waiting" />
   <process name="sdr-ingest-deposit" status="waiting" />
   <process name="shelve" lifecycle="released" status="waiting" />
   <process name="cleanup" lifecycle="accessioned" status="waiting" />
   <process name="sdr-ingest-archive" life-cycle="archived" status="waiting" />
</workflow>
EOXML
