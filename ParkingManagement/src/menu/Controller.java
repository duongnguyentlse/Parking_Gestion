package menu;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.Scanner;
import dao.DataAccessObject;
import domain.Car;
import domain.Motorbike;
import domain.Parking;
import domain.Ticket;
import domain.TicketComparatorByParkingTime;
import domain.TicketComparatorByTypeVehicle;
import domain.User;
import domain.Vehicle;
import domain.Wheelchair;
import utils.CommandLine;
import utils.Operators;

public class Controller {
	private String fileName;
	private Parking parking;

	public Controller(final String fileName) {
		this.fileName = fileName;
		this.parking = new Parking();
	}

	/**
	 * Find the specific ticket of a vehicle
	 * 
	 * @param licensePlate
	 * @return false for not found, true for otherwise
	 */
	private boolean checkExists(String licensePlate) {
		return this.parking.checkExists(licensePlate);
	}

	/**
	 * 
	 */
	@SuppressWarnings("resource")
	public void parkVehicle() {
		try {
			Scanner scanner = new Scanner(System.in);
			System.out.print("Please enter the license plate: ");
			String licensePlate = scanner.nextLine();

			if (!this.checkExists(licensePlate)) {// insert new
				System.out.println("Adding new ticket....");
				Ticket<?> ticket = this.addVehicle(licensePlate);
				if (ticket == null) {
					System.err.println("Fail to add new ticket! Try again!");
				} else {
					this.parking.addTicket(ticket);
					CommandLine.processCmd(Operators.INSERT, fileName, new DataAccessObject(ticket).toString());

					System.out.println("Parking vehicle successfully....");
				}
			} else { // remove existing one
				System.out.println("Removing existing ticket....");
				Ticket<?> ticket = this.parking.removeTicket(licensePlate);
				if (ticket.removeVehicle()) {
					long diff = ticket.getEndTime().getTime() - ticket.getStartTime().getTime();
					long minutes = diff / 60 / 1000;
					ticket.getVehicle().setTotalParkingTime(minutes);
					System.out.println("Payment ticket information....");
					System.out.println(ticket);

					CommandLine.processCmd(Operators.REMOVE, fileName, String.valueOf(ticket.getId()));
				} else {
					System.err.println("Fail to remove existing ticket! Try again!");
					this.parking.addTicket(ticket);
				}
			}
		} catch (Exception e) {
			System.err.println("An error occurs!");
		}
	}

	/**
	 * This method helps to add new ticket
	 * 
	 * @param licensePlate
	 * @author TungDuong
	 * @return false in case failure
	 */
	@SuppressWarnings("resource")
	private Ticket<?> addVehicle(String licensePlate) {
		try {
			Scanner scanner = new Scanner(System.in);

			// get current time to make sure unique id
			long id = System.currentTimeMillis();

			Date time;
			SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm");
			while (true) {
				try {
					System.out.print("Input start time (format yyyy-MM-dd hh:mm): ");
					time = simpleDateFormat.parse(scanner.nextLine());
					break;
				} catch (Exception e) {
					System.err.println("Invalid start time! " + e);
				}
			}

			// input user
			User user = User.createUser(Ticket.extractUsers(this.parking.iterator()));

			// ask to what kind of vehicle to input
			int kind = -1;
			while (true) {
				System.out.print("What kind of vehicle: {0-Car, 1-Motobike, 2-Wheelchair, -1-Exit}? ");
				kind = Integer.parseInt(scanner.nextLine());

				if (kind < -1 || kind > 2) {
					System.err.println("Invalid vehicle!");
				} else {
					break;
				}
			}
			switch (kind) {
			case 0: {
				Ticket<Car> ticket = new Ticket<>();
				ticket.setVehicle(new Car(licensePlate));
				ticket.setUser(user);
				ticket.setId(id);
				ticket.setStartTime(time);
				return ticket;
			}
			case 1: {
				Ticket<Motorbike> ticket = new Ticket<>();
				ticket.setVehicle(new Motorbike(licensePlate));
				ticket.setUser(user);
				ticket.setId(id);
				ticket.setStartTime(time);
				return ticket;
			}
			case 2: {
				Ticket<Wheelchair> ticket = new Ticket<>();
				ticket.setVehicle(new Wheelchair(licensePlate));
				ticket.setUser(user);
				ticket.setId(id);
				ticket.setStartTime(time);
				return ticket;
			}
			}
		} catch (Exception e) {
			System.err.println("An error occurs! " + e);
		}

		return null;
	}

	/**
	 * 
	 */
	public void printListTicket() {
		System.out.println("------------------------LIST TICKET------------------------");
		System.out.println("-------------------------------------------------------------");
		Iterator<Ticket<? extends Vehicle>> iterator = this.parking.iterator();
		while (iterator.hasNext()) {
			Ticket<?> ticket = iterator.next();
			System.out.println(ticket);
		}
		System.out.println("-------------------------------------------------------------");
	}

	/**
	 * 
	 */
	public void sortTicketByType() {
		System.out.println("Sorting tickets by type increasement.....");
		this.parking.sortTickets(new TicketComparatorByTypeVehicle());

		System.out.println("List tickets after sorting....");
		this.printListTicket();
	}

	/**
	 * 
	 */
	public void sortTicketByParkingTime() {
		System.out.println("Sorting tickets by parking time increasement.....");
		this.parking.sortTickets(new TicketComparatorByParkingTime());

		System.out.println("List tickets after sorting....");
		this.printListTicket();
	}

	/**
	 * 
	 */
	@SuppressWarnings("resource")
	public void searchTicket() {
		Scanner scanner = new Scanner(System.in);
		System.out.println("Searching a ticket by license plate.....");
		System.out.print("Enter license plate to search: ");
		String licensePlate = scanner.nextLine();
		if (!this.checkExists(licensePlate)) {
			System.out.println("Oooops! We can not find the ticket with license plate " + licensePlate);
		} else {
			System.out.println("The ticket is: ");
			System.out.println(this.parking.getTicket(licensePlate));
		}
	}

	/**
	 * 
	 */
	public void writeCSV() {
		// clear all data in file
		CommandLine.processCmd(Operators.DELETE, fileName);

		// save all data to file
		if (this.parking.isEmpty()) {
			System.err.println("No data to save!");
			return;
		}
		Iterator<Ticket<? extends Vehicle>> iterator = this.parking.iterator();
		while (iterator.hasNext()) {
			Ticket<?> ticket = iterator.next();
			CommandLine.processCmd(Operators.INSERT, fileName, new DataAccessObject(ticket).toString());
		}
		System.out.println("Write data to CSV file successfully!");
	}

	/**
	 * 
	 */
	@SuppressWarnings("unchecked")
	public void readCSV() {
		String[] datas = CommandLine.processCmd(Operators.READ, fileName);
		if (datas.length == 0) {
			System.err.println("No data found in file!");
			return;
		}

		for (String data : datas) {
			DataAccessObject dao = DataAccessObject.parse(data);
			User.userCount = Math.max(User.userCount, dao.getUserId());
			try {
				this.parking.addTicket(dao.toTicket());
			} catch (ParseException e) {
				System.err.println("An error occurs! " + e);
			}
		}
		System.out.println("Read data from CSV file successfully!");
	}
}
