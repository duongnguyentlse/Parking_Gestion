import java.util.Iterator;
import java.util.List;
import java.util.NoSuchElementException;

/**
 * Using iterator to traverse collection of Vehicle
 * 
 * @author TungDuong
 *
 */
public class TicketIterator implements Iterable<Ticket<? extends Vehicle>> {
    private final List<Ticket<? extends Vehicle>> tickets;

    public TicketIterator(List<Ticket<? extends Vehicle>> tickets) {
        if (tickets == null) {
            throw new IllegalArgumentException("Tickets list cannot be null");
        }
        this.tickets = tickets;
    }

    @Override
    public Iterator<Ticket<? extends Vehicle>> iterator() {
        return new Iterator<Ticket<? extends Vehicle>>() {
            private int currentIndex = 0;

            @Override
            public boolean hasNext() {
                while (currentIndex < tickets.size()) {
                    if (tickets.get(currentIndex) != null) {
                        return true;
                    }
                    currentIndex++;
                }
                return false;
            }

            @Override
            public Ticket<? extends Vehicle> next() {
                if (!hasNext()) {
                    throw new NoSuchElementException();
                }
                return tickets.get(currentIndex++);
            }
        };
    }
}
