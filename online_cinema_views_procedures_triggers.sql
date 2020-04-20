/* Представления контента в сочетании с типом
*/
CREATE OR REPLACE VIEW v_content_with_types AS
	SELECT c.id as content_id, c.name as name, ct.name as type_name
	FROM content c
	JOIN content_types ct ON c.content_type_id = ct.id;
	

/* Представление пользователя в сочетании с его активными подписками
 */
CREATE OR REPLACE VIEW v_user_subscriptions AS
	SELECT u.id, u.login , pc.name 
	FROM users u
	JOIN user_products up ON u.id = up.user_id 
	JOIN products pr ON up.user_id = pr.id
	JOIN packages pc ON pc.id = pr.package_id;


/* Представление среднего рейтинга контента
 */
CREATE OR REPLACE VIEW v_content_rating_avg AS
	SELECT content_id, AVG(rating)
	FROM content_rating
	GROUP BY content_id


/* Триггер, добавляющий дефолтный тип контента при добавлении/редактировании контента без указания типа
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


/* Триггер, ставящий рейтинг контенту 10, если был передан рейтинг больше 10
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


/* Процедура для поиска контента, доступного пользователю
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


/* Процедура для рассчета суммы абонентской платы пользователю
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


/* Процедура получения список пакетов с ценой, подписка на которые даст доступ к конкретному контенту
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


	
	