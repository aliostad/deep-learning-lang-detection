package iterator;

import list.ListIF;

public class ListIterator<T> implements IteratorIF<T> {
	
	private ListIF<T> handler;
	private ListIF<T> restart;
	
	public ListIterator (ListIF<T> handler) {
		
		this.handler = handler;
		this.restart = handler;
	}

	@Override
	public T getNext() {
		
		T element = handler.getFirst();
		handler = handler.getTail();
		return element;
	}

	@Override
	public boolean hasNext() {
		
		return !handler.isEmpty();
	}

	@Override
	public void reset() {

		handler = restart;		
	}

}
