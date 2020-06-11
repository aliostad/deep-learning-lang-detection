-- -----------------------------------------------------
-- DUMP USERS
-- -----------------------------------------------------

INSERT INTO user (`login`, `password`, `email`, `name`) VALUES
('admin', '$2a$10$MXqqS2vMDy9DAAB53udQ5Oc27OHoCXvoV.MtJZg7Lrg7kUDqxU/L.', 'juanrt1909@gmail.com', 'Juan'),
('author', '$2a$10$RewEvCU1BRWPJPLwojKbZODmilxRuRDoVd5DmcqjT9QUrXfmgtefy', 'juber@gmail.com', 'Juber'),
('user', '$2a$10$7w5J60.3TQxGJZ0GGEKGEuU6bkDXWET1SGQZ1EfNE6/mdolLMDe0i', 'user@gmail.com', 'Ann');

INSERT INTO role (`authority`) VALUES
('ROLE_ADMIN'),
('ROLE_AUTHOR'),
('ROLE_USER');

INSERT INTO user_role (`user_id`, `role_id`) VALUES
('1', '1'), ('1', '2'), ('1', '3'),
('2', '2'), ('2', '3'),
('3', '3');

-- -----------------------------------------------------
-- DUMP CATEGORIES
-- -----------------------------------------------------

INSERT INTO category (`name`) VALUES
('Local'), ('Regional'), ('Deportes'), ('Espectaculos');

-- -----------------------------------------------------
-- DUMP ARTICLES
-- -----------------------------------------------------


-- -----------------------------------------------------
-- DUMP TAGS
-- -----------------------------------------------------


