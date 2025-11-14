CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    age INT,
    grade NUMERIC(5,2)
);

INSERT INTO students (name, age, grade) VALUES
('Alice', 20, 85.5),
('Bob', 21, 90.0),
('Charlie', 19, 78.0),
('Diana', 22, 92.5),
('Ethan', 20, 88.0),
('Fiona', 21, 75.0),
('George', 23, 95.0),
('Hannah', 19, 80.0),
('Ian', 22, 89.5),
('Jane', 20, 91.0);


CREATE TABLE exams (
    exam_id SERIAL PRIMARY KEY,
    student_id INT REFERENCES students(student_id),
    score NUMERIC(5,2)
);

INSERT INTO exams (student_id, score) VALUES
(1, 87.0),
(1, 90.0),
(2, 88.0),
(2, 92.0),
(3, 76.0),
(3, 80.0),
(4, 91.0),
(4, 94.0),
(5, 85.0),
(5, 90.0),
(6, 70.0),
(6, 78.0),
(7, 93.0),
(7, 96.0),
(8, 79.0),
(8, 82.0),
(9, 88.0),
(9, 91.0),
(10, 90.0),
(10, 92.0);
