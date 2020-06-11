# Handle interactions with OPAM.
require_relative 'package'

module Opam
  # The list of all Coq packages in the given repositories.
  def Opam.all_packages(repositories)
    repositories.map do |repository|
      Dir.glob("opam-coq-archive/#{repository}/packages/*/coq-*").map do |path|
        name, version = File.basename(path).split(".", 2)
        Package.new(repository, name, version)
      end
    end.flatten(1).sort {|x, y| x.to_s <=> y.to_s}.reverse
    # [Package.new("stable", "coq-ssreflect", "1.5.0")]
  end

  # Add a repository.
  def Opam.add_repository(repository)
    system("opam", "repo", "add", repository, "opam-coq-archive/#{repository}")
  end
end
