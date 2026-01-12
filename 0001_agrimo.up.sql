CREATE TABLE `orgs` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `name` VARCHAR(128) NOT NULL COMMENT '組織名',
    `postal_code` VARCHAR(16) NOT NULL COMMENT '郵便番号',
    `address` VARCHAR(256) NOT NULL COMMENT '住所',
    `note` TEXT NOT NULL COMMENT '備考',
    `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',
    `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日時',
    `deleted_at` DATETIME DEFAULT NULL COMMENT '削除日時',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='組織';

CREATE TABLE `roles` (
    `id` INT UNSIGNED NOT NULL COMMENT 'ID',
    `name` VARCHAR(16) NOT NULL COMMENT '役割名',
    `description` VARCHAR(32) NOT NULL COMMENT '役割説明',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日時',
    `deleted_at` DATETIME DEFAULT NULL COMMENT '削除日時',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_roles_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='役割テーブル';

INSERT INTO `roles` (`id`, `name`, `description`) VALUES
(1, 'admin', '管理者'),
(2, 'owner', '代表者'),
(3, 'manager', '作業管理者'),
(4, 'worker', '作業者');

CREATE TABLE `users` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `org_id` INT UNSIGNED NOT NULL COMMENT '組織ID（orgs.id）',
    `parent_id` INT UNSIGNED DEFAULT NULL COMMENT '親ユーザーID（roleがadmin,ownerの場合はNULL）',
    `role_id` INT UNSIGNED NOT NULL COMMENT '役割ID（roles.id）',
    `email` VARCHAR(128) NOT NULL COMMENT 'メールアドレス',
    `password` VARCHAR(256) NOT NULL COMMENT 'パスワード',
    `name` VARCHAR(64) DEFAULT NULL COMMENT '法人名',
    `last_name` VARCHAR(64) NOT NULL COMMENT '姓',
    `first_name` VARCHAR(64) NOT NULL COMMENT '名',
    `postal_code` VARCHAR(16) NOT NULL COMMENT '郵便番号',
    `address` VARCHAR(256) NOT NULL COMMENT '住所',
    `gender` ENUM('male', 'female', 'other') DEFAULT 'male' COMMENT '性別（male：男性、female：女性、other：その他）',
    `birthday` DATE NOT NULL COMMENT '生年月日',
    `note` TEXT NOT NULL COMMENT '備考',
    `last_login_at` DATETIME DEFAULT NULL COMMENT '最終ログイン日時',
    -- `created_by` INT UNSIGNED NOT NULL COMMENT '作成者ID',
    -- `updated_by` INT UNSIGNED NOT NULL COMMENT '最終更新者ID',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日時',
    `deleted_at` DATETIME DEFAULT NULL COMMENT '削除日時',
    PRIMARY KEY (`id`),
    CONSTRAINT fk_users_org FOREIGN KEY (`org_id`) REFERENCES `orgs` (`id`) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='ユーザー';

CREATE TABLE `field_types` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `name` VARCHAR(16) DEFAULT NULL COMMENT '圃場タイプ名',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日時',
    `deleted_at` DATETIME DEFAULT NULL COMMENT '削除日時',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_field_types_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='圃場タイプ';

CREATE TABLE `fields` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `org_id` INT UNSIGNED NOT NULL COMMENT '組織ID（orgs.id）',
    `user_id` INT UNSIGNED NOT NULL COMMENT '利用者ID（users.id）',
    `field_code` VARCHAR(50) NULL COMMENT '圃場の外部連携用コード（任意）',
    `name` VARCHAR(128) NOT NULL COMMENT '圃場名',
    `latitude` DECIMAL(10,7) NOT NULL COMMENT '緯度',
    `longitude` DECIMAL(10,7) NOT NULL COMMENT '経度',
    `elevation` DECIMAL(7,3) NULL COMMENT '標高（m）',
    `area` DECIMAL(12,3) NULL COMMENT '圃場の面積（㎡）',
    `boundary` GEOMETRY NOT NULL COMMENT '圃場の境界ポリゴン（WKT形式：POLYGON）',
    `postal_code` VARCHAR(16) NOT NULL COMMENT '郵便番号',
    `address` VARCHAR(256) NOT NULL COMMENT '住所',
    `field_type_id` INT UNSIGNED NOT NULL COMMENT '圃場タイプID（field_types.id）',
    `crop` VARCHAR(30) NOT NULL COMMENT '栽培作物（米、麦、トマトなど）',
    `status` ENUM('cultivated', 'fallow', 'abandoned') DEFAULT 'cultivated' COMMENT '利用状態（cultivated：耕作中、fallow：休耕中、abandoned：耕作放棄）',
    `note` TEXT NULL COMMENT '備考',
    -- `created_by` INT UNSIGNED NOT NULL COMMENT '作成者ID',
    -- `updated_by` INT UNSIGNED NOT NULL COMMENT '最終更新者ID',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日時',
    `deleted_at` DATETIME DEFAULT NULL COMMENT '削除日時',
    PRIMARY KEY (`id`),
    CONSTRAINT fk_fields_org FOREIGN KEY (`org_id`) REFERENCES `orgs` (`id`) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_fields_user FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE ON DELETE CASCADE,
    INDEX idx_fields_org_id (`org_id`),
    INDEX idx_fields_user_id (`user_id`),
    SPATIAL INDEX idx_fields_boundary (`boundary`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='圃場';

CREATE TABLE `reports` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `org_id` INT UNSIGNED NOT NULL COMMENT '組織ID（orgs.id）',
    `user_id` INT UNSIGNED NOT NULL COMMENT '利用者ID（users.id：対象ユーザー）',
    `field_id` INT UNSIGNED NOT NULL COMMENT '圃場ID（fields.id）',
    `report_date` DATE NOT NULL COMMENT '日報対象日',
    `image_url` VARCHAR(512) DEFAULT NULL COMMENT '画像URL（S3アップロード先）',
    `weather` ENUM('sunny', 'cloudy', 'rainy', 'snow', 'windy', 'storm', 'other') NULL COMMENT '天候（晴／曇／雨／雪／風／嵐／その他）',
    `temperature` DECIMAL(4,1) NULL COMMENT '気温（℃）',
    `humidity` DECIMAL(5,2) NULL COMMENT '湿度（％）',
    `work_type` ENUM(
        'tillage',        -- 耕起
        'plowing',        -- 耕耘・代かき
        'seeding',        -- 播種
        'planting',       -- 定植
        'fertilizing',    -- 施肥
        'watering',       -- 灌水
        'weeding',        -- 除草
        'pest_control',   -- 防除（農薬散布）
        'harvesting',     -- 収穫
        'inspection',     -- 点検・巡回
        'maintenance',    -- メンテナンス
        'other'           -- その他
    ) NULL COMMENT '作業内容の種類',
    `crop_condition` TEXT NULL COMMENT '作物状況（生育状況・病害虫・水位など）',
    `note` TEXT NULL COMMENT '備考',
    `created_by` INT UNSIGNED NOT NULL COMMENT '作成者ID',
    `updated_by` INT UNSIGNED NOT NULL COMMENT '最終更新者ID',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日時',
    `deleted_at` DATETIME DEFAULT NULL COMMENT '削除日時',
    PRIMARY KEY (`id`),
    CONSTRAINT fk_reports_org FOREIGN KEY (`org_id`) REFERENCES `orgs` (`id`) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_reports_user FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_reports_field FOREIGN KEY (`field_id`) REFERENCES `fields` (`id`) ON UPDATE CASCADE ON DELETE CASCADE,
    INDEX idx_reports_org_id (`org_id`),
    INDEX idx_reports_user_id (`user_id`),
    INDEX idx_reports_field_id (`field_id`),
    INDEX idx_reports_date (`report_date`),
    INDEX idx_reports_created_by (`created_by`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='日報';

CREATE TABLE `field_users` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自動採番ID',
    `field_id` INT UNSIGNED NOT NULL COMMENT '圃場ID（fields.id）',
    `user_id` INT UNSIGNED NOT NULL COMMENT '作業者ユーザーID（users.id）',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日時',
    `deleted_at` DATETIME DEFAULT NULL COMMENT '削除日時',
    PRIMARY KEY (`id`),
    UNIQUE KEY uq_field_users_field_user (`field_id`, `user_id`),
    CONSTRAINT fk_field_users_field FOREIGN KEY (`field_id`) REFERENCES `fields` (`id`) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_field_users_user FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE ON DELETE CASCADE,
    INDEX idx_field_users_field (`field_id`),
    INDEX idx_field_users_user (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='圃場とユーザー（作業者）を紐づける中間テーブル';
