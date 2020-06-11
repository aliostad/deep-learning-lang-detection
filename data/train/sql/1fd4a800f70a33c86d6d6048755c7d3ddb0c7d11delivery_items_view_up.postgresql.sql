CREATE VIEW delivery_items_basic_view AS SELECT
  ordered_items.item_id,
  SUM(ordered_items.amount) as amount,
  orders.delivery_man_id as delivery_man_id,
  orders.deliver_at::date as scheduled_for
  FROM ordered_items
    LEFT JOIN orders ON orders.id = ordered_items.order_id
    WHERE orders.delivery_man_id IS NOT NULL AND orders.state IN ('order', 'expedited')
    GROUP BY ordered_items.item_id, orders.delivery_man_id, orders.deliver_at::date;

CREATE VIEW delivery_items_basic_with_trunk_view AS SELECT
  COALESCE(delivery_items_basic_view.item_id, items_in_trunk.item_id) as item_id,
  COALESCE(delivery_items_basic_view.amount,0) + COALESCE(items_in_trunk.amount,0) AS amount,
  COALESCE(delivery_items_basic_view.amount,0) AS in_orders,
  COALESCE(items_in_trunk.amount,0) AS additional,
  COALESCE(delivery_items_basic_view.delivery_man_id, items_in_trunk.delivery_man_id) AS delivery_man_id,
  COALESCE(delivery_items_basic_view.scheduled_for,items_in_trunk.deliver_at) AS scheduled_for
    FROM delivery_items_basic_view
    FULL JOIN items_in_trunk ON delivery_items_basic_view.item_id = items_in_trunk.item_id AND delivery_items_basic_view.delivery_man_id = items_in_trunk.delivery_man_id AND delivery_items_basic_view.scheduled_for = items_in_trunk.deliver_at;

CREATE VIEW delivery_items_view AS SELECT
  delivery_items_basic_with_trunk_view.*,
  scheduled_items_view.amount AS scheduled_amount,
  scheduled_meals_left_view.ordered_amount AS ordered_amount,
  scheduled_meals_left_view.amount_left_without_trunk AS amount_left_without_trunk,
  scheduled_meals_left_view.lost_amount AS lost_amount,
  scheduled_meals_left_view.sold_amount AS sold_amount,
  scheduled_meals_left_view.amount_left AS amount_left,
  (scheduled_meals_left_view.amount_left IS NOT NULL) AS meal_flag
     FROM delivery_items_basic_with_trunk_view
     LEFT JOIN scheduled_items_view ON delivery_items_basic_with_trunk_view.item_id = scheduled_items_view.item_id AND delivery_items_basic_with_trunk_view.scheduled_for = scheduled_items_view.scheduled_for
     LEFT JOIN scheduled_meals_left_view ON delivery_items_basic_with_trunk_view.item_id = scheduled_meals_left_view.item_id AND delivery_items_basic_with_trunk_view.scheduled_for = scheduled_meals_left_view.scheduled_for::date;