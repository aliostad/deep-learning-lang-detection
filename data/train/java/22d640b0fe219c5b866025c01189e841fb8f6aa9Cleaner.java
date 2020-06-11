package pl.pszczolkowski.kanban.util;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Service;

import pl.pszczolkowski.kanban.domain.board.repository.BoardRepository;
import pl.pszczolkowski.kanban.domain.label.repository.LabelRepository;
import pl.pszczolkowski.kanban.domain.task.repository.ColumnRepository;
import pl.pszczolkowski.kanban.domain.task.repository.TaskRepository;
import pl.pszczolkowski.kanban.domain.user.repository.UserRepository;

@Service
public class Cleaner implements ApplicationContextAware {

	private static UserRepository userRepository;
	private static BoardRepository boardRepository;
	private static ColumnRepository columnRepository;
	private static TaskRepository taskRepository;
	private static LabelRepository labelRepository;
	
	public static void clearUsers() {
		userRepository.deleteAll();
	}
	
	public static void clearBoards() {
		boardRepository.deleteAll();
	}
	
	public static void clearColumns() {
		columnRepository.deleteAll();		
	}

	public static void cleanTasks() {
		taskRepository.deleteAll();
	}
	
	public static void clearLabels() {
		labelRepository.deleteAll();
	}
	
	@Override
	public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
		userRepository = applicationContext.getBean(UserRepository.class);
		boardRepository = applicationContext.getBean(BoardRepository.class);
		columnRepository = applicationContext.getBean(ColumnRepository.class);
		taskRepository = applicationContext.getBean(TaskRepository.class);
		labelRepository = applicationContext.getBean(LabelRepository.class);
	}

}
