# Repository that returns an optionally decorated object based on whether the
# given ID matches a Vocabulary or Term syntax.
class StandardRepository < Struct.new(:decorators, :repository_type)
  delegate :find, :exists?, :new, :to => :repository
  def repository
    decorating_repository
  end

  def undecorated_repository
    PolymorphicTermRepository.new(repository_type)
  end

  def decorators
    super || NullDecorator.new
  end

  private

  def decorating_repository
    DecoratingRepository.new(decorators, undecorated_repository)
  end
end

