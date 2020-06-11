package com.drevelopment.amplechatbot.api;

import com.drevelopment.amplechatbot.api.command.CommandHandler;
import com.drevelopment.amplechatbot.api.config.ConfigHandler;
import com.drevelopment.amplechatbot.api.database.DatabaseHandler;
import com.drevelopment.amplechatbot.api.event.EventHandler;
import com.drevelopment.amplechatbot.api.permission.PermissionHandler;
import com.drevelopment.amplechatbot.api.question.QuestionHandler;

public class Ample {

	private static ModTransformer modTransformer;
	private static PermissionHandler permissionHandler;
	private static ConfigHandler configHandler;
	private static EventHandler eventHandler;
	private static CommandHandler commandHandler;
	private static DatabaseHandler databaseHandler;
	private static QuestionHandler questionHandler;

	public static ModTransformer getModTransformer() {
		return modTransformer;
	}

	public static void setModTransformer(ModTransformer mt) {
		modTransformer = mt;
	}

	public static PermissionHandler getPermissionHandler() {
		return permissionHandler;
	}

	public static void setPermissionHandler(PermissionHandler ph) {
		permissionHandler = ph;
	}

	public static ConfigHandler getConfigHandler() {
		return configHandler;
	}

	public static void setConfigHandler(ConfigHandler ch) {
		configHandler = ch;
	}

	public static EventHandler getEventHandler() {
		return eventHandler;
	}

	public static void setEventHandler(EventHandler eh) {
		eventHandler = eh;
	}

	public static CommandHandler getCommandHandler() {
		return commandHandler;
	}

	public static void setCommandHandler(CommandHandler ch) {
		commandHandler = ch;
	}

	public static DatabaseHandler getDatabaseHandler() {
		return databaseHandler;
	}

	public static void setDatabaseHandler(DatabaseHandler dh) {
		databaseHandler = dh;
	}

	public static QuestionHandler getQuestionHandler() {
		return questionHandler;
	}

	public static void setQuestionHandler(QuestionHandler qh) {
		questionHandler = qh;
	}

}
