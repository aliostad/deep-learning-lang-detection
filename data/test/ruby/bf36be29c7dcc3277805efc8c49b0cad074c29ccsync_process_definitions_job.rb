class SyncProcessDefinitionsJob < ActiveJob::Base
  queue_as :default

  def perform
    synchronize
  end

  protected

  def synchronize
    BpmProcessDefinitionService.process_list.each do |process|
      next if BpmIntegration::ProcessDefinition.where(process_identifier:process.id).first

      new_process = build_process_definition(process)
      new_process.form_fields = synchronize_form_fields(new_process)
      new_process.task_definitions = synchronize_task_definitions(new_process)

      if new_process.save(validate:false)
        p '[StartProcessJob - INFO] Deploy de definição do processo ' + new_process.id.to_s + ' realizado com sucesso!'
      else
        p '[StartProcessJob - ERROR] Ocorreu um erro ao realizar deploy do processo ' + new_process.id.to_s
      end
    end
  end

  def synchronize_form_fields(process)
    form_properties = BpmProcessDefinitionService.form_data(process.process_identifier)["formProperties"]

    form_fields = []
    form_properties.each do |form_item|
      field_definition = find_or_create_form_field_definition(process, form_item)

      form_field = build_form_field_from_hash(form_item)

      form_field.form_field_definition = field_definition
      form_field.form_able = process

      form_fields << form_field
    end
    form_fields
  end

  def synchronize_task_definitions(process)
    tasks_properties = BpmTaskService.task_definitions(process.process_identifier)

    tasks = []
    tasks_properties.each do |t|
      task = BpmIntegration::TaskDefinition.new
      task.key = t["key"]

      task_form_properties = t["taskFormHandler"]["formPropertyHandlers"]

      form_fields = []
      task_form_properties.each do |form_item|
        field_definition = find_or_create_form_field_definition(process, form_item)

        form_field = build_form_field_from_hash(form_item)
        form_field.form_field_definition = field_definition

        form_fields << form_field
      end
      task.form_fields = form_fields

      tasks << task
    end

    tasks
  end

  private

  def build_process_definition(bpm_process_definition)
    process = BpmIntegration::ProcessDefinition.new
    process.process_identifier = bpm_process_definition.id
    process.description = bpm_process_definition.description
    process.name = bpm_process_definition.name
    process.key = bpm_process_definition.key
    process.version = bpm_process_definition.version

    process
  end

  def find_or_create_form_field_definition(process, form_item_hash)
    BpmIntegration::FormFieldDefinition.process_field(process.process_identifier, form_item_hash["id"])
          .first_or_create do |ffd|
      ffd.process_definition = process
      ffd.name = form_item_hash["name"]
      ffd.field_type = form_item_hash["type"]
    end
  end

  def build_form_field_from_hash(form_item_hash)
    form_field = BpmIntegration::FormField.new
    form_field.readable = form_item_hash["readable"]
    form_field.writable = form_item_hash["writable"]
    form_field.required = form_item_hash["required"]
    form_field.date_pattern = form_item_hash["datePattern"]

    form_field
  end

end
