package models;

import javax.persistence.Entity;
import play.db.jpa.Model;


/**
 * 平台收入统计表
 * @author lwh
 *
 */

@Entity
public class t_statistic_platform_income extends Model{
	public int year;
	public int month;
	public int day;
	public double income_sum;
	public double loan_manage_fee;
	public double recharge_manage_fee;
	public double withdraw_manage_fee;
	public double vip_manage_fee;
	public double invest_manage_fee;
	public double debt_transfer_manage_fee;
	public double overdue_manage_fee;
	public double item_audit_manage_fee;
}
