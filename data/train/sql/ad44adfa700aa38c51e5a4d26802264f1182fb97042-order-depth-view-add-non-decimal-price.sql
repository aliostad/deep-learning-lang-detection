DROP VIEW market_summary_view;

CREATE OR REPLACE VIEW market_summary_view AS
 SELECT m.market_id, m.scale, m.base_currency_id, m.quote_currency_id, ( SELECT max(o.price) AS max
           FROM order_view o
          WHERE o.market_id = m.market_id AND o.side = 0 AND o.volume > 0) AS bid, ( SELECT min(o.price) AS min
           FROM order_view o
          WHERE o.market_id = m.market_id AND o.side = 1 AND o.volume > 0) AS ask, ( SELECT om.price
           FROM match_view om
      JOIN "order" bo ON bo.order_id = om.bid_order_id
     WHERE bo.market_id = m.market_id
     ORDER BY om.created DESC
    LIMIT 1) AS last, ( SELECT max(om.price) AS max
           FROM match_view om
      JOIN "order" bo ON bo.order_id = om.bid_order_id
     WHERE bo.market_id = m.market_id AND age(om.created) < '1 day'::interval) AS high, ( SELECT min(om.price) AS min
           FROM match_view om
      JOIN "order" bo ON bo.order_id = om.bid_order_id
     WHERE bo.market_id = m.market_id AND age(om.created) < '1 day'::interval) AS low, ( SELECT sum(o.volume) AS sum
           FROM order_view o
          WHERE o.market_id = m.market_id) AS volume
   FROM market m
  ORDER BY m.base_currency_id, m.quote_currency_id;


DROP VIEW order_depth_view;

CREATE OR REPLACE VIEW order_depth_view AS
 SELECT order_view.market_id, order_view.side, order_view.price_decimal, sum(order_view.volume_decimal) AS volume_decimal,
    price, SUM(volume) volume
   FROM order_view
  WHERE order_view.volume > 0
  GROUP BY order_view.market_id, order_view.side, order_view.price_decimal, price
  ORDER BY order_view.market_id, order_view.price_decimal;
