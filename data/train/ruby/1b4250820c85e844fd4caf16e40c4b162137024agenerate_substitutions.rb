require './spree_repository'
require './substitution_generator'

spree_repository = SpreeRepository.create
all_variants = spree_repository.all_variants
substitution_generator = SubstitutionGenerator.new(spree_repository, all_variants)
p all_variants.count
all_variants.each do |variant|
    substitutions = substitution_generator.generate(variant)
    p "variant: #{variant}"
    substitutions.each do |s| 
        p "looked_up_variant:#{s.looked_up_variant}, substitute_variant:#{s.substitute_variant}, probability:#{s.probability}"
    end
    spree_repository.persist_substitutions(substitutions)
end
