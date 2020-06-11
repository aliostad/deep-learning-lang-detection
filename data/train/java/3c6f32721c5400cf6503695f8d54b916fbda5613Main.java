package Main;

import DbConnect.EventSQLHandler;
import DbConnect.IEventSQLHandler;
import DienstleistungController.AnbieterHandler;
import DienstleistungController.DekorationHandler;
import DienstleistungController.IAnbieterHandler;
import DienstleistungController.IDekorationHandler;
import DienstleistungController.IUnterhaltungHandler;
import DienstleistungController.IUnterkunftHandler;
import DienstleistungController.IVerpflegungHandler;
import DienstleistungController.UnterhaltungHandler;
import DienstleistungController.UnterkunftHandler;
import DienstleistungController.VerpflegungHandler;
import GUI.Startmaske;

public class Main {

	public static void main(String[] args) {

		IEventSQLHandler sqlHandler = new EventSQLHandler();
		// ILocationHandler handler = new LocationHandler(sqlHandler);
		IAnbieterHandler anbHandler = new AnbieterHandler(sqlHandler);
		IUnterkunftHandler ukunftHandler = new UnterkunftHandler(sqlHandler);
		IDekorationHandler dekorationHandler = new DekorationHandler(sqlHandler);
		IUnterhaltungHandler unterhaltungHandler = new UnterhaltungHandler(
				sqlHandler);
		IVerpflegungHandler verpflegungHandler = new VerpflegungHandler(
				sqlHandler);

		Startmaske start = new Startmaske(anbHandler, ukunftHandler,
				dekorationHandler, unterhaltungHandler, verpflegungHandler,
				sqlHandler);

		// AnbieterErfassen anberfa = new AnbieterErfassen(anbhandler);

		// LocationErfassen locInsert = new LocationErfassen(handler);
		start.setVisible(true);
		// final EventManager manager = new EventManager();

	}
}
