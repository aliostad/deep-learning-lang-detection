using NSubstitute;
using NUnit.Framework;

namespace Unorthoducks
{
  public class CloudControllerTests
  {
    private ICloudMovementController cloudMovementController;
    private CloudController controller;

    [SetUp]
    public void BeforeTest ()
    {
      cloudMovementController = GetCloudMovementControllerMock ();
      controller = new CloudController ();
      controller.SetCloudMovementController (cloudMovementController);
    }

    [Test]
    public void Move ()
    {
      controller.Move ();
      cloudMovementController.Received (1).Move ();
    }

    private ICloudMovementController GetCloudMovementControllerMock ()
    {
      return Substitute.For<ICloudMovementController> ();
    }
  }
}
