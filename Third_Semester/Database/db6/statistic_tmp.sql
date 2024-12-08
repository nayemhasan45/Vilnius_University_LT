DELIMITER //

CREATE PROCEDURE UpdateStudentStatistics()
BEGIN
    DECLARE city_count INT;
    DECLARE city_name VARCHAR(17);

    -- Clear the existing `statistic_tmp` table for fresh data
    DELETE FROM statistic_tmp;

    -- Insert the count of students by city into `statistic_tmp`
    INSERT INTO statistic_tmp (city, student_count)
    SELECT city, COUNT(*) AS student_count
    FROM student
    GROUP BY city;
END //

DELIMITER ;
