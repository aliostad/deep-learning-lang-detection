
/**
 * Auto generated code
 */

package urn.ebay.api.PayPalAPI;

import urn.ebay.api.PayPalAPI.ManageRecurringPaymentsProfileStatusRequestType;


/**
 */
public class ManageRecurringPaymentsProfileStatusReq {

	/**
	 */
	private ManageRecurringPaymentsProfileStatusRequestType ManageRecurringPaymentsProfileStatusRequest;
	public ManageRecurringPaymentsProfileStatusRequestType getManageRecurringPaymentsProfileStatusRequest() {
		return ManageRecurringPaymentsProfileStatusRequest;
	}
	public void setManageRecurringPaymentsProfileStatusRequest(ManageRecurringPaymentsProfileStatusRequestType value) {
		this.ManageRecurringPaymentsProfileStatusRequest = value;
	}



	public String toXMLString()  {
		StringBuilder sb = new StringBuilder();
sb.append("<urn:ManageRecurringPaymentsProfileStatusReq>");
		if( ManageRecurringPaymentsProfileStatusRequest != null ) {
			sb.append("<urn:ManageRecurringPaymentsProfileStatusRequest>");
			sb.append(ManageRecurringPaymentsProfileStatusRequest.toXMLString());
			sb.append("</urn:ManageRecurringPaymentsProfileStatusRequest>");
		}
sb.append("</urn:ManageRecurringPaymentsProfileStatusReq>");
		return sb.toString();
	}

}
