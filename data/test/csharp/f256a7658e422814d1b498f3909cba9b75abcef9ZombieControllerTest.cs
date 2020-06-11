using NSubstitute;
using NUnit.Framework;

namespace Unorthoducks
{
  public class ZombieControllerTests
  {
    private IDuckMovementController zombieMovementController;
    private ZombieController controller;

    [SetUp]
    public void BeforeTest ()
    {
      zombieMovementController = GetZombieMovementMock ();
      controller = new ZombieController ();
      controller.SetMovementController (zombieMovementController);
    }

    [Test]
    public void MoveWorks ()
    {
      controller.Move ();
      zombieMovementController.Received (1).Move ();
    }

    private IDuckMovementController GetZombieMovementMock ()
    {
      return Substitute.For<IDuckMovementController> ();
    }
  }
}
