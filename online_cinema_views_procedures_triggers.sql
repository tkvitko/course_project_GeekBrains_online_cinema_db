/* View of the content with it type
*/
CREATE OR REPLACE VIEW v_content_with_types AS
	SELECT c.id as content_id, c.name as name, ct.name as type_name
	FROM content c
	JOIN content_types ct ON c.content_type_id = ct.id;
	

/* View of a user with his subscriptions
 */
CREATE OR REPLACE VIEW v_user_subscriptions AS
	SELECT u.id, u.login , pc.name 
	FROM users u
	JOIN user_products up ON u.id = up.user_id 
	JOIN products pr ON up.user_id = pr.id
	JOIN packages pc ON pc.id = pr.package_id;


/* View of average rating
 */
CREATE OR REPLACE VIEW v_content_rating_avg AS
	SELECT content_id, AVG(rating)
	FROM content_rating
	GROUP BY content_id


/* Trigger, that adds default content type in case of adding/editing content without type
 */

DELIMITER //
DROP TRIGGER IF EXISTS t_check_content_type_on_product_insert//
CREATE TRIGGER t_check_content_type_on_product_insert BEFORE INSERT ON content
FOR EACH ROW
BEGIN
	IF NEW.content_type_id IS NULL THEN
    	SET NEW.content_type_id = 1;
  	END IF;
END//

DROP TRIGGER IF EXISTS t_check_content_type_on_product_update//
CREATE TRIGGER t_check_content_type_on_product_update BEFORE UPDATE ON content
FOR EACH ROW
BEGIN
	IF NEW.content_type_id IS NULL THEN
    	SET NEW.content_type_id = 1;
  	END IF;
END//


/* Trigger, setting rating to 10 in case of rating is more that 10
 */

DELIMITER //
DROP TRIGGER IF EXISTS t_check_content_rating_insert//
CREATE TRIGGER t_check_content_rating_insert BEFORE INSERT ON content_rating
FOR EACH ROW
BEGIN
	IF NEW.rating > 10 THEN
    	SET NEW.rating = 10;
  	END IF;
END//

DROP TRIGGER IF EXISTS t_check_content_rating_update//
CREATE TRIGGER t_check_content_rating_update BEFORE UPDATE ON content_rating
FOR EACH ROW
BEGIN
	IF NEW.rating > 10 THEN
    	SET NEW.rating = 10;
  	END IF;
END//


/* Procedure of serching content available to user
 */

DELIMITER $

DROP PROCEDURE IF EXISTS proc_available_content$
CREATE PROCEDURE proc_available_content(_user_id BIGINT)
BEGIN
	SELECT c.name, filename, release_year, c.description, p.name as package
	FROM content c 
	JOIN package_contents pc ON c.id = pc.content_id 
	JOIN packages p ON p.id = pc.package_id 
	JOIN products pr ON pr.package_id = p.id 
	JOIN user_products up ON up.product_id = pr.id 
	WHERE up.user_id = _user_id;
END$
DELIMITER ;

CALL proc_available_content(1);


/* Procedure to count summary payment for user
 */

DELIMITER $

DROP PROCEDURE IF EXISTS proc_monthly_payment$
CREATE PROCEDURE proc_monthly_payment(_user_id BIGINT)
BEGIN
	SELECT SUM(price) as payment
	FROM products p 
	JOIN user_products up ON p.id = up.product_id 
	WHERE up.user_id = _user_id;
END$
DELIMITER ;

CALL proc_monthly_payment(1);


/* Procedure to get packages list, subscription to which will make available some content
*/

DELIMITER $

DROP PROCEDURE IF EXISTS proc_packages_to_get_content_by$
CREATE PROCEDURE proc_packages_to_get_content_by(_content_id BIGINT)
BEGIN
	SELECT c.name as content, p.name as package, pr.price 
	FROM products pr
	JOIN packages p ON pr.package_id = p.id 
	JOIN package_contents pc ON p.id = pc.package_id
	JOIN content c ON c.id = pc.content_id 
	WHERE c.id = _content_id;
END$
DELIMITER ;

CALL proc_packages_to_get_content_by(1);


/* Procedure to get content viewing history with bookmarks for user
 */

DELIMITER $

DROP PROCEDURE IF EXISTS proc_wathes_history_for_user$
CREATE PROCEDURE proc_wathes_history_for_user(_user_id BIGINT)
BEGIN
	SELECT c.name, wh.bookmark 
	FROM watches_history wh 
	JOIN content c ON c.id = wh.content_id 
	WHERE wh.user_id = _user_id;
END$
DELIMITER ;

CALL proc_wathes_history_for_user(1);

	
	