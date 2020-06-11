import dydra

##
# Represents a Dydra.com RDF repository.
#
# @see http://docs.dydra.com/sdk/python
class Repository(dydra.Resource):
  """Represents a Dydra.com RDF repository."""

  ##
  # (Attribute) The repository name.
  name = None

  ##
  # @param name A valid repository name.
  def __init__(self, name, **kwargs):
    self.name = str(name)
    super(Repository, self).__init__(self.name, **kwargs)

  ##
  # @return A string representation of this object.
  def __repr__(self):
    return "dydra.Repository('%s')" % (self.name)

  ##
  # @return The number of statements in this repository.
  def __len__(self):
    return self.count()

  ##
  # Creates this repository on Dydra.com.
  #
  # @return A pending operation.
  def create(self):
    """Creates this repository on Dydra.com."""
    return dydra.Operation(self.client.call('repository.create', self.name), client=self.client)

  ##
  # Destroys this repository from Dydra.com.
  #
  # @return A pending operation.
  def destroy(self):
    """Destroys this repository from Dydra.com."""
    return dydra.Operation(self.client.call('repository.destroy', self.name), client=self.client)

  ##
  # Returns the number of RDF statements in this repository.
  #
  # @return A positive integer.
  def count(self):
    """Returns the number of RDF statements in this repository."""
    return self.client.call('repository.count', self.name)

  ##
  # Deletes all data in this repository.
  #
  # @return A pending operation.
  def clear(self):
    """Deletes all data in this repository."""
    return dydra.Operation(self.client.call('repository.clear', self.name), client=self.client)

  ##
  # Imports data from the given URL into this repository.
  #
  # @param  url A valid URL string.
  # @return A pending operation.
  def import_from_url(self, url, **kwargs):
    """Imports data from the given URL into this repository."""
    url, context, base_uri = str(url), '', ''
    if kwargs.has_key('context') and kwargs['context']:
      context = str(kwargs['context'])
    if kwargs.has_key('base_uri') and kwargs['base_uri']:
      base_uri = str(kwargs['base_uri'])
    return dydra.Operation(self.client.call('repository.import', self.name, url, context, base_uri), client=self.client)
