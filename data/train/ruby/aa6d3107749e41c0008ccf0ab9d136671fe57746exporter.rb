module Upstarter
  class Exporter
    attr_reader :process_file, :output_dir

    def initialize(process_file, output_dir)
      @process_file = process_file
      @output_dir = output_dir
    end

    def options
      @options ||= OpenStruct.new(YAML.load_file(process_file))
    end

    def export!
      export_master_file!
      export_groups!
    end

    private
    def export_master_file!
      Templates::Master.new(options).export_to(output_dir)
    end

    def export_groups!
      options.processes.each do |process_name, process_options|
        process_options = build_options(process_name, process_options)

        if process_options.instances == 1
          Templates::Instance.new(process_options).export_to(output_dir)
        else
          export_group(process_options)
          export_group_instances(process_options)
        end
      end
    end

    def default_process_options
      {instances: 1, port: 0}
    end

    def build_options(process_name, process_options)
      OpenStruct.new(
        default_process_options
          .merge(options.to_h)
          .merge(process_options)
          .merge({
            process_name: process_name,
            process_number: 1,
            parent_name: options.name
          })
      )
    end

    def export_group(process_options)
      process_options = OpenStruct.new(
        process_options.to_h.merge(process_options.processes[process_options.process_name])
      )

      Templates::Group.new(process_options).export_to(output_dir)
    end

    def export_group_instances(process_options)
      process_options.parent_name = "#{process_options.name}-#{process_options.process_name}"

      process_options.instances.times do
        Templates::GroupInstance.new(process_options).export_to(output_dir)

        process_options.process_number += 1
        process_options.port += 1
      end
    end
  end
end
