SELECT 
            p.id, p.name, p.keywords, br.name AS brand, v.ean, v.price, 
            routing_parser(p.slug) AS routing, v.sku AS reference,
            util_loc.city AS town,
            city_expanded_parser(util_loc.city, util_loc.postcode) AS city_expanded,
            coordinate_parser(util_loc.latitude, util_loc.longitude) AS coordinate,
            cat.title AS category,
            cat.parent_ids AS category_ids,
            cat.parent_ids AS category_path,
            nav.label AS navigation,
            nav.parent_ids AS navigation_ids,
            nav.parent_ids AS navigation_path,
            p.description AS content,
            image_url_parser(p.gallery) AS image,
            p.status, p.is_saleable as saleable, 
            v.stock, 
            availability_parser(p.available_for_mail_order,
            p.available_in_my_shop) AS availability,
            ss.idShop AS shops,
            v.special_price AS special_price, v.id AS special_price_variant_id, 
            cat.id AS product_category_id
        FROM 
            product AS p 
        INNER JOIN 
            (
            SELECT  
                v1.*, MIN(v1.price) minprice
            FROM    
                variant AS v1
            GROUP BY 
                v1.product_id
        ) AS v
            ON p.id = v.product_id AND v.price = minprice
        LEFT JOIN 
            products_categories AS pc
            ON p.id = pc.product_id
        LEFT JOIN 
            category AS cat
            ON pc.category_id = cat.id
        LEFT JOIN 
            navigations_categories AS nc
            ON nc.category_id = cat.id
        LEFT JOIN 
            navigation AS nav
            ON nav.id = nc.navigation_id
        LEFT JOIN     
            products_shops AS ps
            ON p.id = ps.product_id
        LEFT JOIN 
            shop_shop AS ss
            ON ps.shop_id = ss.idShop
        LEFT JOIN 
            util_location AS util_loc
            ON ss.idLocation = util_loc.idLocation
        LEFT JOIN 
            brand AS br
            ON p.brand_id = br.id;