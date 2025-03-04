package main;

import menu.Controller;
import menu.Menu;

/**
 * This class helps to manage all activity of parking management system
 * 
 * @author TungDuong
 *
 */
public class ParkingManagementSystem {
	private static final String FILE_NAME = "data/data.csv";

	/**
	 * main method
	 * 
	 * @param args
	 */
	public static void main(String[] args) {
		Controller controller = new Controller(FILE_NAME);
		Menu menu = new Menu(controller);
		menu.mainMenu();
	}
}
