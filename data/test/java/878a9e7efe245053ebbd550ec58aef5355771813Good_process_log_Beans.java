package shoeseholic.good;

import shoeseholic.common.Beans;

public class Good_process_log_Beans extends Beans{

	private String product_process_log_idx,before_product_process_idx,after_product_process_idx,product_process_log_hiredate,staff_idx,product_idx;

	public String toString() {
		return "product_process_log_idx="+product_process_log_idx+"before_product_process_idx="+before_product_process_idx+"after_product_process_idx="+after_product_process_idx+"product_process_log_hiredate="+product_process_log_hiredate+"staff_idx="+staff_idx+"product_idx="+product_idx;
	}
	public String getProduct_process_log_idx() {
		return product_process_log_idx;
	}

	public void setProduct_process_log_idx(String product_process_log_idx) {
		this.product_process_log_idx = product_process_log_idx;
	}

	public String getBefore_product_process_idx() {
		return before_product_process_idx;
	}

	public void setBefore_product_process_idx(String before_product_process_idx) {
		this.before_product_process_idx = before_product_process_idx;
	}

	public String getAfter_product_process_idx() {
		return after_product_process_idx;
	}

	public void setAfter_product_process_idx(String after_product_process_idx) {
		this.after_product_process_idx = after_product_process_idx;
	}

	public String getProduct_process_log_hiredate() {
		return product_process_log_hiredate;
	}

	public void setProduct_process_log_hiredate(String product_process_log_hiredate) {
		this.product_process_log_hiredate = product_process_log_hiredate;
	}

	public String getStaff_idx() {
		return staff_idx;
	}

	public void setStaff_idx(String staff_idx) {
		this.staff_idx = staff_idx;
	}

	public String getProduct_idx() {
		return product_idx;
	}

	public void setProduct_idx(String product_idx) {
		this.product_idx = product_idx;
	}
	
	
}
