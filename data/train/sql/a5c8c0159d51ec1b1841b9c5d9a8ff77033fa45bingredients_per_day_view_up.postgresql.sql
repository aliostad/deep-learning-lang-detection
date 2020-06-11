CREATE VIEW ingredients_per_day_view AS SELECT 
  ingredients_log_view.day,
  SUM(ingredients_log_view.amount) as amount,
  SUM(ingredients_log_view.amount_with_consumption) as amount_with_consumption,
  ingredients_log_view.ingredient_id,
  ingredients_log_view.ingredient_price as cost_per_unit,
  @SUM(ingredients_log_view.amount) * ingredients_log_view.ingredient_price as total_cost,
  @SUM(ingredients_log_view.amount_with_consumption) * ingredients_log_view.ingredient_price as total_cost_with_consumption,
  ingredients.name,
  ingredients.code,
  ingredients.unit,
  ingredients.supply_flag,
  suppliers.name_abbr AS supplier_short,
  suppliers.name AS supplier
FROM ingredients_log_view
LEFT JOIN ingredients ON ingredients.id = ingredients_log_view.ingredient_id
LEFT JOIN suppliers ON suppliers.id = ingredients.supplier_id
GROUP BY ingredients_log_view.day, ingredients_log_view.ingredient_id,  ingredients_log_view.ingredient_price, ingredients.name, ingredients.code, ingredients.supply_flag, ingredients.unit, ingredients.cost, suppliers.name, suppliers.name_abbr;
