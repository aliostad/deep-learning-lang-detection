#encoding: utf-8
require "rubygems"
require "yaml"
require "rdf"
require "rdf/virtuoso"
# read configuration file into constants
repository  = YAML::load(File.open("config/repository.yml"))
REPO        = RDF::Virtuoso::Repository.new(
              repository["sparql_endpoint"],
              :update_uri => repository["sparul_endpoint"],
              :username => repository["username"],
              :password => repository["password"],
              :auth_method => repository["auth_method"])

REVIEWGRAPH        = RDF::URI(repository["reviewgraph"])
BOOKGRAPH          = RDF::URI(repository["bookgraph"])
APIGRAPH           = RDF::URI(repository["apigraph"])
QUERY              = RDF::Virtuoso::Query
BASE_URI           = repository["base_uri"]
SECRET_SESSION_KEY = repository["secret_session_key"]

# load all library files
Dir[File.dirname(__FILE__) + '/../lib/*.rb'].each do |file|
  require file
end
