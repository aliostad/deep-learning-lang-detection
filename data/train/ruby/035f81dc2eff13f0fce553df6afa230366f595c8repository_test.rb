require 'test_helper'

class RepositoryTest < ActiveSupport::TestCase

  def setup
    @repository = repositories(:repository_one)
  end

  ######################### class method tests ##############################

  # none

  ############################ object tests #################################

  test 'valid repository saves' do
    assert @repository.save
  end

  test 'repository should have a unique name scoped to its institution' do
    # same name and institution should fail
    repository2 = Repository.new(name: @repository.name,
                                 institution: @repository.institution)
    assert !repository2.save
    # same name, different institution should succeed
    repository2.institution = institutions(:institution_two)
    assert repository2.save
  end

  ########################### property tests ################################

  # name
  test 'name is required' do
    @repository.name = nil
    assert !@repository.save
  end

  test 'name should be no more than 255 characters long' do
    @repository.name = 'a' * 256
    assert !@repository.save
  end

  # institution
  test 'institution is required' do
    @repository.institution = nil
    assert !@repository.save
  end

  ############################# method tests #################################

  # none

  ########################### association tests ##############################

  test 'dependent locations should be destroyed on destroy' do
    location = locations(:location_one)
    @repository.locations << location
    @repository.destroy
    assert location.destroyed?
  end

end
