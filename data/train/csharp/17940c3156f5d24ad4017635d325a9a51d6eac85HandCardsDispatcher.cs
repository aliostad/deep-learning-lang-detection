using Players;
using Controllers;

using Cards;


namespace Games.Helpers
{
	public class HandCardsDispatcher : PerCardProcessor<Player>
	{
        private Card cardToDispatch;

		protected override void AssignCard (Player player)
		{
            if (cardToDispatch == null)
            {
                cardToDispatch = DeckController.Instance.GetCard();
                cardToDispatch.Move(player.transform.position, () => {
                    player.AddCardToHand(cardToDispatch);

                    cardToDispatch = null;
                    base.AssignCard(player);
                });
            }
        }
	}
}
