/*
1.+ Составить общее текстовое описание БД и решаемых ею задач;
2.+ минимальное количество таблиц - 10;
3.+ скрипты создания структуры БД (с первичными ключами, индексами, внешними ключами);
4.+ создать ERDiagram для БД;
5.+ скрипты наполнения БД данными;
6.+ скрипты характерных выборок (включающие группировки, JOIN'ы, вложенные таблицы);
7.+ представления (минимум 2);
8.+ хранимые процедуры / триггеры;
 */

/*
База данных онлайн-кинотеатра.
Пользователи регистрируются на сервисе, оплачивают подписку на пакеты контента и могут смотреть его неограниченно 
на протяжении биллингового цикла.
Контент - фильмы, сериалы (состоящие из серий) и выпуски передач.
Контент содержит так же персон в определенных ролях 
(одна и та же персона может иметь разные роли - актер, режиссер - в разных фильмах).
Контент разложен по пакетам. Пакет + период = продукт (с ценой), который пользователь может купить.
 */

DROP DATABASE IF EXISTS cinema;
CREATE DATABASE cinema;
USE cinema;

/*
 * Пользователи сервиса
 */

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id SERIAL PRIMARY KEY,
	login VARCHAR(120) UNIQUE,
	created_at DATETIME DEFAULT NOW(),
	
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    gender CHAR(1),
    birthday DATE,
    
    INDEX users_login_idx(login)
);

INSERT INTO `users` VALUES 
('1','me@test.ru','2003-02-20 18:15:18','Chloe','Kihn','m','2012-11-21'),
('2','he@test.ru','2005-07-24 19:06:25','Santino','Wisoky','m','1974-03-27'),
('3','she@test.ru','2011-04-15 01:35:17','Linnea','Botsford','f','1973-01-22'),
('4','they@test.ru','1988-09-28 03:12:18','Diamond','Mraz','f','2002-07-20'),
('5','it@test.ru','1987-02-25 12:45:18','Janae','Cole','m','1999-11-20'),
('6','man@test.ru','1996-04-23 00:53:30','Retta','Carroll','m','1992-01-07'),
('7','woman@test.ru','2001-02-07 23:37:56','Armand','Ward','f','2009-03-24'),
('8','animal@test.ru','2007-08-15 11:01:39','Madyson','Baumbach','m','2002-07-16'),
('9','bird@test.ru','2018-03-08 01:58:00','Daphnee','Boehm','f','2005-05-20'),
('10','cat@test.ru','2020-02-11 03:07:49','Alysa','Schimmel','f','1979-03-16'); 

/*
 * Типы контента
 */

DROP TABLE IF EXISTS content_types;
CREATE TABLE content_types(
	id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    created_at DATETIME DEFAULT NOW()

);

INSERT INTO `content_types` (`name`)
VALUES 	('movie'),
		('series'),
		('episode'),
		('tvshow'); 

/*
 * Типы персон
 */

DROP TABLE IF EXISTS person_types;
CREATE TABLE person_types(
	id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    created_at DATETIME DEFAULT NOW()

);

INSERT INTO `person_types` (`name`)
VALUES 	('actor'),
		('director'),
		('producer'),
		('screenwriter'); 

/*
 * Контент
 */

DROP TABLE IF EXISTS content;
CREATE TABLE content(
	id SERIAL PRIMARY KEY,
	content_type_id BIGINT UNSIGNED NOT NULL,
    name VARCHAR(255) NOT NULL UNIQUE,
    filename VARCHAR(255),
    created_at DATETIME DEFAULT NOW(),
    
    release_year INT,
    description VARCHAR(255),
    
    FOREIGN KEY (content_type_id) REFERENCES content_types(id),
    INDEX content_name_idx(name)

);

INSERT INTO `content` VALUES 
('1','1','Terminator','quibusdam','1997-02-12 09:38:44','1978','Aut corporis dolorem et natus quisquam aliquid voluptate harum. Rerum qui culpa ducimus et earum soluta facere. Eos et natus et aliquam maiores ab non. Quis iste sint cupiditate et repellendus accusamus. Rerum ut eum culpa expedita.'),
('2','2','Titanic','temporibus','1981-10-19 03:33:12','1999','Rem at fugit nostrum ea iure. Est laborum repellendus nam. Sit aperiam dolor recusandae rem recusandae dolor omnis. Quia laudantium corrupti fugit iure rem natus.'),
('3','3','Matrix','iusto','2009-01-08 22:13:10','1984','Expedita harum hic placeat est. Error consequatur fuga cupiditate libero. Ipsa minus quo explicabo molestiae unde minima. Iusto debitis neque magnam est corporis.'),
('4','4','Game of thrones','soluta','1988-05-07 13:09:29','2015','Delectus quia hic ea aut. Quia est temporibus qui rerum nisi id. Repellendus molestiae quibusdam repellendus quos et sit quo qui.'),
('5','1','Die hard','enim','1976-04-17 05:24:24','2015','Et nesciunt facilis a. Ducimus non accusamus aut repudiandae rerum. Non cumque nihil dolorem. Quas quo quasi tempora aperiam rerum.'),
('6','2','Transformers','aut','2000-05-12 13:00:50','1970','Sit quia quia rerum eum necessitatibus aut nobis. Et ad earum consectetur accusantium consequuntur temporibus. Quia a et et.'),
('7','3','Vikings','suscipit','1980-06-23 00:59:33','2002','Soluta deserunt et consequatur libero nostrum eum. Dolores quia voluptatem et. Ex aut totam vel ut magni harum vel.'),
('8','4','Sherlock','et','2018-12-31 12:24:56','1992','Est ipsum in explicabo itaque ipsam voluptatum tempora. Et totam provident consectetur eveniet minima amet consectetur. Voluptatem ipsum voluptas ratione aliquam. Laudantium corrupti praesentium repellat ea et quod.'),
('9','1','House M.D.','quia','1999-10-17 19:35:44','2005','Voluptatum mollitia voluptatem et omnis. Quaerat quam aliquam voluptatum error nihil et quo. Accusamus provident aut cupiditate quo quia molestiae ut. Ipsum nihil esse adipisci et eos officia temporibus.'),
('10','2','Mr. Robot','tempora','2014-08-27 04:56:52','2019','Eius omnis voluptatibus aut consectetur ratione ut. Ratione sed culpa alias illum vel facere ad quia. Libero aperiam adipisci expedita architecto. Sit ab quia adipisci eligendi dolorem iusto autem soluta.'),
('11','3','Desperades Housewives','aut','1988-08-19 11:09:13','1978','Voluptas illo qui hic quia assumenda non. Animi molestiae cum quis quis. Provident sed et sint doloribus. Nisi consequatur amet sunt.'),
('12','4','Babel','magnam','1970-10-06 03:58:03','1973','Ab et repudiandae eum quasi sed velit. Non distinctio fuga alias aut amet beatae voluptas. Numquam tempore et aut. Voluptate nemo numquam velit consequatur voluptas pariatur velit.'),
('13','1','Avengers','qui','1978-07-23 10:10:49','2002','Nam quo repellat voluptatum et qui voluptates. Enim accusantium sit vel voluptate. Ipsa et quaerat illum voluptatem qui veniam.'),
('14','2','Fight club','eos','1991-08-23 00:23:00','1978','Ea quibusdam corrupti sit est laudantium ut. Reprehenderit corrupti quae et officia. Atque laboriosam cupiditate maiores enim voluptatem. Et ea velit consequatur consequatur in omnis.'),
('15','3','Inseption','rerum','1984-01-08 15:53:03','2016','Aut officia tempora rem debitis. Et quam repudiandae sint libero non aut. Provident necessitatibus est deserunt iste consequatur commodi. Possimus qui modi ea error consequuntur.'),
('16','4','Django Unchained','debitis','2000-04-14 09:28:58','1995','Officia modi voluptatem ullam. Dicta velit qui mollitia unde et accusantium. Est est sit est iste sed sint. Reprehenderit voluptatibus et sapiente laboriosam.'),
('17','1','Lord of the rings','vel','2019-09-29 00:22:48','1970','Aliquid libero quasi assumenda et autem explicabo. Quo rerum eligendi et consectetur rem excepturi. Laborum voluptatem ut a id et maiores. Laborum tempora est rerum veniam fugiat ab.'),
('18','2','Starwars','doloribus','1984-04-01 01:45:39','1991','Placeat est alias quae harum consequatur numquam est animi. Quo voluptas totam quidem. Totam nihil est et tempore repudiandae. Consequatur animi velit modi accusamus consequatur consectetur.'),
('19','3','Seven','veniam','2008-10-17 22:50:21','1970','Eos quae eos eligendi veritatis odit. Fuga modi at sint similique est quod dolorem. Optio veniam voluptate qui laboriosam.'),
('20','4','The silense of the lambs','cum','1978-06-17 20:19:16','1998','Architecto consequatur et rerum perferendis asperiores mollitia neque. Quas unde quos voluptas velit qui. Quia sunt impedit qui et fuga deleniti sint.'); 


/*
 * Эпизоды, входящие в сериалы
 */

DROP TABLE IF EXISTS series_episodes;
CREATE TABLE series_episodes(
	series_id BIGINT UNSIGNED NOT NULL,
	episode_id BIGINT UNSIGNED NOT NULL,
    season_number INT UNSIGNED,
    episode_number INT UNSIGNED,
    
    FOREIGN KEY (series_id) REFERENCES content(id),
    FOREIGN KEY (episode_id) REFERENCES content(id),
    INDEX series_id_idx(series_id)

);

INSERT INTO `series_episodes` VALUES 
('1','1','1','1'),
('2','2','1','2'),
('3','3','1','3'),
('4','4','2','2'),
('5','5','2','3'),
('6','6','2','4'),
('7','7','6','1'),
('8','8','6','2'),
('9','9','7','1'),
('10','8','7','2'),
('10','9','7','3'),
('10','10','7','4'); 

/*
 * Персоны
 */

DROP TABLE IF EXISTS persons;
CREATE TABLE persons(
	id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    created_at DATETIME DEFAULT NOW(),
    
    birthday DATE,
    description VARCHAR(255),
    
    INDEX person_name_idx(name)

);

INSERT INTO `persons` VALUES 
('1','ipsam','1977-06-27 23:19:19','2013-08-22','Illum doloribus velit officiis dolorem illo totam. Quis sed consectetur et est. Quia est sed exercitationem nihil assumenda atque. Eveniet magnam molestiae quos voluptatem eius sed natus sunt.'),
('2','doloremque','2014-03-10 15:31:13','2015-07-18','Voluptatem voluptatem necessitatibus voluptas iusto placeat. Doloremque tenetur suscipit deserunt atque facere laboriosam explicabo.'),
('3','nam','2014-06-04 13:54:42','1988-09-02','Totam ipsum qui enim saepe. Dolorem maxime et labore odio optio enim non ex. Pariatur quibusdam soluta vel.'),
('4','quaerat','2013-09-12 16:47:52','1984-10-14','Consequatur suscipit odit quis earum non. Cupiditate magni dolores dolores modi magnam et itaque sit. Et tempora labore dolores ut quia labore. Sunt quisquam ea facere sed fugiat.'),
('5','excepturi','1980-03-24 10:22:15','2018-08-17','Sunt eos modi quisquam molestias neque veritatis. Accusantium ut ut non error et eum. Sit sed blanditiis repudiandae. Eius sunt ratione iste beatae voluptatem quae iste.'),
('6','delectus','1975-08-16 06:12:10','2014-07-22','Nihil est omnis esse saepe unde repellat unde. Nihil sed beatae et dolore. Magni nisi nam occaecati.'),
('7','omnis','2016-10-05 17:53:44','1991-11-23','Aut quis deserunt eligendi. Nisi possimus assumenda quia debitis facilis delectus. Consequatur animi aliquid non repellat qui. Et et et debitis quasi consequuntur sunt. Omnis eius aspernatur est inventore tempora pariatur.'),
('8','ut','2014-04-04 09:44:54','1970-02-08','Tenetur optio saepe expedita occaecati. Enim architecto aut assumenda reiciendis reiciendis aliquid.'),
('9','illo','1993-05-29 09:12:04','2011-05-17','Minus doloribus architecto sequi adipisci. Et amet veritatis totam perferendis.'),
('10','neque','2007-05-30 08:08:25','1987-07-14','Est aperiam repudiandae voluptas non sit ea. Dolores blanditiis maxime in eos ut. Esse eos molestiae ducimus fugit iusto omnis. Voluptatibus voluptatibus ut consequatur officiis dolores et mollitia. Quisquam natus rerum deleniti quo beatae amet veritatis '),
('11','non','1998-02-17 10:30:42','1995-05-30','Autem unde aut fugiat minima. A velit mollitia ipsa necessitatibus. Voluptate omnis ipsa itaque omnis reprehenderit qui at quis.'),
('12','dignissimos','2005-10-31 20:50:03','1986-01-11','Doloribus quis enim et ut. Dolorem autem suscipit eaque et magni. Quam aut dolorem quo velit repellendus ut iste rem.'),
('13','nobis','1993-03-04 12:09:07','2006-10-28','Dolores porro non voluptas quia voluptates. Tempora quam aut reiciendis. Dolore recusandae ea dolor et sint incidunt. Molestiae aut accusamus magnam voluptatem id beatae.'),
('14','saepe','2016-11-15 22:11:17','1976-05-20','Tenetur voluptatibus magni dolorem eligendi. Ipsa explicabo earum occaecati voluptas atque incidunt at officiis. Tempore nisi voluptatem quasi placeat autem est nihil possimus.'),
('15','voluptatum','1970-10-06 07:32:32','1979-05-21','Quia molestias voluptatibus nam repellendus sed et assumenda. Nisi voluptatem deserunt quisquam accusantium eos non ullam. Aut quasi sint asperiores accusantium inventore sit. Quis voluptate ea sed.'),
('16','sit','1995-09-14 15:26:50','2003-04-24','Iusto sequi corporis fugiat et. Et mollitia impedit quia reprehenderit totam. Consequatur similique placeat aut quia quod reiciendis magnam.'),
('17','sunt','1985-08-20 10:56:41','1977-05-18','Consequuntur enim non laboriosam eligendi quas. Quisquam eum illum impedit. Qui aut quis ratione at quidem molestias. Accusamus delectus inventore expedita asperiores.'),
('18','voluptatibus','2011-07-07 12:40:55','1983-12-21','Et voluptas mollitia inventore sint rerum ea totam. Enim dolores voluptas eum enim sint soluta eum nobis. Hic doloremque nostrum dolores.'),
('19','est','1979-08-07 01:04:25','2000-08-08','Ullam sit commodi voluptatem possimus. Iure quod sit voluptatem explicabo eos dolores. Quis suscipit est nostrum repudiandae tempore delectus. Earum dolorem facilis placeat perferendis et voluptate.'),
('20','corrupti','1997-10-20 09:41:33','2012-03-15','Dolores nam illo recusandae quo qui officia. Voluptatum distinctio vitae quia minus et laborum dolore. Quo sunt ea sint mollitia qui. Sapiente omnis aperiam rerum sit quisquam odio.'); 

/*
 * Персоны контента
 */

DROP TABLE IF EXISTS content_persons;
CREATE TABLE content_persons(
	content_id BIGINT UNSIGNED NOT NULL,
	person_id BIGINT UNSIGNED NOT NULL,
	person_type_id BIGINT UNSIGNED NOT NULL,

    created_at DATETIME DEFAULT NOW(),
    
    FOREIGN KEY (content_id) REFERENCES content(id),
    FOREIGN KEY (person_id) REFERENCES persons(id),
    FOREIGN KEY (person_type_id) REFERENCES person_types(id),
    
    INDEX content_id_idx(content_id)

);


INSERT INTO `content_persons` VALUES 
('1','1','1','2003-09-19 22:29:43'),
('2','1','1','2003-09-19 22:29:43'),
('3','1','1','2003-09-19 22:29:43'),
('1','2','2','2011-08-10 23:08:37'),
('3','3','3','2008-11-04 18:01:40'),
('4','4','4','2016-08-22 10:48:37'),
('5','5','1','1987-03-03 09:58:14'),
('6','6','2','1996-05-07 05:27:23'),
('7','7','3','2018-11-20 06:53:03'),
('1','8','4','1976-10-28 05:25:21'),
('9','9','1','2006-09-14 01:35:31'),
('3','10','2','1996-10-30 00:15:22'),
('11','11','3','2017-01-11 07:00:17'),
('4','12','4','2003-04-24 05:45:26'),
('4','13','1','1970-08-09 23:07:42'),
('14','14','2','2015-04-26 10:56:43'),
('15','15','3','1971-10-10 09:44:38'),
('16','16','4','1999-12-22 02:42:28'),
('17','17','1','1994-05-27 04:11:58'),
('18','18','2','2001-03-07 23:40:07'),
('19','19','3','1987-11-20 06:43:34'),
('20','20','4','2009-09-26 08:13:34'); 

/*
 * Пакеты
 */

DROP TABLE IF EXISTS packages;
CREATE TABLE packages(
	id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT NOW(),
    
    description VARCHAR(255)

);

INSERT INTO `packages` VALUES 
('1','Basic','1971-03-12 21:33:19','Atque quia temporibus ut. Consequuntur ipsum voluptates ea assumenda culpa aliquam. Sint harum voluptatibus totam aut tempora tenetur. Fugiat eligendi velit voluptate corrupti nulla ea ex.'),
('2','Extended','1986-05-09 12:59:05','Ratione iusto illum quaerat et sint sunt. Eligendi dolor accusamus consequatur quasi sed natus.'),
('3','New','2018-10-04 19:08:19','Ipsam voluptatibus et libero modi aut culpa quasi cumque. Quia tempora et nemo ipsa. Qui fugiat autem aspernatur eum ipsam repellat et.'),
('4','Classic','1995-03-09 14:11:21','Quis similique sed nobis. Optio ea dolore et aperiam. Esse in voluptas aut est aut voluptatem expedita. Repellat velit soluta reprehenderit sit vel.'); 

/*
 * Принадлежность контента пакету
 */

DROP TABLE IF EXISTS package_contents;
CREATE TABLE package_contents(
	package_id BIGINT UNSIGNED NOT NULL,
	content_id BIGINT UNSIGNED NOT NULL,

    created_at DATETIME DEFAULT NOW(),
    
    FOREIGN KEY (content_id) REFERENCES content(id),
    FOREIGN KEY (package_id) REFERENCES packages(id)

);

INSERT INTO `package_contents` VALUES 
('1','1','1997-09-06 23:53:21'),
('2','2','2010-07-17 13:49:30'),
('3','3','2020-03-28 22:05:25'),
('4','4','1988-07-27 11:01:16'),
('1','5','1972-09-09 19:51:57'),
('2','6','2001-01-21 14:30:54'),
('3','7','2015-02-10 19:55:31'),
('4','8','1977-09-01 21:43:30'),
('1','9','2018-10-04 10:47:28'),
('2','10','1978-04-27 22:51:44'),
('3','11','1991-06-01 08:03:48'),
('4','12','1996-08-18 11:05:55'),
('1','13','2009-08-11 21:31:24'),
('2','14','1990-12-23 11:25:14'),
('3','15','2012-02-16 04:51:50'),
('4','16','1974-04-27 15:27:27'),
('1','17','1997-12-04 17:58:20'),
('2','18','1972-01-06 05:08:57'),
('3','19','1988-12-27 01:33:07'),
('4','20','1997-02-20 07:15:49'); 

/*
 * Периоды оплаты
 */

DROP TABLE IF EXISTS payment_periods;
CREATE TABLE payment_periods(
	id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    created_at DATETIME DEFAULT NOW()

);

INSERT INTO `payment_periods` (`name`)
VALUES ('day'),
('month'),
('half-year'),
('year'); 

/*
 * Продукты (пакет + период + цена)
 */

DROP TABLE IF EXISTS products;
CREATE TABLE products(
	id SERIAL PRIMARY KEY,
	package_id BIGINT UNSIGNED NOT NULL,
	payment_period_id BIGINT UNSIGNED NOT NULL,
	price INT UNSIGNED NOT NULL,

    created_at DATETIME DEFAULT NOW(),
    
    FOREIGN KEY (payment_period_id) REFERENCES payment_periods(id),
    FOREIGN KEY (package_id) REFERENCES packages(id)

);

INSERT INTO `products` VALUES 
('1','1','1','99','1983-07-30 06:55:52'),
('2','2','2','299','2019-01-06 12:05:32'),
('3','3','3','159','1992-04-25 09:35:55'),
('4','4','4','169','2009-07-23 09:21:41'),
('5','1','1','99','1971-04-03 16:20:20'),
('6','2','2','129','2019-10-04 18:48:12'),
('7','3','3','259','1984-01-19 04:15:39'),
('8','4','4','499','1984-07-25 21:43:24'),
('9','1','1','599','2017-07-02 22:00:02'); 

/*
 * Владение продуктом абонента (по итогам покупки)
 */

DROP TABLE IF EXISTS user_products;
CREATE TABLE user_products(
	id SERIAL PRIMARY KEY,
	user_id BIGINT UNSIGNED NOT NULL,
	product_id BIGINT UNSIGNED NOT NULL,

    created_at DATETIME DEFAULT NOW(),
    valid_until DATETIME,
    
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (product_id) REFERENCES products(id),
    
    INDEX user_produtcs_idx(id)

);

INSERT INTO `user_products` VALUES 
('1','1','1','1983-07-15 01:42:49','1993-04-04 13:34:16'),
('2','2','2','2015-09-24 03:39:16','1998-05-18 08:45:12'),
('3','3','3','1996-05-21 13:42:00','1971-02-07 17:55:23'),
('4','4','4','2011-09-13 13:00:56','1991-03-04 16:47:01'),
('5','5','5','1973-04-15 08:17:55','1980-03-28 22:52:26'),
('6','6','6','1986-07-26 18:51:51','1999-05-06 09:23:04'),
('7','7','7','2016-09-07 09:57:41','1977-03-20 16:35:33'),
('8','8','8','2003-02-11 16:00:50','1979-07-21 16:54:43'),
('9','9','9','2007-05-03 07:05:13','1975-02-02 10:19:59'),
('10','10','1','1993-04-13 19:49:24','1988-12-02 16:18:41'),
('11','1','2','2004-02-10 02:03:42','2015-10-30 17:24:28'),
('12','2','3','2014-02-05 12:40:16','1970-06-14 20:15:23'),
('13','3','4','2008-02-17 10:24:03','2015-05-01 20:10:10'),
('14','4','5','1974-07-07 19:02:15','1984-04-13 23:23:14'),
('15','5','6','2011-04-23 00:57:42','1986-12-13 07:16:35'); 
