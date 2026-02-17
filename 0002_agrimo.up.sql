CREATE TABLE `sessions` (
  `session_id` varchar(128) NOT NULL COMMENT 'セッションID',
  `expires` int unsigned NOT NULL COMMENT '期限',
  `data` text COLLATE utf8mb4_bin COMMENT 'データ',
  PRIMARY KEY (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='セッション';
