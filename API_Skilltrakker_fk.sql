-- Sat 18 Jul 2020 07:49:01 PM -05
-- Model: API Skilltrakker    Version: 1.2

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema Skilltrakker_API
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS Skilltrakker_API ;

-- -----------------------------------------------------
-- Schema Skilltrakker_API
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS Skilltrakker_API DEFAULT CHARACTER SET utf8 ;
USE Skilltrakker_API ;

-- -----------------------------------------------------
-- Table gyms
-- -----------------------------------------------------
DROP TABLE IF EXISTS gyms ;

CREATE TABLE IF NOT EXISTS gyms (
  id INT NOT NULL AUTO_INCREMENT COMMENT 'GYM code',
  name VARCHAR(45) NOT NULL COMMENT 'GYM Name',
  description VARCHAR(45) NULL DEFAULT NULL COMMENT 'GYM Description',
  phone VARCHAR(45) NOT NULL COMMENT 'GYM Phone',
  web VARCHAR(45) NOT NULL COMMENT 'GYM web domain',
  address JSON NULL DEFAULT NULL COMMENT 'GYM Address in JSON format',
  timeline JSON NULL COMMENT 'GYM\` Timeline',
  PRIMARY KEY (id))
ENGINE = InnoDB
COMMENT = 'Table that stores gyms information';


-- -----------------------------------------------------
-- Table rol
-- -----------------------------------------------------
DROP TABLE IF EXISTS rol ;

CREATE TABLE IF NOT EXISTS rol (
  id INT NOT NULL COMMENT 'Rol\` Code',
  name VARCHAR(45) NOT NULL COMMENT 'Rol\` name, (Owner, Administrator,user)',
  access_level INT NOT NULL COMMENT 'Number that define the Access level of the rol.',
  PRIMARY KEY (id))
ENGINE = InnoDB
COMMENT = 'Table that stores USERS rol into the system';


-- -----------------------------------------------------
-- Table users
-- -----------------------------------------------------
DROP TABLE IF EXISTS users ;

CREATE TABLE IF NOT EXISTS users (
  id INT NOT NULL COMMENT 'USER\` code',
  email VARCHAR(45) NOT NULL COMMENT 'user\` email address',
  password VARCHAR(45) NOT NULL COMMENT 'user\` password for loging into the system',
  rol_id INT NOT NULL COMMENT 'ROL\` code',
  PRIMARY KEY (id),
  UNIQUE INDEX email_UNIQUE (email ASC),
  INDEX fk_users_rol1_idx (rol_id ASC))
ENGINE = InnoDB
COMMENT = 'Table that stores USERS information';


-- -----------------------------------------------------
-- Table gyms_has_users
-- -----------------------------------------------------
DROP TABLE IF EXISTS gyms_has_users ;

CREATE TABLE IF NOT EXISTS gyms_has_users (
  gyms_id INT NOT NULL COMMENT 'GYM\` Code',
  users_id INT NOT NULL COMMENT 'USER\` code',
  PRIMARY KEY (gyms_id, users_id),
  INDEX fk_gyms_has_users_users1_idx (users_id ASC),
  INDEX fk_gyms_has_users_gyms1_idx (gyms_id ASC))
ENGINE = InnoDB
COMMENT = 'Table that contains Gyms\`s users';


-- -----------------------------------------------------
-- Table gymnasts
-- -----------------------------------------------------
DROP TABLE IF EXISTS gymnasts ;

CREATE TABLE IF NOT EXISTS gymnasts (
  id INT NOT NULL AUTO_INCREMENT COMMENT 'Gymnast\` code',
  name VARCHAR(45) NOT NULL COMMENT 'Gymnast\` name',
  birth_date DATE NOT NULL COMMENT 'Gymnast\` birth date',
  life_time_score INT NOT NULL DEFAULT 0 COMMENT 'Score gather by an gymnast since is member of a gym.',
  current_streak_points INT NOT NULL DEFAULT 0 COMMENT 'Amount of points adquired by a Gymnas for loging everyday, is reset after 1 day of not loging.',
  last_streak DATE NULL DEFAULT NULL COMMENT 'Last amount of points before the gymnast lost his streak\n',
  about MEDIUMTEXT NULL DEFAULT NULL COMMENT 'Decription of the gymnast\n',
  created DATE NOT NULL,
  updated DATE NOT NULL,
  gyms_has_users_gyms_id INT NOT NULL,
  gyms_has_users_users_id INT NOT NULL,
  PRIMARY KEY (id),
  INDEX fk_gymnasts_gyms_has_users1_idx (gyms_has_users_gyms_id ASC, gyms_has_users_users_id ASC))
ENGINE = InnoDB
COMMENT = 'Table that stores GYMNASTS information';


-- -----------------------------------------------------
-- Table classes
-- -----------------------------------------------------
DROP TABLE IF EXISTS classes ;

CREATE TABLE IF NOT EXISTS classes (
  id INT NOT NULL AUTO_INCREMENT COMMENT 'Class\` id',
  name VARCHAR(45) NOT NULL COMMENT 'Class\` name',
  description MEDIUMTEXT NULL DEFAULT NULL COMMENT 'Class\` description',
  PRIMARY KEY (id))
ENGINE = InnoDB
COMMENT = 'Table that stores CLASSES\` information';


-- -----------------------------------------------------
-- Table challenges
-- -----------------------------------------------------
DROP TABLE IF EXISTS challenges ;

CREATE TABLE IF NOT EXISTS challenges (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(45) NOT NULL,
  description MEDIUMTEXT NOT NULL,
  points INT NULL DEFAULT NULL,
  PRIMARY KEY (id))
ENGINE = InnoDB
COMMENT = 'Table that stores CHALLENGES\` information';


-- -----------------------------------------------------
-- Table normal_challenges
-- -----------------------------------------------------
DROP TABLE IF EXISTS normal_challenges ;

CREATE TABLE IF NOT EXISTS normal_challenges (
  classes_id INT NOT NULL COMMENT 'Class\` code',
  challenges_id INT NOT NULL COMMENT 'Challenge\` code',
  is_active TINYINT(1) NOT NULL COMMENT 'Status of the Challenge\n0 Inactive\n1 Active',
  PRIMARY KEY (classes_id, challenges_id),
  INDEX fk_class_has_challenges_idx (challenges_id ASC),
  INDEX fk_challenge_is_in_class_idx (classes_id ASC))
ENGINE = InnoDB
COMMENT = 'Table that stores the CHALLENGES that a CLASS had.';


-- -----------------------------------------------------
-- Table levels
-- -----------------------------------------------------
DROP TABLE IF EXISTS levels ;

CREATE TABLE IF NOT EXISTS levels (
  id INT NOT NULL AUTO_INCREMENT COMMENT 'Code of the Level',
  level VARCHAR(45) NOT NULL COMMENT 'Name for the Level',
  description MEDIUMTEXT NULL DEFAULT NULL COMMENT 'Description of what that level means',
  PRIMARY KEY (id))
ENGINE = InnoDB
COMMENT = 'Table that stores LEVELS description for the diferents skills.';


-- -----------------------------------------------------
-- Table events
-- -----------------------------------------------------
DROP TABLE IF EXISTS events ;

CREATE TABLE IF NOT EXISTS events (
  id INT NOT NULL COMMENT 'Code of the Event',
  name VARCHAR(45) NULL COMMENT 'Name of the Event',
  abbrev VARCHAR(45) NULL COMMENT 'Abbreviation of the Event  ',
  PRIMARY KEY (id))
ENGINE = InnoDB
COMMENT = 'Table that stores the EVENTS in wich a skill is executed, if they are active and the respective abreviation.';


-- -----------------------------------------------------
-- Table skills
-- -----------------------------------------------------
DROP TABLE IF EXISTS skills ;

CREATE TABLE IF NOT EXISTS skills (
  id INT NOT NULL AUTO_INCREMENT COMMENT 'Code of the Skill',
  name VARCHAR(45) NOT NULL COMMENT 'Name of the skill',
  description MEDIUMTEXT NULL COMMENT 'Description of the Skill\n',
  category VARCHAR(45) NOT NULL COMMENT 'category to which the event belongs',
  certificate TINYINT(1) GENERATED ALWAYS AS (0)  COMMENT 'Boolean value to know the status',
  events_id INT NOT NULL COMMENT 'Code of the Event',
  PRIMARY KEY (id),
  INDEX fk_skills_events_idx (events_id ASC))
ENGINE = InnoDB
COMMENT = 'Table that stores SKILLS that a GYMNAST can get.';


-- -----------------------------------------------------
-- Table gymnast_has_skills
-- -----------------------------------------------------
DROP TABLE IF EXISTS gymnast_has_skills ;

CREATE TABLE IF NOT EXISTS gymnast_has_skills (
  gymnast_id INT NOT NULL COMMENT 'Gymnast\` code',
  skills_Id INT NOT NULL COMMENT 'Skill\` code',
  progress_status VARCHAR(45) NULL COMMENT 'Tells the gymnast actual status in learning the skill',
  coach_verify JSON NULL COMMENT 'Verification from a coach when an gymnast set the level for a skill',
  timestamp DATE NOT NULL,
  interactions JSON NULL COMMENT 'Interactions for the skill update by others gymnasts\nHi 5\nComments\nApplasuse\nIn JSON Format',
  PRIMARY KEY (gymnast_id, skills_Id),
  INDEX fk_gymnast_has_skills_idx (skills_Id ASC),
  INDEX fk_skills_is_mastered_by_gymnast_idx (gymnast_id ASC))
ENGINE = InnoDB
COMMENT = 'Table that stores SKILLS that a GYMNAST get.';


-- -----------------------------------------------------
-- Table skill_has_levels
-- -----------------------------------------------------
DROP TABLE IF EXISTS skill_has_levels ;

CREATE TABLE IF NOT EXISTS skill_has_levels (
  levels_id INT NOT NULL COMMENT 'Code of the Level',
  skills_id INT NOT NULL COMMENT 'Code of the Skill',
  secuence TINYINT(1) GENERATED ALWAYS AS (0)  COMMENT 'The Skill has a secuence?\n0 No\n1 Yes',
  PRIMARY KEY (levels_id, skills_id),
  INDEX fk_level_is_part_of_skill_idx (skills_id ASC),
  INDEX fk_skill_has_level_idx (levels_id ASC))
ENGINE = InnoDB
COMMENT = 'Table that stores LEVELS that a certain skill had.\nLogic Name: Skill Levels';


-- -----------------------------------------------------
-- Table gymnasts_classes
-- -----------------------------------------------------
DROP TABLE IF EXISTS gymnasts_classes ;

CREATE TABLE IF NOT EXISTS gymnasts_classes (
  gymnasts_id INT NOT NULL COMMENT 'Foreing key from GYMNASTS table',
  classes_id INT NOT NULL COMMENT 'Foreing key from CLASSES table',
  PRIMARY KEY (gymnasts_id, classes_id),
  INDEX fk_gymnast_has_classes_idx (classes_id ASC),
  INDEX fk_class_has_gymnasts_idx (gymnasts_id ASC))
ENGINE = InnoDB
COMMENT = 'Table that stores the CLASSES in what a GYMNAST is enrolled.';


-- -----------------------------------------------------
-- Table daily_challenges
-- -----------------------------------------------------
DROP TABLE IF EXISTS daily_challenges ;

CREATE TABLE IF NOT EXISTS daily_challenges (
  classes_id INT NOT NULL COMMENT 'Class\` code',
  challenges_id INT NOT NULL COMMENT 'Challenge\` code',
  date DATE NOT NULL COMMENT 'Date in wich the challenge has to be completed.',
  PRIMARY KEY (classes_id, challenges_id, date),
  INDEX fk_class_has_daily_challenges_idx (challenges_id ASC),
  INDEX fk_challenge_has_classes_idx (classes_id ASC))
ENGINE = InnoDB
COMMENT = 'Table that stores the daily challenges that a class had.';


-- -----------------------------------------------------
-- Table completed_normal_challenges
-- -----------------------------------------------------
DROP TABLE IF EXISTS completed_normal_challenges ;

CREATE TABLE IF NOT EXISTS completed_normal_challenges (
  gymnasts_id INT NOT NULL COMMENT 'gymnast’ code',
  normal_challenges_classes_id INT NOT NULL COMMENT 'Foreing key from NORMAL CHALLENGES table',
  normal_challenges_challenges_id INT NOT NULL COMMENT 'Foreing key from NORMAL CHALLENGES table',
  date_of_completation DATE NOT NULL COMMENT 'Date in wich the challenge was completed',
  Interactions JSON NULL COMMENT 'Interactions for the completed challenged by others gymnasts\nHi 5\nComments\nApplasuse\nIn JSON Format',
  PRIMARY KEY (gymnasts_id, normal_challenges_classes_id, normal_challenges_challenges_id),
  INDEX fk_gymnasts_has_normal_challenges_normal_challenges1_idx (normal_challenges_classes_id ASC, normal_challenges_challenges_id ASC),
  INDEX fk_gymnasts_has_normal_challenges_gymnasts1_idx (gymnasts_id ASC))
ENGINE = InnoDB
COMMENT = 'Table that stores the NORMAL_CHALLENGES that a GYMNAST has completed.';


-- -----------------------------------------------------
-- Table completed_daily_challenges
-- -----------------------------------------------------
DROP TABLE IF EXISTS completed_daily_challenges ;

CREATE TABLE IF NOT EXISTS completed_daily_challenges (
  gymnasts_id INT NOT NULL COMMENT 'gymnast’ code',
  daily_challenges_classes_id INT NOT NULL COMMENT 'Foreing key from DAILY CHALLENGES table',
  daily_challenges_challenges_id INT NOT NULL COMMENT 'Foreing key from DAILY CHALLENGES table',
  daily_challenges_date DATE NOT NULL COMMENT 'Foreing key from DAILY CHALLENGES table',
  date_of_completation DATE NOT NULL COMMENT 'Date in wich the challenge was completed',
  Interactions VARCHAR(45) NULL COMMENT 'Interactions for the completed challenged by others gymnasts\nHi 5\nComments\nApplasuse\nIn JSON Format',
  PRIMARY KEY (gymnasts_id, daily_challenges_classes_id, daily_challenges_challenges_id, daily_challenges_date),
  INDEX fk_gymnasts_has_daily_challenges_daily_challenges1_idx (daily_challenges_classes_id ASC, daily_challenges_challenges_id ASC, daily_challenges_date ASC),
  INDEX fk_gymnasts_has_daily_challenges_gymnasts1_idx (gymnasts_id ASC))
ENGINE = InnoDB
COMMENT = 'Table that stores the DAILY_CHALLENGES that a GYMNAST has completed.';


-- -----------------------------------------------------
-- Table plans
-- -----------------------------------------------------
DROP TABLE IF EXISTS plans ;

CREATE TABLE IF NOT EXISTS plans (
  id INT NOT NULL COMMENT 'PLAN\` Code',
  name VARCHAR(45) NOT NULL COMMENT 'PLAN\` name',
  price FLOAT NULL COMMENT 'PLAN\` Price',
  cycle VARCHAR(45) NULL COMMENT 'Days that the plan covers. ',
  PRIMARY KEY (id))
ENGINE = InnoDB
COMMENT = 'Table that stores PLANS and promotions';


-- -----------------------------------------------------
-- Table payment_procesors
-- -----------------------------------------------------
DROP TABLE IF EXISTS payment_procesors ;

CREATE TABLE IF NOT EXISTS payment_procesors (
  id INT NOT NULL COMMENT 'PAYMENT PROCESOR\` Code',
  slug VARCHAR(45) NULL COMMENT 'Identification or name of the PAYMENT PROCESOR',
  PRIMARY KEY (id))
ENGINE = InnoDB
COMMENT = 'Table that stores PAYMENT PROCESORS information';


-- -----------------------------------------------------
-- Table subscriptions
-- -----------------------------------------------------
DROP TABLE IF EXISTS subscriptions ;

CREATE TABLE IF NOT EXISTS subscriptions (
  users_id INT NOT NULL COMMENT 'USER\` Code\n',
  payment_procesors_id INT NOT NULL COMMENT 'PAYMENT PROCESOR\`  Code',
  plans_id INT NOT NULL COMMENT 'PLAN\` code',
  suscriptions_status INT NULL COMMENT '0.inactive 1. Active 2. Suspended',
  start_at DATE NULL COMMENT 'Starting dperiod for the suscription',
  end_at DATE NULL COMMENT 'Ending period for the suscription',
  created_at VARCHAR(45) NULL,
  updated_at VARCHAR(45) NULL,
  deleted_at VARCHAR(45) NULL,
  PRIMARY KEY (users_id, plans_id),
  INDEX fk_subscriptions_has_payment_procesors1_idx (payment_procesors_id ASC),
  INDEX fk_subscriptions_has_users1_idx (users_id ASC),
  INDEX fk_subscriptions_has_plans1_idx (plans_id ASC))
ENGINE = InnoDB
COMMENT = 'Table that stores USERS subscriptions to the differents plans.';


-- -----------------------------------------------------
-- Table payments
-- -----------------------------------------------------
DROP TABLE IF EXISTS payments ;

CREATE TABLE IF NOT EXISTS payments (
  id INT NOT NULL COMMENT 'PAYMENT\` Code',
  subscriptions_users_id INT NOT NULL,
  subscriptions_plans_id INT NOT NULL,
  attemted_at DATE NULL COMMENT 'Payment get proceced at (DATE)',
  amount FLOAT NULL,
  fee FLOAT NULL,
  created_at DATETIME NULL,
  period_start DATETIME NULL COMMENT 'The start of the period that is covered by the payment.',
  period_end DATETIME NULL COMMENT 'The end of the period that is covered by the payment.',
  PRIMARY KEY (id),
  INDEX fk_payments_subscriptions1_idx (subscriptions_users_id ASC, subscriptions_plans_id ASC))
ENGINE = InnoDB
COMMENT = 'Table that stores PAYMENTS made for an specific subscription';


-- -----------------------------------------------------
-- ALTER TABLES FOR FK
-- -----------------------------------------------------

ALTER TABLE users
ADD CONSTRAINT fk_users_rol1
    FOREIGN KEY (rol_id)
    REFERENCES rol (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

ALTER TABLE gyms_has_users 
ADD CONSTRAINT fk_gyms_has_users_gyms1
    FOREIGN KEY (gyms_id)
    REFERENCES gyms (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
ADD CONSTRAINT fk_gyms_has_users_users1
    FOREIGN KEY (users_id)
    REFERENCES users (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

ALTER TABLE gymnasts
ADD CONSTRAINT fk_gymnasts_gyms_has_users1
    FOREIGN KEY (gyms_has_users_gyms_id , gyms_has_users_users_id)
    REFERENCES gyms_has_users (gyms_id , users_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

ALTER TABLE normal_challenges
ADD CONSTRAINT fk_class_has_challenges
    FOREIGN KEY (classes_id)
    REFERENCES classes (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
ADD CONSTRAINT fk_challenge_is_in_class_
    FOREIGN KEY (challenges_id)
    REFERENCES challenges (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

ALTER TABLE skills
ADD CONSTRAINT fk_skills_events
    FOREIGN KEY (events_id)
    REFERENCES events (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

ALTER TABLE gymnast_has_skills
ADD CONSTRAINT fk_gymnast_has_skills
    FOREIGN KEY (gymnast_id)
    REFERENCES gymnasts (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
ADD CONSTRAINT fk_skills_is_mastered_by_gymnast
    FOREIGN KEY (skills_Id)
    REFERENCES skills (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

ALTER TABLE skill_has_levels
ADD CONSTRAINT fk_level_is_part_of_skill
    FOREIGN KEY (levels_id)
    REFERENCES levels (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
ADD CONSTRAINT fk_SKI_has_LVE
    FOREIGN KEY (skills_id)
    REFERENCES skills (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

ALTER TABLE gymnasts_classes
ADD CONSTRAINT fk_gymnast_has_classes
    FOREIGN KEY (gymnasts_id)
    REFERENCES gymnasts (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
ADD CONSTRAINT fk_class_has_gymnasts
    FOREIGN KEY (classes_id)
    REFERENCES classes (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

ALTER TABLE daily_challenges
ADD CONSTRAINT fk_class_has_daily_challenges
    FOREIGN KEY (classes_id)
    REFERENCES classes (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
ADD CONSTRAINT fk_challenge_has_classes_idx
    FOREIGN KEY (challenges_id)
    REFERENCES challenges (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

ALTER TABLE completed_normal_challenges
ADD CONSTRAINT fk_gymnast_has_normal_challenges
    FOREIGN KEY (gymnasts_id)
    REFERENCES gymnasts (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
ADD CONSTRAINT fk_normal_challenge_is_completed_by_gymnast
    FOREIGN KEY (normal_challenges_classes_id , normal_challenges_challenges_id)
    REFERENCES normal_challenges (classes_id , challenges_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

ALTER TABLE completed_daily_challenges
ADD CONSTRAINT fk_gymnast_has_daily_challenges
    FOREIGN KEY (gymnasts_id)
    REFERENCES gymnasts (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
ADD CONSTRAINT fk_daily_challenge_is_completed_by_gymnast
    FOREIGN KEY (daily_challenges_classes_id , daily_challenges_challenges_id , daily_challenges_date)
    REFERENCES daily_challenges (classes_id , challenges_id , date)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

ALTER TABLE subscriptions
ADD CONSTRAINT fk_subscriptions_has_users1
    FOREIGN KEY (users_id)
    REFERENCES users (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
ADD CONSTRAINT fk_subscriptions_has_payment_procesors1
    FOREIGN KEY (payment_procesors_id)
    REFERENCES payment_procesors (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
ADD CONSTRAINT fk_subscriptions_has_plans1
    FOREIGN KEY (plans_id)
    REFERENCES plans (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

ALTER TABLE payments
ADD CONSTRAINT fk_payments_subscriptions1
    FOREIGN KEY (subscriptions_users_id , subscriptions_plans_id)
    REFERENCES subscriptions (users_id , plans_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
