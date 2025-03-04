package domain;

import java.util.List;
import java.util.Scanner;

public class User {
	public static int userCount = 0;

	private int userId;
	private String userName;
	private UserType userType;

	public User(int userId, String userName, UserType userType) {
		this.userId = userId;
		this.userName = userName;
		this.userType = userType;
	}

	public User() {
	}

	public int getUserId() {
		return userId;
	}

	public String getUserName() {
		return userName;
	}

	public UserType getUserType() {
		return userType;
	}

	@SuppressWarnings("resource")
	public static User createUser(List<User> users) {
		User user = new User();
		Scanner scanner = new Scanner(System.in);

		user.userId = ++userCount;
		System.out.print("Enter your userName: ");
		user.userName = scanner.nextLine();
		if (users.stream().anyMatch(u -> u.userName.equals(user.userName.strip()))) {
			return users.stream().filter(u -> u.userName.equals(user.userName.strip())).findFirst().get();
		}
		System.out.print("Are you disable? (yes/no): ");
		user.userType = Boolean.parseBoolean(scanner.nextLine()) ? UserType.DISABLE : UserType.NORMAL;

		return user;
	}
}
