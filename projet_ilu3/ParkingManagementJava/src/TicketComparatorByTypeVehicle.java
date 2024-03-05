import java.util.Comparator;

public class TicketComparatorByTypeVehicle implements Comparator<Ticket<?>> {

	@Override
	public int compare(Ticket<?> t1, Ticket<?> t2) {
		return t1.getVehicle().getClass().getName().compareTo(t2.getVehicle().getClass().getName());
	}

}
