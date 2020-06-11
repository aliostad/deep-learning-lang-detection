# -*- encoding : utf-8 -*-
class SelectionProcessForm
  include Virtus

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_reader :selection_process
  attr_reader :inscription

  attribute :selection_process_name, String
  attribute :selection_process_call, String
  attribute :selection_process_edict, File
  attribute :selection_process_enterprise, Enterprise

  attribute :inscription_open_date, DateTime
  attribute :inscription_consolidated_at, DateTime

  validates :selection_process_name, presence: true
  validates :selection_process_edict, presence: true
  # … more validations …

  # Forms are never themselves persisted
  def persisted?
    false
  end

  def save
    if valid?
      persist!
      true
    else
      false
    end
  end

private

  def persist!
    @selection_process = SelectionProcess.new(name: selection_process_name, 
      call: selection_process_call, edict: selection_process_edict)
    @selection_process.enterprise = selection_process_enterprise
    @selection_process.save!

    @inscription = @selection_process.process_steps.create!(name: "Inscrições",
      description: "Etapa de inscrição dos candidatos", open_date: inscription_open_date,
      consolidated_at: inscription_consolidated_at, order_number: 1)
  end
end
