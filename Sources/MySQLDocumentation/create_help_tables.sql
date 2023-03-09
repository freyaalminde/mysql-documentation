CREATE TABLE `help_category` (`help_category_id` smallint unsigned NOT NULL, `name` char(64) NOT NULL, `parent_category_id` smallint unsigned DEFAULT NULL, `url` text NOT NULL);
CREATE TABLE `help_relation` (`help_topic_id` int unsigned NOT NULL, `help_keyword_id` int unsigned NOT NULL);
CREATE TABLE `help_topic` (`help_topic_id` int unsigned NOT NULL, `name` char(64) NOT NULL, `help_category_id` smallint unsigned NOT NULL, `description` text NOT NULL, `example` text NOT NULL, `url` text NOT NULL);
CREATE TABLE `help_keyword` (`help_keyword_id` int unsigned NOT NULL, `name` char(64) NOT NULL);
