
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Scanner;

/**
 * This class helps to manage all activity of parking management system
 * 
 * @author TungDuong
 *
 */
public class ParkingManagementSystem {
	private List<Ticket<?>> tickets;
	private static final String FILE_NAME = "data.csv";

	public ParkingManagementSystem() {
		this.tickets = new ArrayList<>();
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
		System.out.println("6. Save data to file " + FILE_NAME);
		System.out.println("7. Read data from file " + FILE_NAME);
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
	 * Find the specific ticket of a vehicle
	 * 
	 * @param licensePlate
	 * @return index of ticket, -1 for not found
	 */
	private int checkExists(String licensePlate) {
	    int index = 0;

	    for (Ticket<? extends Vehicle> ticket : this.tickets) {
	        if (ticket.getVehicle().getLicensePlate().equalsIgnoreCase(licensePlate)) {
	            return index;
	        }
	        index++;
	    }

	    return -1;
	}

	/**
	 * 
	 */
	@SuppressWarnings("resource")
	private void parkVehicle() {
		try {
			Scanner scanner = new Scanner(System.in);
			System.out.print("Please enter the license plate: ");
			String licensePlate = scanner.nextLine();

			int index = this.checkExists(licensePlate);
			if (index == -1) {// insert new
				System.out.println("Adding new ticket....");
				Ticket<?> ticket = this.addVehicle(licensePlate);
				if (ticket == null) {
					System.err.println("Fail to add new ticket! Try again!");
				} else {
					this.tickets.add(ticket);
					System.out.println("Parking vehicle successfully....");
				}
			} else { // remove existing one
				System.out.println("Removing existing ticket....");
				Ticket<?> ticket = this.tickets.remove(index);
				if (ticket.removeVehicle()) {
					long diff = ticket.getEndTime().getTime() - ticket.getStartTime().getTime();
					long minutes = diff / 60 / 1000;
					ticket.getVehicle().setTotalParkingTime(minutes);
					System.out.println("Payment ticket information....");
					System.out.println(ticket);
				} else {
					System.err.println("Fail to remove existing ticket! Try again!");
					this.tickets.add(ticket);
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
				ticket.setId(id);
				ticket.setStartTime(time);
				return ticket;
			}
			case 1: {
				Ticket<Motorbike> ticket = new Ticket<>();
				ticket.setVehicle(new Motorbike(licensePlate));
				ticket.setId(id);
				ticket.setStartTime(time);
				return ticket;
			}
			case 2: {
				Ticket<Wheelchair> ticket = new Ticket<>();
				ticket.setVehicle(new Wheelchair(licensePlate));
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
	private void printListTicket() {
	    System.out.println("-------------------LIST TICKET-------------------");
	    for (Ticket<? extends Vehicle> ticket : this.tickets) {
	        System.out.println(ticket);
	    }
	}


	/**
	 * 
	 */
	private void sortTicketByType() {
		System.out.println("Sorting tickets by type increasement.....");
		Collections.sort(this.tickets, new TicketComparatorByTypeVehicle());

		System.out.println("List tickets after sorting....");
		this.printListTicket();
	}

	/**
	 * 
	 */
	private void sortTicketByParkingTime() {
		System.out.println("Sorting tickets by parking time increasement.....");
		Collections.sort(this.tickets, new TicketComparatorByParkingTime());

		System.out.println("List tickets after sorting....");
		this.printListTicket();
	}

	/**
	 * 
	 */
	@SuppressWarnings("resource")
	private void searchTicket() {
		Scanner scanner = new Scanner(System.in);
		System.out.println("Searching a ticket by license plate.....");
		System.out.print("Enter license plate to search: ");
		String licensePlate = scanner.nextLine();
		int index = -1;
		if ((index = this.checkExists(licensePlate)) == -1) {
			System.out.println("Oooops! We can not find the ticket with license plate " + licensePlate);
		} else {
			System.out.println("The ticket is: ");
			System.out.println(this.tickets.get(index));
		}
	}

	/**
	 * 
	 */
	private void writeCSV() {
	    FileWriter fileWriter = null;
	    try {
	        fileWriter = new FileWriter(FILE_NAME);

	        // Write the CSV file header
	        fileWriter.append("id,startTime,type,licensePlate,baseTime");
	        // Add a new line separator after the header
	        fileWriter.append("\n");

	        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	        for (Ticket<? extends Vehicle> ticket : this.tickets) {
	            fileWriter.append(BigDecimal.valueOf(ticket.getId()).toPlainString());
	            fileWriter.append(",");
	            fileWriter.append(dateFormat.format(ticket.getStartTime()));
	            fileWriter.append(",");
	            int vehicleType = 2; // Default to 2 if not recognized
	            if (ticket.getVehicle() instanceof Car) {
	                vehicleType = 0;
	            } else if (ticket.getVehicle() instanceof Motorbike) {
	                vehicleType = 1;
	            }
	            fileWriter.append(String.valueOf(vehicleType));
	            fileWriter.append(",");
	            fileWriter.append(ticket.getVehicle().getLicensePlate());
	            fileWriter.append(",");
	            fileWriter.append(String.valueOf(ticket.getVehicle().getBaseTime()));
	            fileWriter.append("\n");
	        }

	        // Finish
	        System.out.println("Write data to CSV file successfully!");
	    } catch (IOException e) {
	        System.err.println("An error occurs when writing data to file!");
	    } finally {
	        try {
	            if (fileWriter != null) {
	                fileWriter.flush();
	                fileWriter.close();
	            }
	        } catch (IOException e) {
	            System.err.println("Error while flushing/closing fileWriter!!!");
	        }
	    }
	}


	/**
	 * 
	 */
	private void readCSV() {
		BufferedReader br = null;
		try {
			this.tickets = new ArrayList<>();
			String line;
			br = new BufferedReader(new FileReader(FILE_NAME));
			DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

			// read header
			line = br.readLine();

			// read data
			while ((line = br.readLine()) != null) {
				String[] fields = line.split(",");
				long id = Long.parseLong(fields[0]);
				Date time = dateFormat.parse(fields[1]);
				int type = Integer.parseInt(fields[2]);
				int baseTime = Integer.parseInt(fields[4]);
				switch (type) {
				case 0: {
					Ticket<Car> ticket = new Ticket<>();
					Car car = new Car(fields[3]);
					car.setBaseTime(baseTime);
					ticket.setVehicle(car);
					ticket.setId(id);
					ticket.setStartTime(time);
					this.tickets.add(ticket);
				}
					break;
				case 1: {
					Ticket<Motorbike> ticket = new Ticket<>();
					Motorbike motorbike = new Motorbike(fields[3]);
					motorbike.setBaseTime(baseTime);
					ticket.setVehicle(motorbike);
					ticket.setId(id);
					ticket.setStartTime(time);
					this.tickets.add(ticket);
				}
					break;
				case 2: {
					Ticket<Wheelchair> ticket = new Ticket<>();
					Wheelchair wheelchair = new Wheelchair(fields[3]);
					wheelchair.setBaseTime(baseTime);
					ticket.setVehicle(wheelchair);
					ticket.setId(id);
					ticket.setStartTime(time);
					this.tickets.add(ticket);
				}
					break;
				}
			}

			// finish
			System.out.println("Read data from CSV file successfully!");
		} catch (Exception e) {
			System.err.println("An error occurs when reading data from file!");
		} finally {
			try {
				if (br != null) {
					br.close();
				}
			} catch (Exception e) {
				System.err.println("Error while closing BufferedReader!!!");
			}
		}
	}

	/**
	 * 
	 */
	public void run() {
		int option;
		Map<Integer, Runnable> functions = new HashMap<>();
		functions.put(1, () -> this.parkVehicle());
		functions.put(2, () -> this.printListTicket());
		functions.put(3, () -> this.sortTicketByType());
		functions.put(4, () -> this.sortTicketByParkingTime());
		functions.put(5, () -> this.searchTicket());
		functions.put(6, () -> this.writeCSV());
		functions.put(7, () -> this.readCSV());

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

	/**
	 * main method
	 * 
	 * @param args
	 */
	public static void main(String[] args) {
		new ParkingManagementSystem().run();
	}
}
