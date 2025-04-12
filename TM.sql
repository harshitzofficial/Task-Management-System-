--  1. Create and use the database
DROP DATABASE IF EXISTS ml_project_db;
CREATE DATABASE ml_project_db;
USE ml_project_db;

-- 2. Drop existing tables to avoid conflicts
DROP TABLE IF EXISTS Works_On, Comment, Attachment, Task, Project, User;

-- 3. Create Tables

-- User Table
CREATE TABLE User (
    user_id INT PRIMARY KEY,
    user_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    password VARCHAR(100),
    role VARCHAR(50)
);

-- Project Table
CREATE TABLE Project (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(100),
    description TEXT,
    start_date DATE,
    end_date DATE,
    status VARCHAR(50),
    manager_id INT,
    FOREIGN KEY (manager_id) REFERENCES User(user_id)
);

-- Task Table
CREATE TABLE Task (
    task_id INT PRIMARY KEY,
    title VARCHAR(100),
    description TEXT,
    due_date DATE,
    priority VARCHAR(20),
    status VARCHAR(50),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    project_id INT,
    created_by INT,
    assigned_to INT,
    FOREIGN KEY (project_id) REFERENCES Project(project_id),
    FOREIGN KEY (created_by) REFERENCES User(user_id),
    FOREIGN KEY (assigned_to) REFERENCES User(user_id)
);

-- Attachment Table
CREATE TABLE Attachment (
    attachment_id INT PRIMARY KEY,
    task_id INT,
    file_name VARCHAR(255),
    file_path VARCHAR(255),
    uploaded_at TIMESTAMP,
    FOREIGN KEY (task_id) REFERENCES Task(task_id)
);

-- Comment Table
CREATE TABLE Comment (
    comment_id INT PRIMARY KEY,
    task_id INT,
    user_id INT,
    content TEXT,
    created_at TIMESTAMP,
    FOREIGN KEY (task_id) REFERENCES Task(task_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id)
);

-- Works_On Table (Many-to-Many between User and Project)
CREATE TABLE Works_On (
    user_id INT,
    project_id INT,
    PRIMARY KEY (user_id, project_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (project_id) REFERENCES Project(project_id)
);

--  4. Insert Data

-- Insert Users
INSERT INTO User (user_id, user_name, email, password, role) VALUES
(1, 'Ishaan Yadav', 'ishaan@example.com', 'password123', 'Developer'),
(2, 'Harshit Singh', 'harshit@example.com', 'password123', 'Developer'),
(3, 'Harshvardhan', 'harshvardhan@example.com', 'password123', 'Analyst'),
(4, 'Keshav', 'keshav@example.com', 'password123', 'Developer'),
(5, 'Kapil ', 'kapil@example.com', 'password123', 'Developer'),
(6, 'Kishan', 'kishan@example.com', 'password123', 'Developer');

-- Insert Projects
INSERT INTO Project (project_id, project_name, description, start_date, end_date, status, manager_id) VALUES
(1, 'ML Text Classifier', 'A machine learning project for text classification', '2025-04-01', '2025-05-01', 'Ongoing', 1),
(2, 'Cancer Classification', 'Classify cancer using ML techniques', '2025-04-01', '2025-05-15', 'Ongoing', 2),
(3, 'Heart Disease Detection', 'Detecting heart disease using predictive models', '2025-04-01', '2025-05-10', 'Ongoing', 3);

-- Assign Users to Projects (Works_On)
INSERT INTO Works_On (user_id, project_id) VALUES
(1, 1), (1, 2), (1, 3), 
(2, 1), (2, 3), 
(3, 2), 
(4, 3), 
(5, 1), (5, 2),
(6, 3);

-- Insert Tasks
INSERT INTO Task (task_id, title, description, due_date, priority, status, created_at, updated_at, project_id, created_by, assigned_to) VALUES
(1, 'Decision Trees & KNN', 'Harshvardhan working on DT and KNN for text classification', '2025-04-10', 'High', 'In Progress', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 1, 1, 3),
(2, 'KNN, SVM, Naive Bayes', 'Ishaan and Kapil on KNN, SVM, and Naive Bayes', '2025-04-15', 'High', 'In Progress', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 2, 2, 1),
(3, 'Bayes & SVM', 'Harshit on Bayes and SVM for heart disease detection', '2025-04-12', 'Medium', 'In Progress', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 3, 3, 2),
(4, 'Model Tuning & Evaluation', 'Kishan working on model evaluation and parameter tuning', '2025-04-20', 'Medium', 'In Progress', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 3, 3, 6);

-- Insert Attachments
INSERT INTO Attachment (attachment_id, task_id, file_name, file_path, uploaded_at) VALUES
(1, 1, 'decision_tree_model.py', '/models/decision_tree_model.py', CURRENT_TIMESTAMP),
(2, 1, 'knn_model.py', '/models/knn_model.py', CURRENT_TIMESTAMP),
(3, 2, 'svm_model.py', '/models/svm_model.py', CURRENT_TIMESTAMP),
(4, 2, 'naive_bayes_model.py', '/models/naive_bayes_model.py', CURRENT_TIMESTAMP),
(5, 3, 'bayes_model.py', '/models/bayes_model.py', CURRENT_TIMESTAMP),
(6, 4, 'model_evaluation.py', '/models/model_evaluation.py', CURRENT_TIMESTAMP);

-- Insert Comments
INSERT INTO Comment (comment_id, task_id, user_id, content, created_at) VALUES
(1, 1, 3, 'Started working on Decision Tree model.', CURRENT_TIMESTAMP),
(2, 1, 3, 'KNN integration done, testing in progress.', CURRENT_TIMESTAMP),
(3, 2, 1, 'Naive Bayes model added, performance looks good.', CURRENT_TIMESTAMP),
(4, 3, 2, 'SVM model trained, results shared.', CURRENT_TIMESTAMP),
(5, 3, 2, 'Bayes classifier tuning in progress.', CURRENT_TIMESTAMP),
(6, 4, 6, 'Finished grid search and model tuning for Random Forest.', CURRENT_TIMESTAMP);

--  5. Show All Tables
SHOW TABLES;

--  6. View contents (optional)
SELECT * FROM User;
SELECT * FROM Project;
SELECT * FROM Task;
SELECT * FROM Attachment;
SELECT * FROM Comment;
SELECT * FROM Works_On;

SELECT 
    T.task_id,
    T.title,
    P.project_name,
    U.user_name AS assigned_to
FROM Task T
JOIN Project P ON T.project_id = P.project_id
JOIN User U ON T.assigned_to = U.user_id;

SELECT 
    U.user_name,
    P.project_name
FROM Works_On W
JOIN User U ON W.user_id = U.user_id
JOIN Project P ON W.project_id = P.project_id;
