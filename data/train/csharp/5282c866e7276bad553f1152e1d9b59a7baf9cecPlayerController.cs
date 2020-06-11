using System;
using UnityEngine;

namespace HitPoint6.Unity.StratosSylphs.GameUnitControllers
{
	using GameUnits;

	[Serializable]
	public class PlayerController
	{
		[SerializeField]
		private PlayerMoveController _MoveController;

		[SerializeField]
		private PlayerStateController _StateController;

		[SerializeField]
		private PlayerFiringController _FiringController;

		[SerializeField]
		private PlayerBombController _BombController;

		[SerializeField]
		private PlayerColliderController _ColliderController;

		[SerializeField]
		private PlayerAnimationController _AnimationController;

		[SerializeField]
		private PlayerLifeController _LifeController;

		public PlayerMoveController MoveController
		{
			get { return _MoveController; }
		}

		public PlayerStateController StateController
		{
			get
			{ return _StateController; }
		}

		public PlayerFiringController FiringController
		{
			get { return _FiringController; }
		}

		public PlayerBombController BombController
		{
			get { return _BombController; }
		}

		public PlayerLifeController LifeController
		{
			get { return _LifeController; }
		}

		public PlayerColliderController ColliderController
		{
			get { return _ColliderController; }
		}

		public PlayerController ()
		{
			_AnimationController = new PlayerAnimationController ();
		}

		public void Awake (Player player)
		{
			_FiringController.Awake (player);
			_BombController.Awake ();
			_LifeController.Awake (player);
			_StateController.Awake (player);
		}

		public void Start (Player player)
		{
			_MoveController.Start (player);
			_StateController.Start (player);
			_FiringController.Start (player);
			_BombController.Start (player);
			_ColliderController.Start (player);
			_AnimationController.Start (player);
		}
	}
}