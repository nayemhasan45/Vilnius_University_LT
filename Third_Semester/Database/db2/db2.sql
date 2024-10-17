CREATE TABLE authors (
  author_id INT PRIMARY KEY AUTO_INCREMENT,
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  email VARCHAR(150) UNIQUE,
  bio TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE categories (
  category_id INT PRIMARY KEY AUTO_INCREMENT,
  category_name VARCHAR(100) UNIQUE
);

CREATE TABLE articles (
  article_id INT PRIMARY KEY AUTO_INCREMENT,
  title VARCHAR(255),
  content TEXT,
  published_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  author_id INT,
  category_id INT,
  status VARCHAR(50),
  FOREIGN KEY (author_id) REFERENCES authors(author_id),
  FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE comments (
  comment_id INT PRIMARY KEY AUTO_INCREMENT,
  article_id INT,
  author_name VARCHAR(100),
  comment_text TEXT,
  commented_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (article_id) REFERENCES articles(article_id)
);

CREATE TABLE tags (
  tag_id INT PRIMARY KEY AUTO_INCREMENT,
  tag_name VARCHAR(100) UNIQUE
);

CREATE TABLE article_tags (
  article_id INT,
  tag_id INT,
  PRIMARY KEY(article_id, tag_id),
  FOREIGN KEY (article_id) REFERENCES articles(article_id),
  FOREIGN KEY (tag_id) REFERENCES tags(tag_id)
);
