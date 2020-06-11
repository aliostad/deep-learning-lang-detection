delimiter ;;


CREATE TRIGGER ai_log_products AFTER INSERT ON catweazle2011.products FOR EACH ROW 
BEGIN
 
 DECLARE change_category INT(11);
 SET change_category = 1;

 INSERT INTO catweazle2011.changelog
  (product, field_changed, old_value, new_value, made_by_user, change_category)  
  VALUES
  (NEW.product_id, 'products.product_name', '', NEW.product_name, USER(), change_category),
  (NEW.product_id, 'products.remark', '', NEW.remark, USER(), change_category),
  (NEW.product_id, 'products.volume', '', NEW.volume, USER(), change_category),
  (NEW.product_id, 'products.presenter_section', '', NEW.presenter_section, USER(), change_category),
  (NEW.product_id, 'products.page_number', '', NEW.page_number, USER(), change_category),
  (NEW.product_id, 'products.page_style', '', NEW.page_style, USER(), change_category),
  (NEW.product_id, 'products.desc_presenter', '', NEW.desc_presenter, USER(), change_category),
  (NEW.product_id, 'products.desc_original', '', NEW.desc_original, USER(), change_category),
  (NEW.product_id, 'products.is_new', '', NEW.is_new, USER(), change_category),
  (NEW.product_id, 'products.srp', '', NEW.srp, USER(), change_category),
  (NEW.product_id, 'products.qty', '', NEW.qty, USER(), change_category),
  (NEW.product_id, 'products.price_style', '', NEW.price_style, USER(), change_category);

END;



;;
delimiter ;