/*Here is the rbac-data File where all the data well be updated,
furthermore, the 3 queries will be implemented.
The data will be a sample data */
-- inserting data into table subjects -- 
SET FOREIGN_KEY_CHECKS = 0;

INSERT INTO subjects(`email_address`, `first_name`, `last_name`, `phone_number`) VALUES 
('johnluke@gmail.com','John','Luke','9293495533'),
('davidsmith@outlook.com','Davis','Smith','9112342322'),
('thomasjohnson@gmail.com','Thomas','Johnson','4435454544'),
('bryanrock@yahoo.com','Bryan','Rock','3342221235'),
('chadtravis@gmail.com','Chad','Travis','8873214565'),
('evangosley@outlook.com','Evan','Gosley','5565778787');

-- inserting data into table roles -- 

INSERT INTO roles (`role_name`, `parent`) VALUES 
('Student',2),
('Lecturer',3),
('Student Administration',null),
('Junior IT Developer',5),
('Senior IT Developer',6),
('IT Branch Manager',null);


-- inserting data into table operations -- 

INSERT INTO operations(`operation_name`) VALUES 
('View'),
('Create'),
('Edit'),
('Delete'),
('Backup');

-- inerting data into resources -- 

INSERT INTO resources(`resource_name`) VALUES 
('Grade'),
('Courses'),
('Account'),
('History');

-- inserting data into table permissions -- 
INSERT INTO permissions(`permission_name`,`operation_id`,`resource_id`) VALUES 
('View The Grade', 1, 1),
('Create A Grade', 2, 1),
('Edit A Course',3 , 2),
('Edit An Account',3,3),
('Delete An Account',4,3),
('Backup History',5,4);

-- ןinserting data into table role_permission -- 
INSERT INTO role_permission VALUES 
(1,1),
(2,2),
(3,3),
(4,4),
(5,5),
(6,6);


-- inserting data into table role_ subject

INSERT INTO role_subject(`role_id`,`subject_id`,`start_date`,`end_date`) VALUES 
(3,1, NULL, NULL),
(2,2,"2021-05-12 18:00:25", NULL),
(1,3,"2020-03-22 08:15:30","2022-01-01 00:00:00"),
(4,6, NULL, NULL),
(5,5,"2015-04-01 08:00:00","2021-01-08 08:30:30"),
(6,4, NULL, NULL);

SET FOREIGN_KEY_CHECKS = 1;

# Now we will create the sample Data and check for its correctness by querying some tasks

USE rbac;

-- Query 1 - Direct Permissions 

SELECT 
    subject_id,
    first_name,
    last_name,
    permission_id,
    permission_name
FROM
    subjects
        JOIN
    role_subject USING (subject_id)
        JOIN
    roles USING (role_id)
        JOIN
    role_permission USING (role_id)
        JOIN
    permissions USING (permission_id);
    
-- Query 2 - Effective permissions 

SELECT 
    subject_id,
    first_name,
    last_name,
    permissions.permission_id,
    permissions.permission_name
FROM
    subjects
        JOIN
    role_subject USING (subject_id)
        JOIN
    roles AS `role1` USING (role_id)
        LEFT JOIN
    roles AS `role2` ON role1.role_id = role2.parent
        LEFT JOIN
    roles AS `role3` ON role2.role_id = role3.parent
        JOIN
    role_permission AS `rp1` ON role1.role_id = rp1.role_id
        OR role2.role_id = rp1.role_id
        OR role3.role_id = rp1.role_id
        LEFT JOIN
    permissions USING (permission_id);

-- Query 3 - Enabled and Effective permissions

SELECT 
    subject_id,
    first_name,
    last_name,
    permissions.permission_id,
    permissions.permission_name
FROM
    subjects
        JOIN
    role_subject USING (subject_id)
        JOIN
    roles AS `role1` USING (role_id)
        LEFT JOIN
    roles AS `role2` ON role1.role_id = role2.parent
        LEFT JOIN
    roles AS `role3` ON role2.role_id = role3.parent
        JOIN
    role_permission AS `rp1` ON role1.role_id = rp1.role_id
        OR role2.role_id = rp1.role_id
        OR role3.role_id = rp1.role_id
        LEFT JOIN
    permissions USING (permission_id)
WHERE
    ((role_subject.start_date < CURRENT_TIMESTAMP()
        AND role_subject.end_date IS NULL)
        OR (role_subject.end_date > CURRENT_TIMESTAMP()
        AND role_subject.start_date IS NULL)
        OR (role_subject.start_date < CURRENT_TIMESTAMP()
        AND role_subject.end_date > CURRENT_TIMESTAMP())
        OR ((role_subject.start_date IS NULL
        AND role_subject.end_date IS NULL)));


