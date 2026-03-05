ALTER TABLE `orgs` ADD COLUMN `latitude` DECIMAL(10,7) DEFAULT NULL COMMENT '緯度' AFTER `address`;

ALTER TABLE `orgs` ADD COLUMN `longitude` DECIMAL(10,7) DEFAULT NULL COMMENT '経度' AFTER `latitude`;

UPDATE `orgs` SET `latitude` = 33.1234567, `longitude` = 132.1234567;

ALTER TABLE `orgs` MODIFY COLUMN `latitude` DECIMAL(10,7) NOT NULL COMMENT '緯度';

ALTER TABLE `orgs` MODIFY COLUMN `longitude` DECIMAL(10,7) NOT NULL COMMENT '経度';

ALTER TABLE `users` CHANGE COLUMN `name` `farm_name` VARCHAR(64) DEFAULT NULL COMMENT '農場名/法人名（オーナーの場合のみセットされる）';

ALTER TABLE `fields` DROP INDEX `idx_fields_boundary`;

ALTER TABLE `fields` MODIFY COLUMN `boundary` GEOMETRY DEFAULT NULL COMMENT '圃場の境界ポリゴン（WKT形式：POLYGON）';

ALTER TABLE `fields` MODIFY COLUMN `crop` VARCHAR(30) DEFAULT NULL COMMENT '栽培作物（米、麦、トマトなど）';

DROP TABLE `field_users`;

CREATE TABLE `field_users` (
    `field_id` INT UNSIGNED NOT NULL COMMENT '圃場ID（fields.id）',
    `user_id` INT UNSIGNED NOT NULL COMMENT '作業者ユーザーID（users.id）',
    PRIMARY KEY (`field_id`, `user_id`),
    INDEX idx_field_users_field (`field_id`),
    INDEX idx_field_users_user (`user_id`),
    CONSTRAINT fk_field_users_field FOREIGN KEY (`field_id`) REFERENCES `fields` (`id`) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_field_users_user FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='圃場とユーザー（作業者）を紐づける中間テーブル';

ALTER TABLE `work_reports` DROP COLUMN `created_by`;

ALTER TABLE `work_reports` DROP COLUMN `updated_by`;
