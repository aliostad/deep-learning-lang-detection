package main;

import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;

import handler.Handler;


public class Main {
	public static void main(String[] args){
		
		Handler handler = new Handler();
		
		try {
			handler.maxSalary();
			handler.depWithEmpMore5();
			handler.depAndEmp();
			handler.randNum();
			handler.managEmpl();
			handler.checkA();
			handler.YMDFromDateOfBirth();
			handler.dupField();
			handler._9And10out();
			
		} catch (SQLException | NoSuchAlgorithmException e) {
			e.printStackTrace();
		}
		
	}
}
