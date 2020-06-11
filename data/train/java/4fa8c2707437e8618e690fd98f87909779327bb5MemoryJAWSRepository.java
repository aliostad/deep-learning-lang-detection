package it.redhat.accenture.jaws.simple.persistence;

import java.util.ArrayList;
import java.util.List;

public class MemoryJAWSRepository<T> implements JAWSRepository<T> {

  private List<Process<T>> processes = new ArrayList<>();

  @Override
  public Integer start(T object) {
    if (processes.add(new Process<T>(object))) {
      return processes.size();
    }
    throw new RuntimeException("Cannot start new process");
  }

  @Override
  public void complete(Integer processId) {
    Process<T> process = load(processId);
    process.complete();
  }

  @Override
  public void error(Integer processId) {
    Process<T> process = load(processId);
    process.error();
  }

  private Process<T> load(Integer processId) {
    if (processId > 0 && processId <= processes.size()) {
      return processes.get(processId - 1);
    }
    throw new RuntimeException("Process Id not valid");
  }

}
