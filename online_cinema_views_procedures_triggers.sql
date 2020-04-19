/* Представления контента в сочетании с типом
*/
CREATE OR REPLACE VIEW content_with_types AS
	SELECT c.id as content_id, c.name as name, ct.name as type_name
	FROM content c
	JOIN content_types ct ON c.content_type_id = ct.id;
	

/* Представление пользователя в сочетании с его активными подписками
 */
CREATE OR REPLACE VIEW user_subscriptions AS
	SELECT u.id, u.login , pc.name 
	FROM users u
	JOIN user_products up ON u.id = up.user_id 
	JOIN products pr ON up.user_id = pr.id
	JOIN packages pc ON pc.id = pr.package_id;


/* Триггер, добавляющий дефолтный тип контента при добавлении/редактировании контента без указания типа
 */

DELIMITER //
DROP TRIGGER IF EXISTS check_content_type_on_product_indert//
CREATE TRIGGER check_content_type_on_product_indert BEFORE INSERT ON content
FOR EACH ROW
BEGIN
	IF NEW.content_type_id IS NULL THEN
    	SET NEW.content_type_id = 1;
  	END IF;
END//

DROP TRIGGER IF EXISTS check_content_type_on_product_update//
CREATE TRIGGER check_content_type_on_product_update BEFORE UPDATE ON content
FOR EACH ROW
BEGIN
	IF NEW.content_type_id IS NULL THEN
    	SET NEW.content_type_id = 1;
  	END IF;
END//


/* Процедура для поиска контента, доступного пользователю
 */

DELIMITER $

DROP PROCEDURE IF EXISTS available_content$
CREATE PROCEDURE available_content(_user_id BIGINT)
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

CALL available_content (1);


	
	