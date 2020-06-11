using NSubstitute;
using NUnit.Framework;

namespace Unorthoducks
{
  public class LandscapeControllerTests
  {
    private ILandscapeController landscapeController;
    private LandscapeController controller;

    [SetUp]
    public void BeforeTest ()
    {
      landscapeController = GetLandscapeControllerMock ();
      controller = new LandscapeController ();
      controller.SetLandscapeController (landscapeController);
    }

    [Test]
    public void InitialiseWorks ()
    {
      controller.Initialise ();
      landscapeController.Received (1).Initialise ();
    }

    [Test]
    public void SpawnFloorWorks ()
    {
      controller.SpawnFloor ();
      landscapeController.Received (1).SpawnFloor ();
    }

    [Test]
    public void SpawnCavesWorks ()
    {
      controller.SpawnCaves ();
      landscapeController.Received (1).SpawnCaves ();
    }

    private ILandscapeController GetLandscapeControllerMock ()
    {
      return Substitute.For<ILandscapeController> ();
    }
  }
}
