using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class GUIManager : MonoBehaviour {

	public bool random = false;
	public bool loop = false;
	public List<string> animations;
	public bool servo = true;

	public float width = 30;
	public float height = 30;

	public List<string> soundLists;
	public float soundVolume;

	public NetworkManager networkManager;

	void OnGUI() {

		int index = 0;
		int indexZ = 0;
		int UnitWidth = Screen.width/3;
		int UnitHeight = Screen.height/3;

		width = UnitWidth;
		height = UnitHeight;
		/*

		foreach(string anim in animations)
		{
			if (GUI.Button (new Rect (index*width, indexZ*height, width, height), anim)) 
			{
				networkManager.setRandom(false);
				networkManager.PlayAnimation(anim);
			}
			
			index++;
		}
		indexZ++;
		index = 0;
	

		foreach (string soundName in soundLists) 
		{
			if (GUI.Button (new Rect (index*width, indexZ*height, width, height), soundName)) 
			{
				networkManager.PlaySound(soundName,soundVolume);
			}
			index++;	

			if(index >=6)
			{
				indexZ++;
				index =0;
			}
		}


		indexZ++;
		index = 0;

		if (GUI.Button (new Rect (index*width, indexZ*height, width, height), "servo:"+servo)) 
		{
			servo = !servo;
			networkManager.Servo(servo);
		}


		indexZ++;
		index = 0;
		if (GUI.Button (new Rect (index*width, indexZ*height, width, height), "random("+random+")")) 
		{
			random = !random;
			networkManager.setRandom(random);
		}
		index++;
		if (GUI.Button (new Rect (index*width, indexZ*height, width, height), "loop("+loop+")")) 
		{
			loop = !loop;
			networkManager.setLoop(loop);
		}
		index++;

		indexZ++;
		index = 0;
		*/

		index = 0;

		if (GUI.Button (new Rect (index*width, indexZ*height, width, height), "Pull")) 
		{
			CancelInvoke();

			networkManager.PlayAnimation("Normal");
			networkManager.PlaySound("assets/FunnyBoy.mp3",1);
			networkManager.Servo(true);

			Invoke("ServoDown",1);
			Invoke("ServoUp",2);
			Invoke("ServoDown",3);
			Invoke("Normal", 3);
			Invoke("ServoUp",4);

			
			Invoke("Normal", 6);
		}

		index++;

		if (GUI.Button (new Rect (index*width, indexZ*height, width, height), "Hello")) 
		{
			CancelInvoke();
			
			networkManager.PlayAnimation("Normal");
			networkManager.PlaySound("assets/Hello.mp3",1);
			networkManager.Servo(true);
			
			Invoke("ServoDown",1);
			Invoke("ServoUp",2);
			Invoke("ServoDown",3);
			Invoke("ServoUp",4);
			Invoke("Normal", 3);


			//Invoke("Blink", 5);
		}
		
		index++;



		if (GUI.Button (new Rect (index*width, indexZ*height, width, height), "Pew")) 
		{
			CancelInvoke();
			
			//networkManager.PlayAnimation("Shine");
			this.ShineFaceNext();
			networkManager.PlaySound("assets/Pew.mp3",1);
			networkManager.FlipServo();


		}

		indexZ++;
		index=0;

		if (GUI.Button (new Rect (index*width, indexZ*height, width, height), "ByeBye")) 
		{
			CancelInvoke();
			
			networkManager.PlayAnimation("Normal");
			networkManager.PlaySound("assets/ByeBye.mp3",1);
			Invoke("ServoDown",1);
			Invoke("ServoUp",2);
			Invoke("ServoDown",3);
			Invoke("ServoUp",4);
			Invoke("Normal", 3);
			
		}
		index++;


		
		if (GUI.Button (new Rect (index*width, indexZ*height, width, height), "Pat")) 
		{
			CancelInvoke();
			
			networkManager.PlayAnimation("Love");
			networkManager.PlaySound("assets/LoveUDaddy.mp3",1);
			networkManager.Servo(true);
			
			Invoke("ServoDown",1);
			Invoke("ServoUp",2);
			Invoke("ServoDown",3);
			Invoke("ServoUp",4);

			Invoke("Normal", 6);
		}

		index++;

		if (GUI.Button (new Rect (index*width, indexZ*height, width, height), "Cry")) 
		{
			CancelInvoke();
			
			networkManager.PlayAnimation("Cry");
			networkManager.PlaySound("assets/What.mp3",1);
			networkManager.Servo(true);
			
			Invoke("ServoDown",1);
			Invoke("ServoUp",2);
			Invoke("ServoDown",3);
			Invoke("ServoUp",4);


			
			Invoke("Normal", 6);
		}

		indexZ++;
		index=0;
		
		if (GUI.Button (new Rect (index*width, indexZ*height, width, height), "badSmile")) 
		{
			CancelInvoke();
			
			networkManager.PlayAnimation("Happy");
			networkManager.PlaySound("assets/Hehehe.mp3",1);


			networkManager.Servo(true);
			Invoke("ServoDown",1);
			Invoke("ServoUp",2);
			Invoke("ServoDown",3);
			Invoke("ServoUp",4);

			
			Invoke("Normal", 6);
		}

		index++;
		
		if (GUI.Button (new Rect (index*width, indexZ*height, width, height), "Dazzy")) 
		{
			CancelInvoke();
			
			networkManager.PlayAnimation("Dazzy");
			networkManager.PlaySound("assets/Nay.mp3",1);
			
			
			networkManager.Servo(true);
			Invoke("ServoDown",1f);
			Invoke("ServoUp",1.5f);
			Invoke("ServoDown",2f);
			Invoke("ServoUp",2.5f);
			Invoke("ServoDown",3f);
			Invoke("ServoUp",3.5f);
			Invoke("ServoDown",4f);
			Invoke("ServoUp",4.5f);
			Invoke("ServoDown",5f);
			Invoke("ServoUp",5.5f);
			Invoke("ServoDown",6f);
			Invoke("ServoUp",6.5f);
			Invoke("ServoDown",7f);
			Invoke("ServoUp",7.5f);
			Invoke("ServoDown",8f);
			Invoke("ServoUp",8.5f);
			Invoke("ServoDown",9f);
			Invoke("ServoUp",9.5f);
			Invoke("ServoDown",10f);
			Invoke("ServoUp",10.5f);
			Invoke("ServoDown",11f);
			Invoke("ServoUp",11.5f);
			Invoke("ServoDown",12f);
			Invoke("ServoUp",12.5f);
			Invoke("ServoDown",13f);
			Invoke("ServoUp",13.5f);
			Invoke("ServoDown",14f);
			Invoke("ServoUp",14.5f);
			Invoke("ServoDown",15f);
			Invoke("ServoUp",15.5f);
			Invoke("ServoDown",16f);
			Invoke("ServoUp",16.5f);
			Invoke("ServoDown",17f);
			Invoke("ServoUp",17.5f);
			Invoke("ServoDown",18f);
			Invoke("ServoUp",18.5f);

			Invoke("Normal", 19);


		}

		index++;

		if (GUI.Button (new Rect (index * width, indexZ * height, width, height), "LeftRight")) 
		{
			CancelInvoke ();

			networkManager.PlayAnimation("LeftRight");
		}
		/*
		if (GUI.Button (new Rect (index*width, indexZ*height, width, height), "NO")) 
		{
			CancelInvoke();
			
			networkManager.PlayAnimation("Angry");
			networkManager.PlaySound("assets/What.mp3",1);
			networkManager.Servo(true);
			
			Invoke("ServoDown",1);
			Invoke("ServoUp",2);
			Invoke("ServoDown",3);
			Invoke("ServoUp",4);
			
		}
*/

	}




	public bool servoState = true;

	public void FlipServo()
	{
		networkManager.FlipServo ();

	}

	public void ShineFaceNext()
	{
		int result = ShineCount + 1;
		ShineCount = (ShineCount + 1) % ShineLength;

		networkManager.PlayAnimation("Shine"+ShineCount);
	}

	public int ShineCount = 0;
	public int ShineLength = 3;

	public void ServoDown()
	{
		networkManager.Servo(false);
	}

	public void ServoUp()
	{
		networkManager.Servo(true);
	}

	public void Normal()
	{
		networkManager.PlayAnimation("Normal");
	}

	public void Blink()
	{
		networkManager.PlayAnimation("Happy");
	}

	public void Shine()
	{
		networkManager.PlayAnimation("Shine");
	}

	public void Love()
	{
		networkManager.PlayAnimation("Love");
	}

	public void LeftRight()
	{
		networkManager.PlayAnimation("LeftRight");
	}
	
	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
