-- 参考サイト https://zenn.dev/koichi_51/articles/b9b5e11171ba83
CREATE TABLE `weather_codes` (
  `code` int unsigned NOT NULL COMMENT '天気コード',
  `japanese` varchar(32) NOT NULL COMMENT '天気の日本語表記',
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='天気コード';

INSERT INTO `weather_codes` (`code`, `japanese`) VALUES
(0, '晴れ'),
(1, '主に晴れ'),
(2, '一部曇り'),
(3, '曇り'),
(45, '霧'),
(48, '着氷霧'),
(51, '弱い霧雨'),
(53, '霧雨'),
(55, '強い霧雨'),
(56, '弱い着氷性の霧雨'),
(57, '強い着氷性の霧雨'),
(61, '小雨'),
(63, '雨'),
(65, '大雨'),
(66, '弱い着氷性の雨'),
(67, '強い着氷性の雨'),
(71, '小雪'),
(73, '雪'),
(75, '大雪'),
(77, 'みぞれ'),
(80, '弱いにわか雨'),
(81, 'にわか雨'),
(82, '強いにわか雨'),
(85, '弱いにわか雪'),
(86, 'にわか雪'),
(95, '雷雨'),
(96, '雷雨（小さいひょうを伴う）'),
(99, '雷雨（大きいひょうを伴う）');
