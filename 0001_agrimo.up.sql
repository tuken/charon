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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='役割';

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
    CONSTRAINT fk_users_org FOREIGN KEY (`org_id`) REFERENCES `orgs` (`id`) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_users_role FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='ユーザー';

CREATE TABLE `field_types` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `name` VARCHAR(16) DEFAULT NULL COMMENT '圃場タイプ名',
    `sort_order` tinyint unsigned NOT NULL DEFAULT 0 COMMENT '表示順',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日時',
    `deleted_at` DATETIME DEFAULT NULL COMMENT '削除日時',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_field_types_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='圃場タイプ';

INSERT INTO `field_types` (`id`, `name`) VALUES
(1, '水田'),
(2, '畑'),
(3, '果樹園'),
(4, '牧場'),
(5, '温室'),
(6, 'その他');

CREATE TABLE `fields` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id` INT UNSIGNED NOT NULL COMMENT '所有者ユーザーID（users.id）',
    `field_type_id` INT UNSIGNED NOT NULL COMMENT '圃場タイプID（field_types.id）',
    `field_code` VARCHAR(50) NULL COMMENT '圃場の外部連携用コード（任意）',
    `name` VARCHAR(128) NOT NULL COMMENT '圃場名',
    `latitude` DECIMAL(10,7) NOT NULL COMMENT '緯度',
    `longitude` DECIMAL(10,7) NOT NULL COMMENT '経度',
    `elevation` DECIMAL(7,3) NULL COMMENT '標高（m）',
    `area` DECIMAL(12,3) NULL COMMENT '圃場の面積（㎡）',
    `boundary` GEOMETRY NOT NULL COMMENT '圃場の境界ポリゴン（WKT形式：POLYGON）',
    `postal_code` VARCHAR(16) NOT NULL COMMENT '郵便番号',
    `address` VARCHAR(256) NOT NULL COMMENT '住所',
    `crop` VARCHAR(30) NOT NULL COMMENT '栽培作物（米、麦、トマトなど）',
    `status` ENUM('cultivated', 'fallow', 'abandoned') DEFAULT 'cultivated' COMMENT '利用状態（cultivated：耕作中、fallow：休耕中、abandoned：耕作放棄）',
    `note` TEXT NULL COMMENT '備考',
    -- `created_by` INT UNSIGNED NOT NULL COMMENT '作成者ID',
    -- `updated_by` INT UNSIGNED NOT NULL COMMENT '最終更新者ID',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日時',
    `deleted_at` DATETIME DEFAULT NULL COMMENT '削除日時',
    PRIMARY KEY (`id`),
    INDEX idx_fields_user_id (`user_id`),
    INDEX idx_fields_field_type_id (`field_type_id`),
    CONSTRAINT fk_fields_user FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_fields_field_type FOREIGN KEY (`field_type_id`) REFERENCES `field_types` (`id`) ON UPDATE CASCADE ON DELETE CASCADE,
    SPATIAL INDEX idx_fields_boundary (`boundary`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='圃場';

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

CREATE TABLE `work_types` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `name` VARCHAR(16) DEFAULT NULL COMMENT '作業タイプ名',
    `sort_order` tinyint unsigned NOT NULL DEFAULT 0 COMMENT '表示順',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日時',
    `deleted_at` DATETIME DEFAULT NULL COMMENT '削除日時',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_work_types_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='作業タイプ';

INSERT INTO `work_types` (`id`, `name`) VALUES
(1, '耕起'),
(2, '耕耘・代かき'),
(3, '播種'),
(4, '定植'),
(5, '施肥'),
(6, '灌水'),
(7, '除草'),
(8, '防除（農薬散布）'),
(9, '収穫'),
(10, '点検・巡回'),
(11, 'メンテナンス'),
(12, 'その他');

CREATE TABLE `crop_items` (
    `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `name` varchar(64) NOT NULL COMMENT '品目名（米/大豆/麦）',
    `sort_order` tinyint unsigned NOT NULL DEFAULT 0 COMMENT '表示順',
    `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',
    `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日時',
    `deleted_at` datetime DEFAULT NULL COMMENT '削除日時',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_crop_items_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='品目';

INSERT INTO `crop_items` (`id`, `name`) VALUES
(1, '米'),
(2, '大豆'),
(3, '麦'),
(4, 'いちご'),
(5, 'トマト'),
(6, 'その他');

CREATE TABLE `crop_varieties` (
    `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `crop_item_id` int unsigned NOT NULL COMMENT '品目ID（crop_items.id）',
    `category` varchar(32) DEFAULT NULL COMMENT 'カテゴリ（例：主食米/直播米/飼料米/うるち米）',
    `name` varchar(64) NOT NULL COMMENT '品種名',
    `sort_order` smallint unsigned NOT NULL DEFAULT 0 COMMENT '表示順',
    `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',
    `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日時',
    `deleted_at` datetime DEFAULT NULL COMMENT '削除日時',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_crop_varieties_item_name` (`crop_item_id`, `name`),
    KEY `idx_crop_varieties_item` (`crop_item_id`),
    CONSTRAINT `fk_crop_varieties_item` FOREIGN KEY (`crop_item_id`) REFERENCES `crop_items` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='品種';

INSERT INTO `crop_varieties` (`id`, `crop_item_id`, `name`) VALUES
(1, 1, 'コシヒカリ'),
(2, 1, 'ササニシキ'),
(3, 1, 'ひとめぼれ'),
(4, 1, 'あきたこまち'),
(6, 2, 'フクユタカ'),
(7, 3, '麦'),
(8, 4, 'いちご'),
(9, 5, 'トマト'),
(10, 6, 'その他');

CREATE TABLE `work_reports` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id` INT UNSIGNED NOT NULL COMMENT '作業者ユーザーID（users.id）',
    `field_id` INT UNSIGNED NOT NULL COMMENT '圃場ID（fields.id）',
    `work_date` DATE NOT NULL COMMENT '作業日',
    `work_type_id` INT UNSIGNED NOT NULL COMMENT '作業タイプID（work_types.id）',
    `crop_variety_id` INT UNSIGNED NOT NULL COMMENT '品種ID（crop_varieties.id）',
    `weather_code` SMALLINT UNSIGNED NOT NULL COMMENT '天候コード（open-meteoで使用しているコード）',
    `work_detail` TEXT NULL COMMENT '作業詳細',
    `is_image` TINYINT NOT NULL DEFAULT 0 COMMENT '画像の有無（0：なし、1：あり）',
    `temperature` DECIMAL(4,1) NULL COMMENT '気温（℃）',
    `humidity` DECIMAL(5,2) NULL COMMENT '湿度（％）',
    `crop_condition` TEXT NULL COMMENT '作物状況（生育状況・病害虫・水位など）',
    `created_by` INT UNSIGNED NOT NULL COMMENT '作成者ID',
    `updated_by` INT UNSIGNED NOT NULL COMMENT '最終更新者ID',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日時',
    `deleted_at` DATETIME DEFAULT NULL COMMENT '削除日時',
    PRIMARY KEY (`id`),
    INDEX idx_work_reports_user_id (`user_id`),
    INDEX idx_work_reports_field_id (`field_id`),
    INDEX idx_work_reports_work_type_id (`work_type_id`),
    INDEX idx_work_reports_crop_variety_id (`crop_variety_id`),
    CONSTRAINT fk_work_reports_user FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_work_reports_field FOREIGN KEY (`field_id`) REFERENCES `fields` (`id`) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_work_reports_work_type FOREIGN KEY (`work_type_id`) REFERENCES `work_types` (`id`) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_work_reports_crop_variety FOREIGN KEY (`crop_variety_id`) REFERENCES `crop_varieties` (`id`) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='作業レポート';
