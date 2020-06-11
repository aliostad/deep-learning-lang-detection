module Bumbleworks
  module Entity
    class ProcessNotRegistered < StandardError; end

    def self.included(klass)
      unless Bumbleworks.entity_classes.include? klass
        Bumbleworks.entity_classes << klass
      end
      klass.extend ClassMethods
    end

    def identifier
      id
    end

    def to_s
      "#{Bumbleworks::Support.titleize(self.class.name)} #{identifier}"
    end

    def launch_process(process_name, options = {})
      identifier_attribute = attribute_for_process_name(process_name.to_sym)
      if (options[:force] == true || (process_identifier = self.send(identifier_attribute)).nil?)
        workitem_fields = process_fields(process_name.to_sym).merge(options[:fields] || {})
        variables = process_variables(process_name.to_sym).merge(options[:variables] || {})
        process_identifier = Bumbleworks.launch!(process_name.to_s, workitem_fields, variables).wfid
        persist_process_identifier(identifier_attribute.to_sym, process_identifier)
      end
      Bumbleworks::Process.new(process_identifier)
    end

    def persist_process_identifier(identifier_attribute, process_identifier)
      if self.respond_to?(:update)
        update(identifier_attribute => process_identifier)
      else
        raise "Entity must define #persist_process_identifier method if missing #update method."
      end
    end

    def processes_by_name
      return {} unless self.class.processes
      process_names = self.class.processes.keys
      process_names.inject({}) do |memo, name|
        pid = self.send(attribute_for_process_name(name))
        memo[name] = pid ? Bumbleworks::Process.new(pid) : nil
        memo
      end
    end

    def processes
      processes_by_name.values.compact
    end

    def cancel_process!(process_name, options = {})
      process = processes_by_name[process_name.to_sym]
      return nil unless process

      options = options.dup
      clear_identifiers = options.delete(:clear_identifiers)
      process.cancel!(options)
      unless clear_identifiers == false
        identifier_attribute = attribute_for_process_name(process_name.to_sym)
        persist_process_identifier(identifier_attribute, nil)
      end
    end

    def cancel_all_processes!(options = {})
      processes_by_name.keys.each do |process_name|
        cancel_process!(process_name, options)
      end
    end

    def attribute_for_process_name(name)
      process_config = self.class.processes[name]
      raise ProcessNotRegistered.new(name) unless process_config
      process_config && process_config[:attribute]
    end

    def tasks(nickname = nil)
      finder = Bumbleworks::Task.for_entity(self)
      finder = finder.by_nickname(nickname) if nickname
      finder
    end

    def process_fields(process_name = nil)
      { :entity => self }
    end

    def process_variables(process_name = nil)
      {}
    end

    def subscribed_events
      processes.values.compact.map(&:subscribed_events).flatten.uniq
    end

    def is_waiting_for?(event)
      subscribed_events.include? event.to_s
    end

    module ClassMethods
      def process(process_name, options = {})
        options[:attribute] ||= default_process_identifier_attribute(process_name)
        processes[process_name.to_sym] = options
      end

      def processes
        @processes ||= {}
      end

      def entity_type
        Bumbleworks::Support.tokenize(name)
      end

      def default_process_identifier_attribute(process_name)
        identifier_attribute = "#{process_name}_process_identifier"
        identifier_attribute.gsub!(/^#{entity_type}_/, '')
        identifier_attribute.gsub!(/process_process/, 'process')
        identifier_attribute.to_sym
      end
    end
  end
end