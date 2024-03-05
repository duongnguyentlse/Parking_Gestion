
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Scanner;

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

	/**
	 * @param id the id to set
	 */
	protected void setId(long id) {
		this.id = id;
	}

	/**
	 * @param startTime the startTime to set
	 */
	protected void setStartTime(Date startTime) {
		this.startTime = startTime;
	}

	/**
	 * @param vehicle the vehicle to set
	 */
	protected void setVehicle(T vehicle) {
		this.vehicle = vehicle;
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
		
		return "Ticket [ID=" + id + ", Start Time=" + startTime + ", End Time=" + endTime + ", Vehicle=" + vehicle
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
}
