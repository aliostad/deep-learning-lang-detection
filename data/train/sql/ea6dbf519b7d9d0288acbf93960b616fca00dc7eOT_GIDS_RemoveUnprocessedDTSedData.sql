
--Sometimes we DTS data and end up with problems and have to re-dts.  This will allow us to clean the data easily.
CREATE PROCEDURE OT_GIDS_RemoveUnprocessedDTSedData
AS
	declare @oldMaxEvent int
	select @oldMaxEvent = LAST_TvlOrdrIdent
	from MASTER_LAST_GIDS_EVENT
		
	print 'purging processing data'
	
	print 'Purging PNR level info'
	delete ids_processing_frequentflyer
	where tvlordrident > @oldMaxEvent
	
	delete ids_processing_passenger
	where tvlordrident > @oldMaxEvent
	
	delete ids_processing_corporateid
	where tvlordrident > @oldMaxEvent
	
	delete ids_processing_phoneseg
	where tvlordrident > @oldMaxEvent
	
	delete ids_processing_emailseg
	where tvlordrident > @oldMaxEvent
	
	delete ids_processing_remarks
	where tvlordrident > @oldMaxEvent
	
	print 'Purging Fare quote info'
	delete ids_processing_farecmpntrte
	where tvlordrident > @oldMaxEvent
	
	delete ids_processing_farecmpnt
	where tvlordrident > @oldMaxEvent
	
	delete ids_processing_plusuploc
	where tvlordrident > @oldMaxEvent
	
	delete ids_processing_plusup
	where tvlordrident > @oldMaxEvent
	
	delete ids_processing_airtaxbrk
	where tvlordrident > @oldMaxEvent
	
	delete ids_processing_airtax
	where tvlordrident > @oldMaxEvent
	
	delete ids_processing_airschg
	where tvlordrident > @oldMaxEvent
	
	delete ids_processing_airquoman
	where tvlordrident > @oldMaxEvent
	
	delete ids_processing_airquopax
	where tvlordrident > @oldMaxEvent
	
	delete ids_processing_airfarequo
	where tvlordrident > @oldMaxEvent
	
	print 'Purging Segment info'
	delete ids_processing_seatassignment
	where tvlordrident > @oldMaxEvent
	
	delete ids_processing_seatseg
	where tvlordrident > @oldMaxEvent
	
	delete ids_processing_htlsegopt
	where tvlordrident > @oldMaxEvent

	delete ids_processing_htlseg
	where tvlordrident > @oldMaxEvent
	
	delete ids_processing_carsegopt
	where tvlordrident > @oldMaxEvent
	
	delete ids_processing_carseg
	where tvlordrident > @oldMaxEvent
	
	delete ids_processing_trainseg
	where tvlordrident > @oldMaxEvent
	
	delete ids_processing_flyingtaxiseg
	where tvlordrident > @oldMaxEvent
	
	delete ids_processing_nonairseg
	where tvlordrident > @oldMaxEvent
	
	delete ids_processing_openairseg
	where tvlordrident > @oldMaxEvent
	
	delete ids_processing_airrsrvseg
	where tvlordrident > @oldMaxEvent
	
	print 'Purging Ticketing transaction info'
	delete ids_processing_fopexchg
	where tvlordrident > @oldMaxEvent
	
	delete ids_processing_fopcrcrd
	where tvlordrident > @oldMaxEvent
	
	delete ids_processing_fop
	where tvlordrident > @oldMaxEvent
	
	delete ids_processing_airtktseg
	where tvlordrident > @oldMaxEvent
	
	delete ids_processing_tkttrans
	where tvlordrident > @oldMaxEvent
	
	print 'Purging event rows'
	delete ids_processing_travelorderevent
	where tvlordrident > @oldMaxEvent

