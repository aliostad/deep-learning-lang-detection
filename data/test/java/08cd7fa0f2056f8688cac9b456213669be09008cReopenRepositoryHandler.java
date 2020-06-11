package gw2trades.server.frontend;

import gw2trades.repository.api.ItemRepository;
import gw2trades.repository.api.RecipeRepository;
import io.vertx.core.Handler;
import io.vertx.ext.web.RoutingContext;

import java.io.IOException;

/**
 * @author Stefan Lotties (slotties@gmail.com)
 */
public class ReopenRepositoryHandler implements Handler<RoutingContext> {
    private final ItemRepository itemRepository;
    private final RecipeRepository recipeRepository;

    public ReopenRepositoryHandler(ItemRepository itemRepository, RecipeRepository recipeRepository) {
        this.itemRepository = itemRepository;
        this.recipeRepository = recipeRepository;
    }

    @Override
    public void handle(RoutingContext event) {
        try {
            this.itemRepository.reopen();
            this.recipeRepository.reopen();

            event.response().end("OK");
        } catch (IOException e) {
            event.fail(e);
        }
    }
}
