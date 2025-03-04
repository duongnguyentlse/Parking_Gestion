package domain;

/**
 * This interface is used for chargeable objects
 * 
 * @author TungDuong
 *
 */
public interface Chargeable {
	/**
	 * This method helps to calculate the total parking fee in the case of allowed
	 * time
	 * 
	 * @return total parking fee
	 */
	double calculateFare();

	/**
	 * This method helps to calculate the total parking fee in the case of overtime
	 * 
	 * @return total parking fee
	 */
	double calculateFire();
}
