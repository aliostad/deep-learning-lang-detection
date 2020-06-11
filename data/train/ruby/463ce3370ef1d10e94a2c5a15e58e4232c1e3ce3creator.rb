module Jobo
  module Jobs
    class Creator

      def self.create_job(job_repository, attributes)
        new(job_repository).create_job(attributes)
      end

      def initialize(job_repository)
       @job_repository = job_repository 
      end

      def create_job(attributes)
        job_repository.create_job(
          attributes.fetch(:location),
          attributes.fetch(:position),
          attributes.fetch(:company),
          attributes.fetch(:category)
        )
      end

      private
      attr_reader :job_repository

    end

  end
end
