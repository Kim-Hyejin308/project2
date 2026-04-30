-- ============================================================
-- 쓸랭 (Sseulaeng) ERD - MySQL DDL
-- ERD Cloud Import 전용
-- 생성일: 2025-04-25
-- 엔티티 18개 / 컬럼 131개
-- ============================================================

SET FOREIGN_KEY_CHECKS = 0;

-- ── 관리자 (UC-1·UC-2·UC-3·UC-4) ──
CREATE TABLE `admins` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '관리자 ID',
  `username` VARCHAR(50) NOT NULL COMMENT '관리자 아이디',
  `password_hash` VARCHAR(255) NOT NULL COMMENT '비밀번호 해시',
  `created_at` DATETIME NOT NULL COMMENT '생성일',
  PRIMARY KEY (`id`),
  UNIQUE KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='관리자';

-- ── 사용자 (UC-1·UC-2·UC-3·UC-4) ──
CREATE TABLE `users` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '사용자 ID',
  `email` VARCHAR(100) NOT NULL COMMENT '이메일',
  `password_hash` VARCHAR(255) COMMENT '비밀번호 해시 (소셜이면 NULL)',
  `name` VARCHAR(50) NOT NULL COMMENT '닉네임',
  `phone` VARCHAR(20) COMMENT '전화번호',
  `profile_img_url` VARCHAR(500) COMMENT '프로필 이미지 URL',
  `trust_score` DECIMAL(3,2) DEFAULT 0.00 COMMENT '신뢰도 점수',
  `point_balance` INT DEFAULT 0 COMMENT '포인트 잔액',
  `social_provider` VARCHAR(20) COMMENT '소셜 제공자 (kakao/google)',
  `social_id` VARCHAR(100) COMMENT '소셜 계정 ID',
  `is_blocked` BOOLEAN DEFAULT 0 COMMENT '관리자 제재 여부',
  `created_at` DATETIME NOT NULL COMMENT '가입일',
  `updated_at` DATETIME NOT NULL COMMENT '수정일',
  PRIMARY KEY (`id`),
  UNIQUE KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='사용자';

-- ── 카테고리 (UC-1·UC-2·UC-3·UC-4) ──
CREATE TABLE `categories` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '카테고리 ID',
  `name` VARCHAR(50) NOT NULL COMMENT '카테고리명',
  `parent_id` INT COMMENT '상위 카테고리 ID (self-ref)',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_categories_parent_id` FOREIGN KEY (`parent_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='카테고리';

-- ── 물품 (UC-1·UC-2·UC-3·UC-4) ──
CREATE TABLE `items` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '물품 ID',
  `user_id` BIGINT NOT NULL COMMENT '등록자 ID → users.id',
  `category_id` INT COMMENT '카테고리 ID → categories.id',
  `title` VARCHAR(200) NOT NULL COMMENT '물품명',
  `description` TEXT COMMENT '물품 설명',
  `trade_type` ENUM NOT NULL COMMENT ''대여','판매','나눔'',
  `price` INT DEFAULT 0 COMMENT '거래가격',
  `deposit` INT DEFAULT 0 COMMENT '보증금 (대여 시)',
  `status` ENUM DEFAULT '등록' COMMENT ''등록','예약','거래완료','비공개','삭제'',
  `view_count` INT DEFAULT 0 COMMENT '조회수',
  `created_at` DATETIME NOT NULL COMMENT '등록일',
  `updated_at` DATETIME NOT NULL COMMENT '수정일',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_items_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_items_category_id` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='물품';

-- ── 물품 이미지 (UC-1·UC-2·UC-3·UC-4) ──
CREATE TABLE `item_images` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '이미지 ID',
  `item_id` BIGINT NOT NULL COMMENT '물품 ID → items.id',
  `image_url` VARCHAR(500) NOT NULL COMMENT '이미지 URL',
  `order_num` INT DEFAULT 0 COMMENT '이미지 순서',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_item_images_item_id` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='물품 이미지';

-- ── 물품 해시태그 (UC-1·UC-2·UC-3·UC-4) ──
CREATE TABLE `item_hashtags` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '해시태그 ID',
  `item_id` BIGINT NOT NULL COMMENT '물품 ID → items.id',
  `tag` VARCHAR(50) NOT NULL COMMENT '해시태그',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_item_hashtags_item_id` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='물품 해시태그';

-- ── 관심목록 (UC-1·UC-2·UC-3·UC-4) ──
CREATE TABLE `wishlists` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '관심 ID',
  `user_id` BIGINT NOT NULL COMMENT '사용자 ID → users.id',
  `item_id` BIGINT NOT NULL COMMENT '물품 ID → items.id',
  `created_at` DATETIME NOT NULL COMMENT '등록일',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_wishlists_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_wishlists_item_id` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='관심목록';

-- ── 거래 (UC-1·UC-2·UC-3·UC-4) ──
CREATE TABLE `transactions` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '거래 ID',
  `item_id` BIGINT NOT NULL COMMENT '물품 ID → items.id',
  `seller_id` BIGINT NOT NULL COMMENT '판매자 ID → users.id',
  `buyer_id` BIGINT NOT NULL COMMENT '구매자 ID → users.id',
  `trade_type` ENUM NOT NULL COMMENT ''대여','구매','나눔'',
  `status` ENUM DEFAULT '채팅중' COMMENT ''채팅중','예약','거래완료','취소'',
  `price` INT DEFAULT 0 COMMENT '거래가격',
  `deposit` INT DEFAULT 0 COMMENT '보증금',
  `scheduled_at` DATETIME COMMENT '거래 예정일',
  `completed_at` DATETIME COMMENT '거래 완료일',
  `created_at` DATETIME NOT NULL COMMENT '거래 시작일',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_transactions_item_id` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_transactions_seller_id` FOREIGN KEY (`seller_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_transactions_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='거래';

-- ── 결제 (UC-1·UC-2·UC-3·UC-4) ──
CREATE TABLE `payments` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '결제 ID',
  `transaction_id` BIGINT NOT NULL COMMENT '거래 ID → transactions.id',
  `payer_id` BIGINT NOT NULL COMMENT '결제자 ID → users.id',
  `payment_type` ENUM NOT NULL COMMENT ''대여금','보증금','수수료'',
  `amount` INT NOT NULL COMMENT '결제금액',
  `method` VARCHAR(50) COMMENT '결제수단 (카드/카카오페이 등)',
  `status` ENUM DEFAULT '완료' COMMENT ''완료','환불','실패'',
  `paid_at` DATETIME NOT NULL COMMENT '결제일시',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_payments_transaction_id` FOREIGN KEY (`transaction_id`) REFERENCES `transactions` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_payments_payer_id` FOREIGN KEY (`payer_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='결제';

-- ── 배달대행 (UC-1·UC-2·UC-3·UC-4) ──
CREATE TABLE `delivery_requests` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '배달대행 ID',
  `transaction_id` BIGINT NOT NULL COMMENT '거래 ID → transactions.id',
  `requester_id` BIGINT NOT NULL COMMENT '신청자 ID → users.id',
  `pickup_address` VARCHAR(500) NOT NULL COMMENT '픽업 주소',
  `delivery_address` VARCHAR(500) NOT NULL COMMENT '배송 주소',
  `weight` DECIMAL(5,2) COMMENT '무게 (kg)',
  `is_fragile` BOOLEAN DEFAULT 0 COMMENT '파손위험 여부',
  `pickup_method` VARCHAR(100) COMMENT '수령방식',
  `fee` INT DEFAULT 0 COMMENT '배달 수수료',
  `status` ENUM DEFAULT '신청' COMMENT ''신청','배달중','완료','취소'',
  `driver_location` VARCHAR(200) COMMENT '배달기사 현재 위치 (GPS)',
  `created_at` DATETIME NOT NULL COMMENT '신청일',
  `updated_at` DATETIME NOT NULL COMMENT '수정일',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_delivery_requests_transaction_id` FOREIGN KEY (`transaction_id`) REFERENCES `transactions` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_delivery_requests_requester_id` FOREIGN KEY (`requester_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='배달대행';

-- ── 채팅방 (UC-1·UC-2·UC-3·UC-4) ──
CREATE TABLE `chat_rooms` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '채팅방 ID',
  `item_id` BIGINT NOT NULL COMMENT '물품 ID → items.id',
  `transaction_id` BIGINT COMMENT '거래 ID → transactions.id',
  `sender_id` BIGINT NOT NULL COMMENT '발신자 ID → users.id',
  `receiver_id` BIGINT NOT NULL COMMENT '수신자 ID → users.id',
  `created_at` DATETIME NOT NULL COMMENT '생성일',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_chat_rooms_item_id` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_chat_rooms_transaction_id` FOREIGN KEY (`transaction_id`) REFERENCES `transactions` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_chat_rooms_sender_id` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_chat_rooms_receiver_id` FOREIGN KEY (`receiver_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='채팅방';

-- ── 메시지 (UC-1·UC-2·UC-3·UC-4) ──
CREATE TABLE `messages` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '메시지 ID',
  `chat_room_id` BIGINT NOT NULL COMMENT '채팅방 ID → chat_rooms.id',
  `sender_id` BIGINT NOT NULL COMMENT '발신자 ID → users.id',
  `content` TEXT NOT NULL COMMENT '메시지 내용',
  `msg_type` ENUM DEFAULT 'text' COMMENT ''text','image'',
  `is_read` BOOLEAN DEFAULT 0 COMMENT '읽음 여부',
  `created_at` DATETIME NOT NULL COMMENT '발신일시',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_messages_chat_room_id` FOREIGN KEY (`chat_room_id`) REFERENCES `chat_rooms` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_messages_sender_id` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='메시지';

-- ── 알림 (UC-1·UC-2·UC-3·UC-4) ──
CREATE TABLE `notifications` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '알림 ID',
  `user_id` BIGINT NOT NULL COMMENT '수신자 ID → users.id',
  `noti_type` ENUM NOT NULL COMMENT ''채팅','관심물품','배달대행','시스템'',
  `title` VARCHAR(200) COMMENT '알림 제목',
  `content` TEXT COMMENT '알림 내용',
  `reference_id` BIGINT COMMENT '참조 ID (거래/채팅 등)',
  `reference_type` VARCHAR(50) COMMENT '참조 유형',
  `is_read` BOOLEAN DEFAULT 0 COMMENT '읽음 여부',
  `created_at` DATETIME NOT NULL COMMENT '발생일시',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_notifications_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='알림';

-- ── 차단 (UC-1·UC-2·UC-3·UC-4) ──
CREATE TABLE `user_blocks` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '차단 ID',
  `blocker_id` BIGINT NOT NULL COMMENT '차단자 ID → users.id',
  `blocked_id` BIGINT NOT NULL COMMENT '피차단자 ID → users.id',
  `created_at` DATETIME NOT NULL COMMENT '차단일',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_user_blocks_blocker_id` FOREIGN KEY (`blocker_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_user_blocks_blocked_id` FOREIGN KEY (`blocked_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='차단';

-- ── 신고 (UC-1·UC-2·UC-3·UC-4) ──
CREATE TABLE `user_reports` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '신고 ID',
  `reporter_id` BIGINT NOT NULL COMMENT '신고자 ID → users.id',
  `reported_id` BIGINT COMMENT '피신고자 ID → users.id',
  `item_id` BIGINT COMMENT '신고 물품 ID → items.id',
  `reason` TEXT NOT NULL COMMENT '신고 사유',
  `status` ENUM DEFAULT '접수' COMMENT ''접수','처리중','완료'',
  `admin_memo` TEXT COMMENT '관리자 메모',
  `created_at` DATETIME NOT NULL COMMENT '신고일',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_user_reports_reporter_id` FOREIGN KEY (`reporter_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_user_reports_reported_id` FOREIGN KEY (`reported_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_user_reports_item_id` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='신고';

-- ── 포인트 내역 (UC-1·UC-2·UC-3·UC-4) ──
CREATE TABLE `point_histories` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '내역 ID',
  `user_id` BIGINT NOT NULL COMMENT '사용자 ID → users.id',
  `amount` INT NOT NULL COMMENT '변경 포인트 (양수=적립, 음수=사용)',
  `point_type` ENUM NOT NULL COMMENT ''적립','사용','환불'',
  `reference_id` BIGINT COMMENT '참조 ID',
  `description` VARCHAR(200) COMMENT '설명',
  `created_at` DATETIME NOT NULL COMMENT '일시',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_point_histories_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='포인트 내역';

-- ── 공지/이벤트 (UC-1·UC-2·UC-3·UC-4) ──
CREATE TABLE `notices` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '공지 ID',
  `admin_id` INT NOT NULL COMMENT '작성 관리자 ID → admins.id',
  `notice_type` ENUM NOT NULL COMMENT ''공지','이벤트'',
  `title` VARCHAR(200) NOT NULL COMMENT '제목',
  `content` TEXT NOT NULL COMMENT '내용',
  `is_published` BOOLEAN DEFAULT 1 COMMENT '공개 여부',
  `created_at` DATETIME NOT NULL COMMENT '등록일',
  `updated_at` DATETIME NOT NULL COMMENT '수정일',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_notices_admin_id` FOREIGN KEY (`admin_id`) REFERENCES `admins` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='공지/이벤트';

-- ── 메인 배너 (UC-1·UC-2·UC-3·UC-4) ──
CREATE TABLE `banners` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '배너 ID',
  `admin_id` INT NOT NULL COMMENT '관리자 ID → admins.id',
  `image_url` VARCHAR(500) NOT NULL COMMENT '배너 이미지 URL',
  `link_url` VARCHAR(500) COMMENT '클릭 링크 URL',
  `is_active` BOOLEAN DEFAULT 1 COMMENT '노출 여부',
  `display_order` INT DEFAULT 0 COMMENT '노출 순서',
  `created_at` DATETIME NOT NULL COMMENT '등록일',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_banners_admin_id` FOREIGN KEY (`admin_id`) REFERENCES `admins` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='메인 배너';

SET FOREIGN_KEY_CHECKS = 1;