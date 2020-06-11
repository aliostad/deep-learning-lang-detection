package com.madgnome.stash.plugins.buccaneer.model;

import com.atlassian.stash.repository.Repository;

import java.util.HashMap;
import java.util.Map;

public class TagsRepository
{
  private final Map<Repository, Tags> tagsByRepository;

  public TagsRepository()
  {
    tagsByRepository = new HashMap<Repository, Tags>();
  }

  public Tags getTags(Repository repository)
  {
    return tagsByRepository.get(repository);
  }

  public void addTags(Repository repository, Tags tags)
  {
    tagsByRepository.put(repository, tags);
  }
}
