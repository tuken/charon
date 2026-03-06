CREATE TABLE `field_states` (
    `id` smallint UNSIGNED NOT NULL COMMENT 'ID',
    `name` VARCHAR(16) DEFAULT NULL COMMENT '圃場状態名',
    `description` VARCHAR(32) DEFAULT NULL COMMENT '説明',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日時',
    `deleted_at` DATETIME DEFAULT NULL COMMENT '削除日時',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_field_states_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='圃場状態';

INSERT INTO `field_states` (`id`, `name`, `description`) VALUES
(1, 'cultivated', '耕作中'),
(2, 'fallow', '休耕中'),
(3, 'abandoned', '耕作放棄');

ALTER TABLE `fields` DROP COLUMN `status`;

ALTER TABLE `fields` ADD COLUMN `field_state_id` smallint unsigned NOT NULL DEFAULT 1 COMMENT '圃場状態' AFTER `boundary`;

ALTER TABLE `fields` ADD INDEX `idx_fields_field_state_id` (`field_state_id`);

ALTER TABLE `fields` ADD CONSTRAINT `fk_fields_field_state_id` FOREIGN KEY (`field_state_id`) REFERENCES `field_states` (`id`);
