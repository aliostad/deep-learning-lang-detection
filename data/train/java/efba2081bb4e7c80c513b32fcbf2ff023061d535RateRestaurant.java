package co.hodler.actions;

import co.hodler.infrastructure.repositories.RestaurantRepository;
import co.hodler.infrastructure.repositories.VisitRepository;
import co.hodler.model.Rating;
import co.hodler.model.Visit;

public class RateRestaurant {

  private RestaurantRepository restaurantRepository;
  private VisitRepository visitRepository;

  public RateRestaurant(RestaurantRepository restaurantRepository, VisitRepository visitRepository) {
    this.restaurantRepository = restaurantRepository;
    this.visitRepository = visitRepository;
  }

  public void rate(Rating rating) {
    if (allowedToRate(rating)) {
      restaurantRepository.persist(rating);
    }
  }

  private boolean allowedToRate(Rating rating) {
    return visitRepository.exists(new Visit(rating.getRestaurantId(), rating.getUserId()))
        && visitRepository.isRated(new Visit(rating.getRestaurantId(), rating.getUserId()));
  }

}
