ALTER TABLE `fields` DROP FOREIGN KEY `fk_fields_state`;

ALTER TABLE `fields` DROP INDEX `idx_fields_state`;

ALTER TABLE `fields` DROP COLUMN `state`;

ALTER TABLE `fields` ADD COLUMN `status` enum('cultivated','fallow','abandoned') DEFAULT 'cultivated' COMMENT '利用状態（cultivated：耕作中、fallow：休耕中、abandoned：耕作放棄）' AFTER `crop`;

DROP TABLE `field_states`;
