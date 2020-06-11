using System;

using UIKit;

namespace NewAssigment
{
	public partial class ViewController : UIViewController
	{
		protected ViewController(IntPtr handle) : base(handle)
		{
			// Note: this .ctor should not contain any initialization logic.
		}

		public override void ViewDidLoad()
		{
			base.ViewDidLoad();


			genji.TouchUpInside += (object sender, EventArgs e) =>
			{
				secondViewController controller = this.Storyboard.InstantiateViewController("here") as secondViewController;
				controller.NameTitle = "Genji";
				controller.Image = "Genji_portrait.png";
				controller.Attack1 = "Shuriken:";
				controller.Info11 = "- 28 damage per round";
				controller.Info12 = " ";
				controller.Attack2 = "Swift Strike:";
				controller.Info21 = "- 50 damage";
				controller.Info22 = "- 15m range";
				controller.Attack3 = "Deflect:";
				controller.Info31 = "- 2 second duration";
				controller.Info32 = "- 8 second cooldown";
				controller.Attack4 = "Cyber Agility:";
				controller.Info41 = " ";
				controller.Info42 = " ";
				controller.Attack5 = "Dragonblades:";
				controller.Info51 = "- 120 damage";
				controller.Info52 = "- 5m range";
				this.NavigationController.PushViewController(controller, true);
			};
			mccree.TouchUpInside += (object sender, EventArgs e) =>
			{
				secondViewController controller = this.Storyboard.InstantiateViewController("here") as secondViewController;
				controller.NameTitle = "McCree";
				controller.Image = "Mccree_portrait.png";
				controller.Attack1 = "Peacekeeper:";
				controller.Info11 = "- 2-6 rounds per second";
				controller.Info12 = "- 35-70 damage";
				controller.Attack2 = "Combat Roll:";
				controller.Info21 = "- 6m range";
				controller.Info22 = "- 8 second cooldown";
				controller.Attack3 = "Flashbang:";
				controller.Info31 = "- 25 damage";
				controller.Info32 = "- 5m range";
				controller.Attack4 = "Deadeye:";
				controller.Info41 = "- 6 sec duration";
				controller.Info42 = "- \"its high noon\"";
				controller.Attack5 = "";
				controller.Info51 = "";
				controller.Info52 = "";
				this.NavigationController.PushViewController(controller, true);
			};
			pharah.TouchUpInside += (object sender, EventArgs e) =>
			{
				secondViewController controller = this.Storyboard.InstantiateViewController("here") as secondViewController;
				controller.NameTitle = "Pharah";
				controller.Image = "Pharah_portrait.png";
				controller.Attack1 = "Rocket Launcher:";
				controller.Info11 = "- 120 damage";
				controller.Info12 = "- 3m radius";
				controller.Attack2 = "Concussive Blast:";
				controller.Info21 = "- 8m radius";
				controller.Info22 = "- 12 second cooldown";
				controller.Attack3 = "Jump Jet:";
				controller.Info31 = "- 10 second cooldown";
				controller.Info32 = "";
				controller.Attack4 = "Hover Jet:";
				controller.Info41 = "- 2 second cooldown";
				controller.Info42 = "";
				controller.Attack5 = "Barrage:";
				controller.Info51 = "- 50 damage";
				controller.Info52 = "- 30 rounds per second";
				this.NavigationController.PushViewController(controller, true);
			};
			reaper.TouchUpInside += (object sender, EventArgs e) =>
			{
				secondViewController controller = this.Storyboard.InstantiateViewController("here") as secondViewController;
				controller.NameTitle = "Reaper";
				controller.Image = "Reaper_portrait.png";
				controller.Attack1 = "Hellfire:";
				controller.Info11 = "- 2 rounds per second";
				controller.Info12 = "- 140 damage";
				controller.Attack2 = "Wraith Form:";
				controller.Info21 = "- 3 second duration";
				controller.Info22 = "- 8 second cool down";
				controller.Attack3 = "Shadow Step:";
				controller.Info31 = "- 35m range";
				controller.Info32 = "- 2 second duration";
				controller.Attack4 = "The Reaping:";
				controller.Info41 = "- Gains health";
				controller.Info42 = "";
				controller.Attack5 = "Death Blossom:";
				controller.Info51 = "- 510 damage";
				controller.Info52 = "- 8m radius";
				this.NavigationController.PushViewController(controller, true);
			};
			soldier.TouchUpInside += (object sender, EventArgs e) =>
			{
				secondViewController controller = this.Storyboard.InstantiateViewController("here") as secondViewController;
				controller.NameTitle = "Soldier.76";
				controller.Image = "Soldier76_portrait.png";
				controller.Attack1 = "Pulse Rifle:";
				controller.Info11 = "- 10 rounds per second";
				controller.Info12 = "- 17 damge";
				controller.Attack2 = "Helix Rocket:";
				controller.Info21 = "- 120 damage";
				controller.Info22 = "- 8 second cooldown";
				controller.Attack3 = "Sprint:";
				controller.Info31 = "- Runs faster";
				controller.Info32 = "- No cooldown";
				controller.Attack4 = "Biotic Field:";
				controller.Info41 = "- 35 hp per second";
				controller.Info42 = "- 5m radius";
				controller.Attack5 = "Tactical Visor:";
				controller.Info51 = "- 6 second duration";
				controller.Info52 = "- Locks onto enemy";
				this.NavigationController.PushViewController(controller, true);
			};
			tracer.TouchUpInside += (object sender, EventArgs e) =>
			{
				secondViewController controller = this.Storyboard.InstantiateViewController("here") as secondViewController;
				controller.NameTitle = "Tracer";
				controller.Image = "Tracer_portrait.png";
				controller.Attack1 = "Pulse Pistols:";
				controller.Info11 = "- 6 damage";
				controller.Info12 = "- 4 rounds per shot";
				controller.Attack2 = "Blink:";
				controller.Info21 = "- 7m range";
				controller.Info22 = "- 3 second cooldown";
				controller.Attack3 = "Recall:";
				controller.Info31 = "- 1.25 second duration";
				controller.Info32 = "- 12 second cooldown";
				controller.Attack4 = "Pulse Bomb:";
				controller.Info41 = "- 400 max damage";
				controller.Info42 = "- 3m radius";
				controller.Attack5 = "";
				controller.Info51 = "";
				controller.Info52 = "";
				this.NavigationController.PushViewController(controller, true);
			};

		}

		public override void DidReceiveMemoryWarning()
		{
			base.DidReceiveMemoryWarning();
			// Release any cached data, images, etc that aren't in use.
		}
	}
}

