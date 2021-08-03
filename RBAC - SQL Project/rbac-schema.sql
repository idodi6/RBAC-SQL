/* The RBAC as a Moodle Example Database to represenet people in the system
roles of the people - students , lecturers, information */

DROP SCHEMA IF EXISTS rbac;
CREATE SCHEMA rbac;
USE rbac;

-- table structure for table resources -- 

CREATE TABLE resources (
    resource_id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    resource_name VARCHAR(45) UNIQUE NOT NULL,
    PRIMARY KEY (resource_id)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8MB4;

-- table structure for table operations -- 

CREATE TABLE operations (
    operation_id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    operation_name VARCHAR(45) UNIQUE NOT NULL,
    PRIMARY KEY (operation_id)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8MB4;

-- table structure for table subjects -- 

CREATE TABLE subjects (
    subject_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    email_address VARCHAR(256) UNIQUE NOT NULL,
    first_name VARCHAR(45) NOT NULL,
    last_name VARCHAR(45) NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    PRIMARY KEY (subject_id),
    KEY idx_subjects_last_name (last_name)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8MB4;

-- table structure for table permissions -- 

CREATE TABLE permissions (
    permission_id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    permission_name VARCHAR(45) UNIQUE NOT NULL,
    operation_id TINYINT UNSIGNED NOT NULL,
    resource_id TINYINT UNSIGNED NOT NULL,
    PRIMARY KEY (permission_id),
    KEY idx_permission_name (permission_name),
    KEY idx_fk_operation_id (operation_id),
    KEY idx_fk_resource_id (resource_id),
    CONSTRAINT fk_operation_id FOREIGN KEY (operation_id)
        REFERENCES operations (operation_id),
    CONSTRAINT fk_resource_id FOREIGN KEY (resource_id)
        REFERENCES resources (resource_id)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8MB4;

-- table structure for table roles --

CREATE TABLE roles (
    role_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    role_name VARCHAR(45) UNIQUE NOT NULL,
    parent SMALLINT UNSIGNED DEFAULT NULL,
    PRIMARY KEY (role_id),
    KEY idx_role_name (role_name),
    CONSTRAINT fk_roles_parent_role_id FOREIGN KEY (parent)
        REFERENCES roles (role_id)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8MB4;

-- table structure for table role_subject --

CREATE TABLE role_subject (
    role_id SMALLINT UNSIGNED NOT NULL,
    subject_id SMALLINT UNSIGNED NOT NULL,
    start_date TIMESTAMP DEFAULT NULL,
    end_date TIMESTAMP DEFAULT NULL,
    PRIMARY KEY (role_id , subject_id),
    KEY idx_subject_id (subject_id),
    CONSTRAINT fk_role_subject_role FOREIGN KEY (role_id)
        REFERENCES roles (role_id),
    CONSTRAINT fk_role_subject_subject FOREIGN KEY (subject_id)
        REFERENCES subjects (subject_id)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8MB4;

-- table structure for table role_permission --
CREATE TABLE role_permission (
    role_id SMALLINT UNSIGNED NOT NULL,
    permission_id TINYINT UNSIGNED NOT NULL,
    PRIMARY KEY (role_id , permission_id),
    KEY idx_permission_id (permission_id),
    CONSTRAINT fk_role_permission_role FOREIGN KEY (role_id)
        REFERENCES roles (role_id),
    CONSTRAINT fk_role_permission_permission FOREIGN KEY (permission_id)
        REFERENCES permissions (permission_id)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8MB4;
