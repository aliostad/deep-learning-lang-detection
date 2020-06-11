require 'virtus'

module TwistlockControl
	# An entity is basically a struct with typed fields.
	class Entity
		include Virtus.model

		def ==(other)
			return false unless other.respond_to? :attributes
			attributes == other.attributes
		end

		def serialize
			attributes.dup
		end
	end

	# A persisted entity is an entity that has its own persistant
	# storage repository.
	class PersistedEntity < Entity
		def self.find_by_id(id)
			deserialize repository.find_by_id(id)
		end

		def self.deserialize(attrs)
			return nil if attrs.nil?
			new(attrs)
		end

		def self.find_with_ids(ids)
			repository.find_with_ids(ids).map { |a| deserialize a }
		end

		def self.all
			repository.all.map { |a| deserialize a }
		end

		def save
			repository.save(serialize)
		end

		def remove
			repository.remove(id)
		end

		def repository
			self.class.repository
		end

		def self.inherited(subclass)
			subclass.class_exec do
				def self.repository(repository = nil)
					return @repository = repository if repository
					return @repository if @repository
					return superclass.repository if superclass.respond_to?(:repository)

					fail "#{name} has not defined a repository."
				end
			end
			super(subclass)
		end
	end
end
