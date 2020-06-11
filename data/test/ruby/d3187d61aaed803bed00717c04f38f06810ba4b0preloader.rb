class CalculableAttrs::Preloader
  def initialize(relation)
    @relation = relation
    @attrs = relation.calculable_attrs_included | relation.calculable_attrs_joined
  end

  def preload(records)
    models_calculable_scopes = collect_calculable_scopes(@attrs)
    collect_models_ids(models_calculable_scopes, records, @attrs)
    models_calculable_scopes.values.each { |scope| scope.calculate }
    put_calculated_values(models_calculable_scopes, records, @attrs)
    records
  end

private

  def collect_calculable_scopes(attrs)
    models_calculable_scopes= {}
    collect_models_calculable_attrs(models_calculable_scopes, @relation.klass, attrs)
    models_calculable_scopes.select { |model, scope| scope.has_attrs }
  end


  def collect_models_calculable_attrs(models_calculable_scopes, klass, attrs_to_calculate)
    attrs_to_calculate = [attrs_to_calculate] unless attrs_to_calculate.is_a?(Array)
    scope = (models_calculable_scopes[klass] ||= CalculableAttrs::ModelCalculableAttrsScope.new(klass))
    attrs_to_calculate.each do |attrs_to_calculate_item|
      case attrs_to_calculate_item
        when Symbol
          if klass.reflect_on_association(attrs_to_calculate_item)
            collect_association_calculable_attrs(models_calculable_scopes, klass, attrs_to_calculate_item, true)
          else
            scope.add_attr(attrs_to_calculate_item)
          end
        when true
          scope.add_all_attrs
        when Hash
          attrs_to_calculate_item.each do |association_name, association_attrs_to_calculate|
            collect_association_calculable_attrs(models_calculable_scopes, klass, association_name, association_attrs_to_calculate)
          end
      end
    end
  end

  def collect_association_calculable_attrs(models_calculable_scopes, klass, association_name, association_attrs_to_calculate)
    association = klass.reflect_on_association(association_name)
    if association
      collect_models_calculable_attrs(models_calculable_scopes, association.klass, association_attrs_to_calculate)
    else
      p "CALCULABLE_ATTRS: WAINING: Model #{ klass.name } doesn't have association attribute #{ association_name }."
    end
  end

  def collect_models_ids(models_calculable_scopes, records, attrs_to_calculate)
    iterate_scoped_records_recursively(models_calculable_scopes, records, attrs_to_calculate) do |scope, record|
      scope.add_id(record.id)
    end
  end


  def put_calculated_values(models_calculable_scopes, records, attrs_to_calculate)
    iterate_scoped_records_recursively(models_calculable_scopes, records, attrs_to_calculate) do |scope, record|
      record.calculable_attrs_values = scope.calculated_attrs_values(record.id)
    end
  end

  def iterate_scoped_records_recursively(models_calculable_scopes, records, attrs_to_calculate, &block)
    iterate_records_recursively(records, attrs_to_calculate) do |record|
      scope = models_calculable_scopes[record.class]
      block.call(scope, record) if scope
    end
  end

  def iterate_records_recursively(records, attrs_to_calculate, &block)
    records = [records] unless records.is_a?(Array)

    records.each do |record|
      block.call(record)

      attrs_to_calculate.select {|item| item.is_a?(Hash)}.each do |hash|
        hash.each do |association_name, association_attributes|
          if record.respond_to?(association_name)
            associated_records = record.send(association_name)
            associated_records = associated_records.respond_to?(:to_a) ? associated_records.to_a : associated_records
            iterate_records_recursively(associated_records, attrs_to_calculate, &block)
          end
        end
      end
    end
  end
end