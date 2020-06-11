package me.phifty.database.filesystem;

import me.phifty.database.Handler;

/**
 * @author phifty <b.phifty@gmail.com>
 */
public interface Filesystem {

  public void exists(String path, Handler<Boolean> handler);

  public void listFiles(String path, Handler<String[]> handler);

  public void statistics(String path, Handler<Statistics> handler);

  public void makePath(String path, Handler<Boolean> handler);

  public void deletePath(String path, Handler<Boolean> handler);

  public void writeFile(String name, byte[] data, Handler<Boolean> handler);

  public void readFile(String name, Handler<byte[]> handler);

}
