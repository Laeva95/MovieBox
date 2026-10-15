/* =========================================================
   MovieBox Database
   - member       : 회원
   - movie        : 영화
   - review       : 리뷰
   - notice		  : 공지사항
   - favorite     : 찜/관심영화
   - reservation  : 예매
   - store		  : 매점
   ========================================================= */

DROP DATABASE IF EXISTS moviebox;
CREATE DATABASE moviebox;
USE moviebox;

DROP USER IF EXISTS 'teamid'@'%';
CREATE USER 'teamid'@'%' IDENTIFIED BY 'teampass';
GRANT ALL PRIVILEGES ON moviebox.* TO 'teamid'@'%';
FLUSH PRIVILEGES;

/* =========================================================
   회원
   ========================================================= */
CREATE TABLE member (
    member_id       VARCHAR(12) PRIMARY KEY,
    member_pass     VARCHAR(255) NOT NULL,
    member_name     VARCHAR(20) NOT NULL,
    reg_date        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    age             INT,
    gender          VARCHAR(5),
    email           VARCHAR(100) unique,
    address         VARCHAR(500),
    tel             VARCHAR(20),
    mtel            VARCHAR(20)
);


/* =========================================================
   영화
   ========================================================= */
CREATE TABLE movie (
    movie_id        INT AUTO_INCREMENT PRIMARY KEY,
    title           VARCHAR(200) NOT NULL unique, 
    genre           VARCHAR(100) NOT NULL,
    running_time    VARCHAR(20) NOT NULL,
    release_date    DATE NOT NULL,
    poster          VARCHAR(500),
    summary         VARCHAR(2000),
    director        VARCHAR(100),
    actors          VARCHAR(500),
    country			varchar(20)
 );  
ALTER TABLE movie ADD COLUMN vod_url VARCHAR(500) DEFAULT NULL;
ALTER TABLE movie ADD COLUMN stills TEXT DEFAULT NULL;
ALTER TABLE movie ADD COLUMN watch_grade VARCHAR(50);

/* =========================================================
	리뷰
   ========================================================= */
CREATE TABLE review (
    review_id       INT AUTO_INCREMENT PRIMARY KEY,
    movie_id        INT NOT NULL,
    member_id       VARCHAR(12) NOT NULL,
    rating          INT NOT NULL,
    content         VARCHAR(1000) NOT NULL,
    reg_date        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    like_count      INT NOT NULL DEFAULT 0,

    FOREIGN KEY (movie_id)
        REFERENCES movie(movie_id)
        ON DELETE CASCADE,

    FOREIGN KEY (member_id)
        REFERENCES member(member_id)
        ON DELETE CASCADE,

    CHECK (rating BETWEEN 1 AND 10)
);

/* =========================================================
	공지사항
   ========================================================= */
CREATE TABLE notice (
    notice_id       INT AUTO_INCREMENT PRIMARY KEY,
    title           VARCHAR(200) NOT NULL,
    content         TEXT NOT NULL,
	writer           VARCHAR(50) NOT NULL,
    filename      VARCHAR(255),   -- 업로드 요청시 첨부했던 원본 파일명
    filerealname  VARCHAR(255),   -- 실제 upload 폴더에 저장된 파일명
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    view_count      INT NOT NULL DEFAULT 0
);
/* =========================================================
	찜/관심영화
   ========================================================= */
CREATE TABLE movie_favorite (
    favorite_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id VARCHAR(12) NOT NULL,
    movie_id INT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (member_id)
        REFERENCES member(member_id)
        ON DELETE CASCADE,

    FOREIGN KEY (movie_id)
        REFERENCES movie(movie_id)
        ON DELETE CASCADE,

    UNIQUE (member_id, movie_id)
);


/* =========================================================
   예매
   ========================================================= */
   
   CREATE TABLE reservation (
    reservation_id INT AUTO_INCREMENT PRIMARY KEY,

    member_id VARCHAR(12) NOT NULL,
    movie_id INT NOT NULL,

    reservation_date DATE NOT NULL,
    screening_id INT NOT NULL,
    seat_number VARCHAR(10) NOT NULL,

    FOREIGN KEY (member_id)
        REFERENCES member(member_id)
        ON DELETE CASCADE,

    FOREIGN KEY (movie_id)
        REFERENCES movie(movie_id)
        ON DELETE CASCADE,

    CHECK (screening_id BETWEEN 1 AND 4),

    UNIQUE (
        movie_id,
        reservation_date,
        screening_id,
        seat_number
    )
);


/* =========================================================
	매점 상품 목록
   ========================================================= */

CREATE TABLE store (
	id INT PRIMARY KEY,
    name VARCHAR(100),
    price INT,
    description VARCHAR(500),
    image VARCHAR(255),
    category VARCHAR(30)
);

ALTER TABLE notice ADD COLUMN is_pinned INT DEFAULT 0;
insert into member(member_id, member_pass, member_name, age, gender, email, address, tel, mtel) 
values('admin', '8M/3EtqZcgKKfrjcP3NPjw==:l14pfmX7RibfJh2RH+BkOsMRfaCIQezmUrpor1jjdwM=', '관리자', 20, '남', 'test@naver.com', '서울시 강남구 역삼동 역삼빌딩 2층 21호', '0511231239', '01022314234');

/* =========================================================
매점 주문
========================================================= */

CREATE TABLE store_orders (
order_id INT AUTO_INCREMENT PRIMARY KEY,
member_id VARCHAR(12) NOT NULL,
total_price INT NOT NULL,
order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
order_status VARCHAR(20) DEFAULT '주문완료',
FOREIGN KEY (member_id)
REFERENCES member(member_id)
);

/* =========================================================
매점 주문 상품
========================================================= */

CREATE TABLE store_order_items (
order_item_id INT AUTO_INCREMENT PRIMARY KEY,
order_id INT NOT NULL,
product_id INT NOT NULL,
product_name VARCHAR(100) NOT NULL,
quantity INT NOT NULL,
price INT NOT NULL,
FOREIGN KEY (order_id)
REFERENCES store_orders(order_id),
FOREIGN KEY (product_id)
REFERENCES store(id)
);
ALTER TABLE review ADD CONSTRAINT uk_movie_member UNIQUE (movie_id, member_id);
