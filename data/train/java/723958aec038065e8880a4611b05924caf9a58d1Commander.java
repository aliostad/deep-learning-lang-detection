package com.reuters.adt.trapi.pms.sample;

import java.util.HashMap;
import java.util.Map;

import com.reuters.adt.trapi.pms.sample.handler.ApplicationCommandHandler;
import com.reuters.adt.trapi.pms.sample.handler.AuthCommandHandler;
import com.reuters.adt.trapi.pms.sample.handler.BlockCommandHandler;
import com.reuters.adt.trapi.pms.sample.handler.CancelCommandHandler;
import com.reuters.adt.trapi.pms.sample.handler.ConnectionCommandHandler;
import com.reuters.adt.trapi.pms.sample.handler.DateCommandHandler;
import com.reuters.adt.trapi.pms.sample.handler.EditCommandHandler;
import com.reuters.adt.trapi.pms.sample.handler.HistoryCommandHandler;
import com.reuters.adt.trapi.pms.sample.handler.LinkCommandHandler;
import com.reuters.adt.trapi.pms.sample.handler.ListCommandHandler;
import com.reuters.adt.trapi.pms.sample.handler.LockCommandHandler;
import com.reuters.adt.trapi.pms.sample.handler.MemoryHandler;
import com.reuters.adt.trapi.pms.sample.handler.ProfileCommandHandler;
import com.reuters.adt.trapi.pms.sample.handler.ProxyCommandHandler;
import com.reuters.adt.trapi.pms.sample.handler.RegisterCommandHandler;
import com.reuters.adt.trapi.pms.sample.handler.TimeCommandHandler;
import com.reuters.adt.trapi.pms.sample.handler.TradeCommandHandler;
import com.reuters.adt.trapi.pms.sample.handler.UnlinkCommandHandler;


public final class Commander {
	
	private static final Map<Command, CommandHandler> HANDLERS
			= new HashMap<Command, CommandHandler>();
	static {
		CommandHandler applicationHandler = new ApplicationCommandHandler();		
		HANDLERS.put(Command.exit, applicationHandler);		
		HANDLERS.put(Command.h, applicationHandler);
		HANDLERS.put(Command.version, applicationHandler);
		
		CommandHandler connectionHandler = new ConnectionCommandHandler();
		HANDLERS.put(Command.login, connectionHandler);
		HANDLERS.put(Command.logoff, connectionHandler);
		
		HANDLERS.put(Command.register, new RegisterCommandHandler());
		HANDLERS.put(Command.edit, new EditCommandHandler());
		
		CommandHandler tradeHandler = new TradeCommandHandler();
		HANDLERS.put(Command.add, tradeHandler);
		HANDLERS.put(Command.remove, tradeHandler);
		HANDLERS.put(Command.delete, tradeHandler);
		HANDLERS.put(Command.destroy, tradeHandler);
		
		CommandHandler blockHandler = new BlockCommandHandler();
		HANDLERS.put(Command.prime, blockHandler);
		HANDLERS.put(Command.unprime, blockHandler);
		HANDLERS.put(Command.activate, blockHandler);
		HANDLERS.put(Command.deactivate, blockHandler);
		HANDLERS.put(Command.accept, blockHandler);
		HANDLERS.put(Command.reject, blockHandler);
		
		HANDLERS.put(Command.link, new LinkCommandHandler());
		HANDLERS.put(Command.unlink, new UnlinkCommandHandler());
		HANDLERS.put(Command.cancel, new CancelCommandHandler());
		HANDLERS.put(Command.history, new HistoryCommandHandler());
		HANDLERS.put(Command.date, new DateCommandHandler());
		HANDLERS.put(Command.time, new TimeCommandHandler());
		HANDLERS.put(Command.auth, new AuthCommandHandler());
		
		CommandHandler profileHandler = new ProfileCommandHandler();
		HANDLERS.put(Command.profile, profileHandler);
		HANDLERS.put(Command.si, profileHandler);
		HANDLERS.put(Command.ls, new ListCommandHandler());
		
		CommandHandler proxyHandler = new ProxyCommandHandler();
		HANDLERS.put(Command.represent, proxyHandler);
		
		CommandHandler lockHandler = new LockCommandHandler();
		HANDLERS.put(Command.lock, lockHandler);
		HANDLERS.put(Command.unlock, lockHandler);
		
		CommandHandler memoryHandler = new MemoryHandler();
		HANDLERS.put(Command.heap, memoryHandler);
	}
	
	private static final Commander INSTANCE = new Commander();
	
	public static Commander getInstance() {
		return INSTANCE;
	}

	public void execute(String input, Application application) 
	throws CommandException {
		String[] tokens = input.split(" ");
		Command command = null;
		try {
			command = Command.valueOf(tokens[0].toLowerCase());
		} catch (IllegalArgumentException e) {
			throw new CommandException(input);
		}
			 
		try {
			CommandHandler handler = HANDLERS.get(command);
			if (handler != null) {
				String[] args = new String[tokens.length - 1];
				System.arraycopy(tokens, 1, args, 0, args.length);
				handler.handle(command, args, application);
			} else {
				throw new AssertionError("Missing handler for interactive command: " + command);
			}	
		} catch (RuntimeException e) {
			System.out.println("WARNING: " + e);
			e.printStackTrace();
		}
	}
	
	public void execute(Command command, String[] args, 
			Application application) throws CommandException {
		try {
			CommandHandler handler = HANDLERS.get(command);
			if (handler != null) {
				handler.handle(command, args, application);
			} else {
				throw new AssertionError("Missing handler for interactive command: " + command);
			}	
		} catch (RuntimeException e) {
			System.out.println("WARNING: " + e);
			e.printStackTrace();
		}
	}
}
