module ProcessEngine
  module Api
    module Base
      extend ActiveSupport::Concern
      mattr_accessor :allowed_methods

      class_methods do
        def include_apis(*api)
          ProcessEngine::Api::Base.allowed_methods.concat(api)
        end
      end

      def process_instance
        pi = ProcessEngine::ProcessInstance.find(params[:process_instance_id])
        render json: pi.attributes.slice("id", "status",  "states", "creator", "created_at", "updated_at")
      end

      def process_definitions
        pds = ProcessEngine::ProcessQuery.process_definition_get_all
        render json: { process_definitions: pds.map{ |pd| pd.attributes.slice("id", "name", "slug", "description", "created_at", "updated_at")} }
      end

      def process_instance_start
        pd = ProcessEngine::ProcessDefinition.find(params[:process_definition_id])
        fail 'You need to define method `process_instance_start_creator` typed String ' unless defined?(process_instance_start_creator)
        pi = ProcessEngine::ProcessQuery.process_instance_start(pd.slug, process_instance_start_creator)
        render json: pi.attributes.slice("id", "status",  "states", "creator", "created_at", "updated_at")
      end

      def process_tasks
        fail 'You need to define method `process_task_options` typed Hash' unless defined?(process_task_options)
        tasks = ProcessEngine::ProcessQuery.task_get_all(process_task_options)
        render json: tasks
      end

      included do
        before_action :allowed_method_filter
        ProcessEngine::Api::Base.allowed_methods = []
      end

      private
      def allowed_method?(method)
        return true unless ProcessEngine::Api::Base.allowed_methods.present?
        ProcessEngine::Api::Base.allowed_methods.map(&:to_s).include? method.to_s
      end

      def allowed_method_filter
        render json: { status: 'error', message: 'action is not allowed' }, status: 403 unless allowed_method?(params[:action])
      end
    end
  end
end
