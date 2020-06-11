class AthletesService
  def all
    athletes_repository.find_all
  end

  def one(id)
    athletes_repository.find_one(id)
  end

  def create(attrs)
    entity_to_create = Entity.new(attrs)
    athletes_repository.save(entity_to_create)
  end

  def update(id, attrs)
    entity_to_update = Entity.new(attrs)
    entity_to_update.id = id
    athletes_repository.save(entity_to_update)
  end

  def delete(id)
    athletes_repository.destroy(id)
  end

  private

  def athletes_repository
    @athletes_repository ||= AthletesRepository.new
  end
end