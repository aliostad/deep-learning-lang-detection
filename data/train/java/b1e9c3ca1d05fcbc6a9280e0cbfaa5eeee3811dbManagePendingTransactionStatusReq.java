
/**
 * Auto generated code
 */

package urn.ebay.api.PayPalAPI;

import urn.ebay.api.PayPalAPI.ManagePendingTransactionStatusRequestType;


/**
 */
public class ManagePendingTransactionStatusReq {

	/**
	 */
	private ManagePendingTransactionStatusRequestType ManagePendingTransactionStatusRequest;
	public ManagePendingTransactionStatusRequestType getManagePendingTransactionStatusRequest() {
		return ManagePendingTransactionStatusRequest;
	}
	public void setManagePendingTransactionStatusRequest(ManagePendingTransactionStatusRequestType value) {
		this.ManagePendingTransactionStatusRequest = value;
	}



	public String toXMLString()  {
		StringBuilder sb = new StringBuilder();
sb.append("<urn:ManagePendingTransactionStatusReq>");
		if( ManagePendingTransactionStatusRequest != null ) {
			sb.append("<urn:ManagePendingTransactionStatusRequest>");
			sb.append(ManagePendingTransactionStatusRequest.toXMLString());
			sb.append("</urn:ManagePendingTransactionStatusRequest>");
		}
sb.append("</urn:ManagePendingTransactionStatusReq>");
		return sb.toString();
	}

}
