import java.util.Comparator;

public class TicketComparatorByParkingTime implements Comparator<Ticket<?>> {

	@Override
	public int compare(Ticket<?> t1, Ticket<?> t2) {
		return t1.getStartTime().compareTo(t2.getStartTime());
	}

}
