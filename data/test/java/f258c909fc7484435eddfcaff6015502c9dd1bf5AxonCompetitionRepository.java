package uk.co.blackpepper.photocomp.competition;

import org.axonframework.repository.Repository;

import uk.co.blackpepper.photocomp.competition.api.commands.CreateCompetitionCommand;

public class AxonCompetitionRepository implements CompetitionRepository
{
    private final Repository<CompetitionAggregate> repository;

    public AxonCompetitionRepository(Repository<CompetitionAggregate> repository)
    {
        this.repository = repository;
    }

    @Override
    public Competition load(String id)
    {
        return repository.load(id);
    }

    @Override
    public void add(CreateCompetitionCommand command)
    {
        repository.add(new CompetitionAggregate(command));
    }
}
