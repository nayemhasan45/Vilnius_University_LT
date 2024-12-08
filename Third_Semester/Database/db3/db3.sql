CREATE TABLE groups (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    group_name VARCHAR(50) NOT NULL
);
INSERT INTO groups (group_name)
SELECT DISTINCT `group` FROM student;
ALTER TABLE student
ADD COLUMN groups_ID INT;
UPDATE student
INNER JOIN groups ON student.`group` = groups.group_name
SET student.groups_ID = groups.ID;
ALTER TABLE student
DROP COLUMN `group`;
ALTER TABLE student
ADD CONSTRAINT fk_groups
FOREIGN KEY (groups_ID) REFERENCES groups(ID);
CREATE TABLE cities (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    city_name VARCHAR(50) NOT NULL
);

CREATE TABLE statuses (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(50) NOT NULL
);
INSERT INTO cities (city_name)
SELECT DISTINCT city FROM student;

INSERT INTO statuses (status_name)
SELECT DISTINCT status FROM student;
ALTER TABLE student
ADD COLUMN city_ID INT,
ADD COLUMN status_ID INT;
UPDATE student
INNER JOIN cities ON student.city = cities.city_name
SET student.city_ID = cities.ID;

UPDATE student
INNER JOIN statuses ON student.status = statuses.status_name
SET student.status_ID = statuses.ID;
ALTER TABLE student
DROP COLUMN city,
DROP COLUMN status;
ALTER TABLE student
ADD CONSTRAINT fk_cities
FOREIGN KEY (city_ID) REFERENCES cities(ID);

ALTER TABLE student
ADD CONSTRAINT fk_statuses
FOREIGN KEY (status_ID) REFERENCES statuses(ID);
