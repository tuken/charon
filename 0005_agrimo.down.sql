ALTER TABLE `work_reports` DROP FOREIGN KEY `fk_work_reports_weather`;

ALTER TABLE `work_reports` DROP INDEX `idx_work_reports_weather_code`;

RENAME TABLE `weathers` TO `weather_codes`;

ALTER TABLE `weather_codes` MODIFY COLUMN `code` int unsigned NOT NULL COMMENT '天気コード';
