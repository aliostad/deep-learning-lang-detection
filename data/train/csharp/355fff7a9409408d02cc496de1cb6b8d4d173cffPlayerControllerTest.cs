using UnityEngine;
using NUnit.Framework;
using NSubstitute;
using System.Collections;

[TestFixture]
public class PlayerControllerTest : MonoBehaviour {
	[Test]
	public void Incantate_Test()
	{
		// Arrange
		var animatorController = GetAnimatorControllerMock();
		var controller = GetPlayerControllerMock (animatorController);
		// Act
		controller.IncantatePrimary();
		// Assert
		animatorController.Received().SetBool ("Incantate", true);
	}

	[Test]
	public void StopIncantating_Test()
	{
		// Arrange
		var animatorController = GetAnimatorControllerMock ();
		var controller = GetPlayerControllerMock (animatorController);
		// Act
		controller.StopIncantating();
		// Assert
		animatorController.Received ().SetBool ("Incantate", false);
	}

	[Test]
	public void SetPosition_Test_SamePosition()
	{
		// Arrange
		var movementController = GetPlayerMovementControllerMock();
		var animatorController = GetAnimatorControllerMock();
		var gridcontroller = GetGridControllerMock ();
		var controller = GetPlayerControllerMock (animatorController, movementController, gridcontroller);
		var square = GetSquareMock ();
		square.GetSubPosition (0).ReturnsForAnyArgs (new Vector3(0, 0, 0));
		square.GetResources ().Returns (new SquareContent());
		gridcontroller.GetSquare (0, 0).Returns(square);
		// Act
		controller.SetPosition (0, 0, gridcontroller);
		// Assert
		movementController.Received ().SetDestination (new Vector3(0, 0, 0));
	}

	[Test]
	public void SetPosition_Test_DifferentPosition()
	{
		// Arrange
		var movementController = GetPlayerMovementControllerMock();
		var animatorController = GetAnimatorControllerMock();
		var gridcontroller = GetGridControllerMock ();
		var controller = GetPlayerControllerMock (animatorController, movementController, gridcontroller);
		var square = GetSquareMock ();
		square.GetSubPosition (0).ReturnsForAnyArgs (new Vector3(3, 3, 3));
		gridcontroller.GetSquare (3, 3).Returns(square);
		// Act
		controller.SetPosition (3, 3, gridcontroller);
		// Assert
		movementController.Received ().SetDestination (new Vector3(3, 3, 3));
	}
	
	[Test]
	public void GoToDestination_Test_North()
	{
		// Arrange
		var movementController = GetPlayerMovementControllerMock();
		var animatorController = GetAnimatorControllerMock ();
		var controller = GetPlayerControllerMock (animatorController, movementController, GetGridControllerMock());
		// Act
		controller.GoToDestination (Orientation.NORTH);
		// Assert
		animatorController.Received ().SetBool ("Walk", true);
		animatorController.Received ().SetInteger ("Orientation", 1);
		movementController.Received ().MoveToDestination (Arg.Any<Vector3>(), Arg.Any<float>());
	}

	[Test]
	public void GoToDestination_Test_East()
	{
		// Arrange
		var movementController = GetPlayerMovementControllerMock();
		var animatorController = GetAnimatorControllerMock ();
		var controller = GetPlayerControllerMock (animatorController, movementController, GetGridControllerMock());
		// Act
		controller.GoToDestination (Orientation.EAST);
		// Assert
		animatorController.Received ().SetBool ("Walk", true);
		animatorController.Received ().SetInteger ("Orientation", 2);
		movementController.Received ().MoveToDestination (Arg.Any<Vector3>(), Arg.Any<float>());
	}

	[Test]
	public void GoToDestination_Test_South()
	{
		// Arrange
		var movementController = GetPlayerMovementControllerMock();
		var animatorController = GetAnimatorControllerMock ();
		var controller = GetPlayerControllerMock (animatorController, movementController, GetGridControllerMock());
		// Act
		controller.GoToDestination (Orientation.SOUTH);
		// Assert
		animatorController.Received ().SetBool ("Walk", true);
		animatorController.Received ().SetInteger ("Orientation", 3);
		movementController.Received ().MoveToDestination (Arg.Any<Vector3>(), Arg.Any<float>());
	}

	[Test]
	public void GoToDestination_Test_West()
	{
		// Arrange
		var movementController = GetPlayerMovementControllerMock();
		var animatorController = GetAnimatorControllerMock ();
		var controller = GetPlayerControllerMock (animatorController, movementController, GetGridControllerMock());
		// Act
		controller.GoToDestination (Orientation.WEST);
		// Assert
		animatorController.Received ().SetBool ("Walk", true);
		animatorController.Received ().SetInteger ("Orientation", 4);
		movementController.Received ().MoveToDestination (Arg.Any<Vector3>(), Arg.Any<float>());
	}

	[Test]
	public void MoveToRotation_Test_North()
	{
		// Arrange
		var movementController = GetPlayerMovementControllerMock();
		var animatorController = GetAnimatorControllerMock ();
		var controller = GetPlayerControllerMock (animatorController, movementController, GetGridControllerMock());
		// Act
		controller.SetPlayerOrientation(Orientation.NORTH);
		controller.GoToDestination (Orientation.NORTH);
		// Assert
		movementController.Received ().MoveToRotation (Quaternion.Euler(0, 0, 0), Arg.Any<float>());
	}
	
	[Test]
	public void MoveToRotation_Test_East()
	{
		// Arrange
		var movementController = GetPlayerMovementControllerMock();
		var animatorController = GetAnimatorControllerMock ();
		var controller = GetPlayerControllerMock (animatorController, movementController, GetGridControllerMock());
		// Act
		controller.SetPlayerOrientation(Orientation.EAST);
		controller.GoToDestination (Orientation.NORTH);
		// Assert
		movementController.Received ().MoveToRotation (Quaternion.Euler(0, 90, 0), Arg.Any<float>());
	}
	
	[Test]
	public void MoveToRotation_Test_South()
	{
		// Arrange
		var movementController = GetPlayerMovementControllerMock();
		var animatorController = GetAnimatorControllerMock ();
		var controller = GetPlayerControllerMock (animatorController, movementController, GetGridControllerMock());
		// Act
		controller.SetPlayerOrientation(Orientation.SOUTH);
		controller.GoToDestination (Orientation.NORTH);
		// Assert
		movementController.Received ().MoveToRotation (Quaternion.Euler(0, 180, 0), Arg.Any<float>());
	}
	
	[Test]
	public void MoveToRotation_Test_West()
	{
		// Arrange
		var movementController = GetPlayerMovementControllerMock();
		var animatorController = GetAnimatorControllerMock ();
		var controller = GetPlayerControllerMock (animatorController, movementController, GetGridControllerMock());
		// Act
		controller.SetPlayerOrientation(Orientation.WEST);
		controller.GoToDestination (Orientation.NORTH);
		// Assert
		movementController.Received ().MoveToRotation (Quaternion.Euler(0, 270, 0), Arg.Any<float>());;
	}

	public IPlayerMotorController GetPlayerMovementControllerMock()
	{
		return Substitute.For<IPlayerMotorController>();
	}

	public IAnimatorController GetAnimatorControllerMock(){
		return Substitute.For<IAnimatorController>();
	}

	public GridController GetGridControllerMock()
	{
		return Substitute.For<GridController>();
	}

	public ISquare GetSquareMock()
	{
		return Substitute.For<ISquare>();
	}

	public PlayerController GetPlayerControllerMock()
	{
		return Substitute.For<PlayerController>();
	}

	public PlayerController GetPlayerControllerMock(IPlayerMotorController movementController)
	{
		var controller = Substitute.For<PlayerController>();
		controller.SetPlayerMovementController(movementController);
		return controller;
	}

	public PlayerController GetPlayerControllerMock(IAnimatorController animatorController)
	{
		var controller = Substitute.For<PlayerController>();
		controller.SetAnimatorController(animatorController);
		return controller;
	}

	public PlayerController GetPlayerControllerMock(IAnimatorController animatorController, IPlayerMotorController movementController, GridController gridController)
	{
		var controller = Substitute.For<PlayerController>();
		controller.SetAnimatorController(animatorController);
		controller.SetPlayerMovementController(movementController);
		controller.SetGridController (gridController);
		movementController.IsMoving (Vector3.zero, Quaternion.identity).ReturnsForAnyArgs(true);
		return controller;
	}
}
