/**
 * 
 */
package com.leek.timeline.client;

import com.google.gwt.event.shared.HandlerRegistration;

/**
 * Defines the events fired by a timeline widget.
 * @author <a href="mailto:andrei.cojocaru@hansenhof.de">Andrei Cojocaru</a>
 */
public interface FiresTimelineEvents
{
	/**
	 * @param handler handler for events of type {@link IntervalChangeEvent}.
	 * @return handler registration
	 */
	HandlerRegistration addIntervalChangeEventHandler(IntervalChangeEvent.Handler handler);
	
	/**
	 * @param handler handler for events of type {@link BrowseEvent}.
	 * @return handler registration.
	 */
	HandlerRegistration addBrowseEventHandler(BrowseEvent.Handler handler);
}
