package metadatarepo.core.promotion;

import messaging.Reveiver;

/**
 * @author Gregory Boissinot
 */
public class PromotionRepositoryReceiver implements Reveiver<PromotionEvent> {

    private final PromotionRepository promotionRepository;

    public PromotionRepositoryReceiver(PromotionRepository promotionRepository) {
        this.promotionRepository = promotionRepository;
    }

    @Override
    public void receive(PromotionEvent promotionEvent) {
        promotionRepository.promote(
                promotionEvent.getPreviousModuleId(),
                promotionEvent.getNewModuleStatus());
    }
}
