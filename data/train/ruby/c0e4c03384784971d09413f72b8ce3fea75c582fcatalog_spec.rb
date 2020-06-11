require 'spec_helper'

describe RDF::AllegroGraph::Catalog do
  before :each do
    @catalog = RDF::AllegroGraph::Catalog.new({:server => REPOSITORY_OPTIONS[:server], :id => CATALOG_REPOSITORY_OPTIONS[:catalog_id]})
  end

  describe ".new" do
    it "allows the user to pass a catalog URL" do
      url = "#{REPOSITORY_OPTIONS[:url]}/catalogs/#{CATALOG_REPOSITORY_OPTIONS[:catalog_id]}"
      @catalog2 = RDF::AllegroGraph::Catalog.new(url)
    end
  end

  describe "catalog creation and deletion" do
    it "is performed using #new with :create and delete!" do
      server = REPOSITORY_OPTIONS[:server]
      @catalog2 = RDF::AllegroGraph::Catalog.new({:server => REPOSITORY_OPTIONS[:server], :id => 'rdf_agraph_test_2' }, :create => true)
      server.has_catalog?('rdf_agraph_test_2').should be_true
      @catalog2.delete!
      server.has_catalog?('rdf_agraph_test_2').should be_false
    end
  end

  it "returns available repositories" do
    @catalog.should respond_to(:repositories)
    @catalog.repositories.should be_a_kind_of(Enumerable)
    @catalog.repositories.should be_instance_of(Hash)
    @catalog.repositories.each do |identifier, repository|
      identifier.should be_instance_of(String)
      repository.should be_instance_of(RDF::AllegroGraph::Repository)
    end
  end

  it "indicates whether a repository exists" do
    @catalog.should respond_to(:has_repository?)
    @catalog.has_repository?(CATALOG_REPOSITORY_OPTIONS[:id]).should be_true
    @catalog.has_repository?(:foobar).should be_false
  end

  it "returns existing repositories" do
    @catalog.should respond_to(:repository, :[])
    repository = @catalog.repository(CATALOG_REPOSITORY_OPTIONS[:id])
    repository.should_not be_nil
    repository.should be_instance_of(RDF::AllegroGraph::Repository)
  end

  it "does not return nonexistent repositories" do
    lambda { @catalog.repository(:foobar) }.should_not raise_error
    repository = @catalog.repository(:foobar)
    repository.should be_nil
  end

  it "supports enumerating repositories" do
    @catalog.should respond_to(:each_repository, :each)
    # @server.each_repository.should be_an_enumerator
    @catalog.each_repository do |repository|
      repository.should be_instance_of(RDF::AllegroGraph::Repository)
    end
  end
end
