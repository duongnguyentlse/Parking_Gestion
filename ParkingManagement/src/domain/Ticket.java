package domain;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Scanner;
import java.util.stream.Collectors;

/**
 * Class Ticket supports to create a parking ticket for a vehicle
 * 
 * @author TungDuong
 *
 */
public class Ticket<T extends Vehicle> {
	private long id;
	private Date startTime;
	private Date endTime;
	private T vehicle;
	private User user;

	public static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd hh:mm");

	/**
	 * @param id the id to set
	 */
	public void setId(long id) {
		this.id = id;
	}

	/**
	 * @param startTime the startTime to set
	 */
	public void setStartTime(Date startTime) {
		this.startTime = startTime;
	}

	/**
	 * @param vehicle the vehicle to set
	 */
	public void setVehicle(T vehicle) {
		this.vehicle = vehicle;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	/**
	 * This method helps to input end time to remove vehicle
	 * 
	 * @return false in case failure
	 * @author TungDuong
	 */
	@SuppressWarnings("resource")
	public boolean removeVehicle() {
		try {
			Scanner scanner = new Scanner(System.in);
			SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm");
			while (true) {
				try {
					System.out.print("Input end time (format yyyy-MM-dd hh:mm): ");
					this.endTime = simpleDateFormat.parse(scanner.nextLine());

					if (this.endTime.before(this.startTime)) {
						System.err.println("End time must be after start time!");
					} else {
						break;
					}
				} catch (Exception e) {
					System.err.println("Invalid end time! " + e);
				}
			}

			return true;
		} catch (Exception e) {
			System.err.println("An error occurs! " + e);
			return false;
		}
	}

	public T getVehicle() {
		return vehicle;
	}

	@Override
	public String toString() {
		if (this.endTime == null) {
			Date now = new Date();
			long diff = now.getTime() - this.getStartTime().getTime();
			long minutes = diff / 60 / 1000;
			this.vehicle.setTotalParkingTime(minutes);
		}

		return "Ticket [ID=" + id + ", Start Time=" + DATE_FORMAT.format(startTime) + ", Vehicle=" + vehicle
				+ ", Total Fee=" + (vehicle.calculateFare() + vehicle.calculateFire()) + "]";
	}

	/**
	 * @return the id
	 */
	public long getId() {
		return id;
	}

	/**
	 * @return the startTime
	 */
	public Date getStartTime() {
		return startTime;
	}

	/**
	 * @return the endTime
	 */
	public Date getEndTime() {
		return endTime;
	}

	public static List<User> extractUsers(Collection<Ticket<?>> tickets) {
		return tickets.stream().map(Ticket::getUser).distinct().collect(Collectors.toList());
	}

	public static List<User> extractUsers(Iterator<Ticket<? extends Vehicle>> tickets) {
		List<User> users = new ArrayList<>();
		while (tickets.hasNext()) {
			Ticket<? extends Vehicle> ticket = tickets.next();
			User user = ticket.getUser();
			if (user != null && !users.contains(user)) {
				users.add(user);
			}
		}
		return users;
	}
}
