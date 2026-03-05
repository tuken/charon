ALTER TABLE `work_reports` ADD INDEX `idx_work_reports_weather_code` (`weather_code`);

ALTER TABLE `work_reports` ADD CONSTRAINT `fk_work_reports_weather` FOREIGN KEY (`weather_code`) REFERENCES `weathers` (`code`);
