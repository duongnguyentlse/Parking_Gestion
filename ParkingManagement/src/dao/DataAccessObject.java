package dao;

import domain.User;
import domain.UserType;
import domain.Car;
import domain.Motorbike;
import domain.Ticket;
import domain.Wheelchair;

import java.text.ParseException;
import java.text.SimpleDateFormat;

public class DataAccessObject {
	private long id;
	private String startTime;
	private int type;
	private String licensePlate;
	private int baseTime;
	private int userId;
	private String userName;
	private UserType userType;
	private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd~hh:mm:ss");

	public DataAccessObject(long id, String startTime, int type, String licensePlate, int baseTime, int userId,
			String userName, UserType userType) {
		this.id = id;
		this.startTime = startTime;
		this.type = type;
		this.licensePlate = licensePlate;
		this.baseTime = baseTime;
		this.userId = userId;
		this.userName = userName;
		this.userType = userType;
	}

	public DataAccessObject(final Ticket<?> ticket) {
		this.id = ticket.getId();
		this.startTime = DATE_FORMAT.format(ticket.getStartTime());
		this.type = ticket.getVehicle() instanceof Car ? 0 : ticket.getVehicle() instanceof Motorbike ? 1 : 2;
		this.licensePlate = ticket.getVehicle().getLicensePlate();
		this.baseTime = ticket.getVehicle().getBaseTime();
		this.userId = ticket.getUser().getUserId();
		this.userName = ticket.getUser().getUserName();
		this.userType = ticket.getUser().getUserType();
	}

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public String getStartTime() {
		return startTime;
	}

	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}

	public int getType() {
		return type;
	}

	public void setType(int type) {
		this.type = type;
	}

	public String getLicensePlate() {
		return licensePlate;
	}

	public void setLicensePlate(String licensePlate) {
		this.licensePlate = licensePlate;
	}

	public int getBaseTime() {
		return baseTime;
	}

	public void setBaseTime(int baseTime) {
		this.baseTime = baseTime;
	}

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public UserType getUserType() {
		return userType;
	}

	public void setUserType(UserType userType) {
		this.userType = userType;
	}

	@Override
	public String toString() {
		// 1672648957570,2023-01-02~14:00:00,2,345,60,1,userA,NORMAL
		return String.format("%d,%s,%d,%s,%d,%d,%s,%s", this.id, this.startTime, this.type, this.licensePlate,
				this.baseTime, this.userId, this.userName, this.userType);
	}

	public static DataAccessObject parse(String line) {
		String[] tokens = line.split(",");
		long id = Long.parseLong(tokens[0]);
		String startTime = tokens[1];
		int type = Integer.parseInt(tokens[2]);
		String licensePlate = tokens[3];
		int baseTime = Integer.parseInt(tokens[4]);
		int userId = Integer.parseInt(tokens[5]);
		String userName = tokens[6];
		UserType userType = UserType.valueOf(tokens[7]);
		return new DataAccessObject(id, startTime, type, licensePlate, baseTime, userId, userName, userType);
	}

	@SuppressWarnings(value = { "rawtypes", "unchecked" })
	public Ticket toTicket() throws ParseException {
		Ticket ticket = new Ticket();
		ticket.setId(this.id);
		ticket.setStartTime(DATE_FORMAT.parse(this.startTime));
		switch (this.type) {
		case 0:
			Car car = new Car(this.licensePlate);
			car.setBaseTime(this.baseTime);
			ticket.setVehicle(car);
			break;
		case 1:
			Motorbike motorbike = new Motorbike(this.licensePlate);
			motorbike.setBaseTime(this.baseTime);
			ticket.setVehicle(motorbike);
			break;
		case 2:
			Wheelchair wheelchair = new Wheelchair(this.licensePlate);
			wheelchair.setBaseTime(this.baseTime);
			ticket.setVehicle(wheelchair);
			break;
		}

		// set user
		User user = new User(this.userId, this.userName, this.userType);
		ticket.setUser(user);

		return ticket;
	}
}
