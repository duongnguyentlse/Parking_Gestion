package domain;

import java.util.Comparator;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Map.Entry;
import java.util.NoSuchElementException;
import java.util.stream.Collectors;

public class Parking implements Iterable<Ticket<? extends Vehicle>> {

	private Map<Vehicle, Ticket<? extends Vehicle>> tickets;

	public Parking() {
		this.tickets = new LinkedHashMap<>();
	}

	public void addTicket(Ticket<? extends Vehicle> ticket) {
		this.tickets.put(ticket.getVehicle(), ticket);
	}

	public Ticket<? extends Vehicle> removeTicket(Vehicle vehicle) {
		return this.tickets.remove(vehicle);
	}

	public Ticket<? extends Vehicle> removeTicket(String licensePlate) {
		return this.tickets.remove(findVehicle(licensePlate));
	}

	public boolean checkExists(final String licensePlate) {
		return this.tickets.keySet().stream().anyMatch(v -> v.getLicensePlate().equals(licensePlate));
	}

	public Vehicle findVehicle(final String licensePlate) {
		return this.tickets.keySet().stream().filter(v -> v.getLicensePlate().equals(licensePlate)).findFirst()
				.orElse(null);
	}

	public boolean isEmpty() {
		return this.tickets.isEmpty();
	}

	public Ticket<? extends Vehicle> getTicket(String licensePlate) {
		return this.tickets.get(findVehicle(licensePlate));
	}

	public void sortTickets(Comparator<Entry<Vehicle, Ticket<?>>> comparator) {
		this.tickets = this.tickets.entrySet().stream().sorted(comparator)
				.collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue, (e1, e2) -> e1, LinkedHashMap::new));
	}

	@Override
	public Iterator<Ticket<? extends Vehicle>> iterator() {
		return new ParkingIterator();
	}

	/**
	 * Custom iterator for Parking
	 */
	private class ParkingIterator implements Iterator<Ticket<? extends Vehicle>> {
		private final Iterator<Map.Entry<Vehicle, Ticket<? extends Vehicle>>> entryIterator;

		public ParkingIterator() {
			this.entryIterator = tickets.entrySet().iterator();
		}

		@Override
		public boolean hasNext() {
			return entryIterator.hasNext();
		}

		@Override
		public Ticket<? extends Vehicle> next() {
			if (!hasNext()) {
				throw new NoSuchElementException("No more tickets in the parking");
			}
			return entryIterator.next().getValue();
		}

		@Override
		public void remove() {
			throw new UnsupportedOperationException("Remove operation is not supported");
		}
	}
}
