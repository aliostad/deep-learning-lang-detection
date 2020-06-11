describe AmkAuthorization::Repository do

  it 'should add a role to the list' do
    role = double( 'Role', name: :admin )

    repository = AmkAuthorization::Repository.new

    expect(repository.add( role )).to eq( role )
    expect(repository.count).to eq( 1 )
  end

  it 'should retrieve a role by name' do
    role = double( 'Role', name: :admin )
    repository = AmkAuthorization::Repository.new
    repository.add( role )

    expect( repository[:admin] ).to eq( role )
  end

  it 'should retrieve a role from the object' do
    role = double( 'Role', name: :admin )
    repository = AmkAuthorization::Repository.new
    repository.add( role )

    expect( repository[role] ).to eq( role )
  end

  it 'should delete a role by name' do
    role = double( 'Role', name: :admin )
    repository = AmkAuthorization::Repository.new
    repository.add( role )

    expect( repository.delete( :admin ) ).to eq( role )
    expect( repository.count ).to eq( 0 )
  end
end
