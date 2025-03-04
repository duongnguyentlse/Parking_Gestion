package domain;

import java.util.Comparator;
import java.util.Map.Entry;

public class TicketComparatorByTypeVehicle implements Comparator<Entry<Vehicle, Ticket<?>>> {

	@Override
	public int compare(Entry<Vehicle, Ticket<?>> t1, Entry<Vehicle, Ticket<?>> t2) {
		return t1.getValue().getVehicle().getClass().getName()
				.compareTo(t2.getValue().getVehicle().getClass().getName());
	}

}
