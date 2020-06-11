package base.repository;

import item.repository.ItemRepositoryBI;
import item.repository.itemType.ItemTypeRepositoryBI;
import itemTracker.repository.ItemTrackerRepositoryBI;
import project.repository.ProjectRepositoryBI;
import user.repository.UserRepositoryBI;
import user.repository.team.TeamRepositoryBI;
import workflow.repository.WorkflowRepositoryBI;
import workflow.repository.state.ItemStateRepositoryBI;

/**
 * @author Rodrigo Itursarry (itursarry@gmail.com)
 */
public abstract class AbstractRepositoryFinder {

	private ItemTrackerRepositoryBI itemTrackerRepository;
	private UserRepositoryBI userRepository;
	private ProjectRepositoryBI projectRepository;
	private TeamRepositoryBI teamRepository;
	private ItemRepositoryBI itemRepository;
	private ItemTypeRepositoryBI itemTypeRepository;
	private WorkflowRepositoryBI workflowRepository;
	private ItemStateRepositoryBI itemStateRepository;

	public ItemTrackerRepositoryBI getItemTrackerRepository() {
		return this.itemTrackerRepository;
	}

	public void setItemTrackerRepository(ItemTrackerRepositoryBI itemTrackerRepository) {
		this.itemTrackerRepository = itemTrackerRepository;
	}

	public UserRepositoryBI getUserRepository() {
		return this.userRepository;
	}

	public void setUserRepository(UserRepositoryBI userRepository) {
		this.userRepository = userRepository;
	}

	public ProjectRepositoryBI getProjectRepository() {
		return this.projectRepository;
	}

	public void setProjectRepository(ProjectRepositoryBI projectRepository) {
		this.projectRepository = projectRepository;
	}

	public TeamRepositoryBI getTeamRepository() {
		return this.teamRepository;
	}

	public void setTeamRepository(TeamRepositoryBI teamRepository) {
		this.teamRepository = teamRepository;
	}

	public ItemRepositoryBI getItemRepository() {
		return this.itemRepository;
	}

	public void setItemRepository(ItemRepositoryBI itemRepository) {
		this.itemRepository = itemRepository;
	}

	public WorkflowRepositoryBI getWorkflowRepository() {
		return this.workflowRepository;
	}

	public void setWorkflowRepository(WorkflowRepositoryBI workflowRepository) {
		this.workflowRepository = workflowRepository;
	}

	public ItemTypeRepositoryBI getItemTypeRepository() {
		return itemTypeRepository;
	}

	public void setItemTypeRepository(ItemTypeRepositoryBI itemTypeRepository) {
		this.itemTypeRepository = itemTypeRepository;
	}

	public ItemStateRepositoryBI getItemStateRepository() {
		return itemStateRepository;
	}

	public void setItemStateRepository(ItemStateRepositoryBI itemStateRepository) {
		this.itemStateRepository = itemStateRepository;
	}
}
