package domain;

import java.util.Comparator;
import java.util.Map.Entry;

public class TicketComparatorByParkingTime implements Comparator<Entry<Vehicle, Ticket<?>>> {

	@Override
	public int compare(Entry<Vehicle, Ticket<?>> t1, Entry<Vehicle, Ticket<?>> t2) {
		return t1.getValue().getStartTime().compareTo(t2.getValue().getStartTime());
	}

}
