package test.data;

import data.contracts.IDataBaseService;
import data.contracts.repositories.IGroupsRepository;
import data.contracts.repositories.IMarksRepository;
import data.contracts.repositories.IStudentsRepository;
import data.contracts.repositories.ISubjectsRepository;

public class TestDataBaseService implements IDataBaseService {

	private IGroupsRepository groups = new TestGroupsRepository(this);
    private IStudentsRepository students = new TestStudentsRepository(this);
    private ISubjectsRepository subjects = new TestSubjectsRepository(this);
	private IMarksRepository marks = new TestMarksRepository(this);
	@Override
	public IGroupsRepository Groups() {
		return groups;
	}

	@Override
	public IStudentsRepository Students() {
		return students;
	}

	@Override
	public ISubjectsRepository Subjects() {
		return subjects;
	}

	@Override
	public IMarksRepository Marks() {
		return marks;
	}
	

}
