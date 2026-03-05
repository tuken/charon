ALTER TABLE `work_reports` ADD COLUMN `updated_by` INT UNSIGNED NOT NULL COMMENT '最終更新者ID' AFTER `crop_condition`;

ALTER TABLE `work_reports` ADD COLUMN `created_by` INT UNSIGNED NOT NULL COMMENT '作成者ID' AFTER `crop_condition`;

DROP TABLE `field_users`;

CREATE TABLE `field_users` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自動採番ID',
    `field_id` INT UNSIGNED NOT NULL COMMENT '圃場ID（fields.id）',
    `user_id` INT UNSIGNED NOT NULL COMMENT '作業者ユーザーID（users.id）',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日時',
    `deleted_at` DATETIME DEFAULT NULL COMMENT '削除日時',
    PRIMARY KEY (`id`),
    UNIQUE KEY uq_field_users_field_user (`field_id`, `user_id`),
    INDEX idx_field_users_field (`field_id`),
    INDEX idx_field_users_user (`user_id`),
    CONSTRAINT fk_field_users_field FOREIGN KEY (`field_id`) REFERENCES `fields` (`id`) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_field_users_user FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='圃場とユーザー（作業者）を紐づける中間テーブル';

ALTER TABLE `fields` MODIFY COLUMN `crop` VARCHAR(30) NOT NULL COMMENT '栽培作物（米、麦、トマトなど）';

ALTER TABLE `fields` MODIFY COLUMN `boundary` GEOMETRY NOT NULL COMMENT '圃場の境界ポリゴン（WKT形式：POLYGON）';

ALTER TABLE `users` CHANGE COLUMN `farm_name` `name` VARCHAR(64) DEFAULT NULL COMMENT '法人名';

ALTER `orgs` DROP COLUMN `longitude`;

ALTER `orgs` DROP COLUMN `latitude`;
