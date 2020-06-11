/*
 * Name   : Russell Tan
 * Date   : November 17, 2014
 * Purpose: Test the Mini word processor interface
 * Inputs : Standard commands in word processing
 * Outputs: The corresponding output when performing commands
 */

public class wordTester
{
	public static void main(String Theory[])
	{
		miniWord word = new miniWord("Hocus Pocus");

		word.processCommand("insert [a]");
		word.processCommand("insert [b]");
		word.processCommand("insert [c]");
		word.processCommand("insert [d]");
		word.processCommand("insert [e]");
		word.processCommand("insert [f]");
		word.processCommand("insert [g]");
		word.processCommand("insert [h]");
		word.processCommand("insert [i]");
		word.processCommand("insert [j]");

		word.processCommand("left");
		word.processCommand("left");
		word.processCommand("left");
		word.processCommand("find [r]");
		word.processCommand("left");
		word.processCommand("left");
		word.processCommand("left");
		word.processCommand("left");
		word.processCommand("left");

		word.processCommand("insert [r]");
		word.processCommand("insert [u]");
		word.processCommand("insert [s]");
		word.processCommand("insert [s]");
		word.processCommand("insert [e]");
		word.processCommand("insert [l]");
		word.processCommand("insert [l]");
		word.processCommand("insert [ ]");
		word.processCommand("insert [t]");
		word.processCommand("insert [a]");
		word.processCommand("insert [n]");

		word.processCommand("insert [s]");
		word.processCommand("insert [t]");
		word.processCommand("insert [u]");
		word.processCommand("insert [v]");
		word.processCommand("backspace");
		word.processCommand("backspace");
		word.processCommand("start");
		word.processCommand("find [t]");
		word.processCommand("delete");
		word.processCommand("delete");
		word.processCommand("insert [w]");
		word.processCommand("insert [x]");
		word.processCommand("insert [y]");
		word.processCommand("insert [z]");
		word.processCommand("end");
		word.execute();
	}
}