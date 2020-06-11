package no.antares.kickstart.item;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;


@Service("itemService")
public class ItemService {
	private ItemRepository	repository;

	public ItemService(ItemRepository repository) {
		this.repository = repository;
	}

	public ItemService() {
	}

	@Resource(name = "itemRepository")
	protected void setItemRepository(ItemRepository repository) {
		this.repository = repository;
	}

	public Item findById(Integer id) {
		return repository.findById( id );
	}

	public void update(Item i) {
		repository.update( i );
	}

}
