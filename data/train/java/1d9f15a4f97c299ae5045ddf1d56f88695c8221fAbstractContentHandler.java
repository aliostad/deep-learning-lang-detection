/*
 * Copyright 2009 Rafal Myslek 
 * 
 * Licensed under the Apache License, Version 2.0 (the "License"); 
 * you may not use this file except in compliance with the License. 
 * You may obtain a copy of the License at
 * 
 *     http://www.apache.org/licenses/LICENSE-2.0 
 *     
 * Unless required by applicable law or agreed to in writing, software 
 * distributed under the License is distributed on an "AS IS" BASIS, 
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
 * See the License for the specific language governing permissions and 
 * limitations under the License.     
 */
package com.myslek.ragnarok.mail.contenthandler;

import com.myslek.ragnarok.mail.AttributesHandler;
import com.myslek.ragnarok.mail.ContentHandler;
import com.myslek.ragnarok.mail.EnvelopeHandler;
import com.myslek.ragnarok.mail.impl.DefaultAttributesHandler;
import com.myslek.ragnarok.mail.impl.DefaultEnvelopeHandler;

// TODO: Auto-generated Javadoc
/**
 * The Class AbstractContentHandler.
 */
public abstract class AbstractContentHandler implements ContentHandler {

	/** The attributes handler. */
	private AttributesHandler attributesHandler;
	
	/** The envelope handler. */
	private EnvelopeHandler envelopeHandler;

	/**
	 * Instantiates a new abstract content handler.
	 */
	public AbstractContentHandler() {
		attributesHandler = new DefaultAttributesHandler();
		envelopeHandler = new DefaultEnvelopeHandler();
	}

	/**
	 * Instantiates a new abstract content handler.
	 * 
	 * @param attributesHandler the attributes handler
	 */
	public AbstractContentHandler(AttributesHandler attributesHandler) {
		this.attributesHandler = attributesHandler;
	}

	/**
	 * Gets the attributes handler.
	 * 
	 * @return the attributes handler
	 */
	public AttributesHandler getAttributesHandler() {
		return attributesHandler;
	}

	/**
	 * Sets the attributes handler.
	 * 
	 * @param attributesHandler the new attributes handler
	 */
	public void setAttributesHandler(AttributesHandler attributesHandler) {
		this.attributesHandler = attributesHandler;
	}
	
	/**
	 * Gets the envelope handler.
	 * 
	 * @return the envelope handler
	 */
	public EnvelopeHandler getEnvelopeHandler() {
		return envelopeHandler;
	}

	/**
	 * Sets the envelope handler.
	 * 
	 * @param envelopeHandler the new envelope handler
	 */
	public void setEnvelopeHandler(EnvelopeHandler envelopeHandler) {
		this.envelopeHandler = envelopeHandler;
	}
}