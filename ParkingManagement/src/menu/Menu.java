package menu;

import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;

public class Menu {
	private Controller controller;
	
	public Menu(final Controller controller) {
		this.controller = controller;
	}
	
	/**
	 * Show all menu options
	 * 
	 * @return chosen option
	 */
	@SuppressWarnings("resource")
	private int menu() {
		System.out.println("-------------------MENU-------------------");
		System.out.println("1. Vehicle in/out");
		System.out.println("2. Print all parking vehicle");
		System.out.println("3. Sort tickets by type vehicle");
		System.out.println("4. Sort tickets by parking time");
		System.out.println("5. Find a vehicle");
		System.out.println("6. Save data to file");
		System.out.println("7. Read data from file");
		System.out.println("0. Exit!");
		System.out.print("Please choose an option: ");

		while (true) {
			try {
				Scanner scanner = new Scanner(System.in);
				int option = Integer.parseInt(scanner.nextLine());

				if (option >= 0 && option <= 7) {
					return option;
				}
			} catch (Exception e) {
			}

			System.err.println("Invalid option!");
			System.out.print("Please choose an option: ");
		}
	}
	
	/**
	 * 
	 */
	public void mainMenu() {
		int option;
		Map<Integer, Runnable> functions = new HashMap<>();
		functions.put(1, () -> this.controller.parkVehicle());
		functions.put(2, () -> this.controller.printListTicket());
		functions.put(3, () -> this.controller.sortTicketByType());
		functions.put(4, () -> this.controller.sortTicketByParkingTime());
		functions.put(5, () -> this.controller.searchTicket());
		functions.put(6, () -> this.controller.writeCSV());
		functions.put(7, () -> this.controller.readCSV());

		do {
			option = this.menu();
			Runnable runFunction = functions.get(option);
			if (runFunction == null) {
				System.out.println("Good bye!");
			} else {
				runFunction.run();
			}

			System.out.println("------------------------------------------\n");
		} while (option != 0);
	}
}
