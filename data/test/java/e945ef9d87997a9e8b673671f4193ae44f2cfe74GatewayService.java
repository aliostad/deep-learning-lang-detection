package gateway;

import gateway.klinisys.KlinisysService;
import gateway.reservation.ReservationService;

import org.springframework.http.*;
import org.springframework.stereotype.Service;

@Service
public class GatewayService {

	public static ReservationService reservationService = new ReservationService();
	public static KlinisysService klinisysService = new KlinisysService();

	public static KlinisysService getKlinisysService(){
		if(klinisysService==null){
			return new KlinisysService();
		} else {
			return klinisysService;
		}
	}

	public static ReservationService getReservationService(){
		if(reservationService==null){
			return new ReservationService();
		} else {
			return reservationService;
		}
	}

}
