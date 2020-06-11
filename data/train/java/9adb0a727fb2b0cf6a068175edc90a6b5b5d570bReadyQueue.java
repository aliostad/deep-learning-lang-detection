package lab2;

import java.util.ArrayList;
import java.util.List;

public class ReadyQueue {
  private List<Process> queue = new ArrayList<Process>();

  protected Process dequeue() {
    if(queue.size() > 0) {
      Process head = queue.get(0);
      queue.remove(0);
      return head;
    } else {
      return null;
    }
  }

  protected void enqueue(Process process) {
    queue.add(queue.size(), process);
  }

  protected void updateWaitTime(int timeCollapsed) {
    for(int i = 0; i < queue.size(); i++) {
      Process process = queue.get(i);
      process.setWaitTime(process.getWaitTime() + timeCollapsed);
    }
  }

  protected int getSize() {
    return queue.size();
  }
}
