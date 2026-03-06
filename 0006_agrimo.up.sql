ALTER TABLE `work_reports` ADD COLUMN `work_hours` DECIMAL(3,1) DEFAULT NULL COMMENT '作業時間（時間単位）' AFTER `work_date`;
