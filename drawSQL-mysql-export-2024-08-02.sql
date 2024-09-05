CREATE TABLE `Ethnicity Person Match`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `ethnicity_id` INT NOT NULL,
    `person_id` INT NOT NULL
);
CREATE TABLE `Cases`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `person_id` INT NOT NULL,
    `namus_number` INT NOT NULL,
    `ncmec_number` INT NOT NULL,
    `adress_id` INT NOT NULL,
    `create_date_time` VARCHAR(255) NOT NULL,
    `last_modified_date_time` VARCHAR(255) NOT NULL,
    `case_type_id` INT NOT NULL
);
CREATE TABLE `Countries`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL,
    `name_abreviation` VARCHAR(2) NOT NULL
);
CREATE TABLE `Sex`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL
);
CREATE TABLE `Person instances`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL,
    `middle name` VARCHAR(255) NOT NULL,
    `surrname` VARCHAR(255) NOT NULL,
    `year_of_birth` INT NOT NULL,
    `month_of_birth` INT NOT NULL,
    `day_of_birth` INT NULL,
    `min_weight_kg` INT NOT NULL,
    `max_weight_kg` INT NOT NULL,
    `min_height_m` INT NOT NULL,
    `max_height_m` INT NOT NULL,
    `primary_ethnicity_id` INT NOT NULL,
    `sex_id` INT NOT NULL,
    `min_missing_age` INT NOT NULL,
    `max_missing_age` INT NOT NULL
);
CREATE TABLE `Counties`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL
);
CREATE TABLE `Addresses`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `country_id` INT NOT NULL,
    `state_id` INT NOT NULL,
    `county_id` INT NOT NULL,
    `zip_code` INT NOT NULL,
    `city_id` INT NOT NULL
);
CREATE TABLE `Agencies`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `agency_name` VARCHAR(255) NOT NULL,
    `agency_contact` VARCHAR(255) NOT NULL
);
CREATE TABLE `Images`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `person_id` INT NOT NULL,
    `image_url` TEXT NOT NULL,
    `case_id` INT NOT NULL
);
CREATE TABLE `Organizations`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `org_name` TEXT NOT NULL,
    `org_abbreviation` VARCHAR(255) NOT NULL,
    `org_contact` VARCHAR(255) NOT NULL
);
CREATE TABLE `States`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL,
    `name_abbreviation` VARCHAR(2) NOT NULL
);
CREATE TABLE `Organization Case Match`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `org_id` INT NOT NULL,
    `case_id` INT NOT NULL
);
CREATE TABLE `Agency Case Match`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `agency_id` INT NOT NULL,
    `case_id` INT NOT NULL
);
CREATE TABLE `Cities`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL
);
CREATE TABLE `Ethnicity`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL
);
ALTER TABLE
    `Agency Case Match` ADD CONSTRAINT `agency case match_agency_id_foreign` FOREIGN KEY(`agency_id`) REFERENCES `Agencies`(`id`);
ALTER TABLE
    `Addresses` ADD CONSTRAINT `addresses_city_id_foreign` FOREIGN KEY(`city_id`) REFERENCES `Cities`(`id`);
ALTER TABLE
    `Images` ADD CONSTRAINT `images_person_id_foreign` FOREIGN KEY(`person_id`) REFERENCES `Person instances`(`id`);
ALTER TABLE
    `Organization Case Match` ADD CONSTRAINT `organization case match_org_id_foreign` FOREIGN KEY(`org_id`) REFERENCES `Organizations`(`id`);
ALTER TABLE
    `Person instances` ADD CONSTRAINT `person instances_sex_id_foreign` FOREIGN KEY(`sex_id`) REFERENCES `Sex`(`id`);
ALTER TABLE
    `Images` ADD CONSTRAINT `images_case_id_foreign` FOREIGN KEY(`case_id`) REFERENCES `Cases`(`id`);
ALTER TABLE
    `Addresses` ADD CONSTRAINT `addresses_country_id_foreign` FOREIGN KEY(`country_id`) REFERENCES `Countries`(`id`);
ALTER TABLE
    `Cases` ADD CONSTRAINT `cases_person_id_foreign` FOREIGN KEY(`person_id`) REFERENCES `Person instances`(`id`);
ALTER TABLE
    `Ethnicity Person Match` ADD CONSTRAINT `ethnicity person match_ethnicity_id_foreign` FOREIGN KEY(`ethnicity_id`) REFERENCES `Ethnicity`(`id`);
ALTER TABLE
    `Ethnicity Person Match` ADD CONSTRAINT `ethnicity person match_person_id_foreign` FOREIGN KEY(`person_id`) REFERENCES `Person instances`(`id`);
ALTER TABLE
    `Addresses` ADD CONSTRAINT `addresses_state_id_foreign` FOREIGN KEY(`state_id`) REFERENCES `States`(`id`);
ALTER TABLE
    `Cases` ADD CONSTRAINT `cases_adress_id_foreign` FOREIGN KEY(`adress_id`) REFERENCES `Addresses`(`id`);
ALTER TABLE
    `Agency Case Match` ADD CONSTRAINT `agency case match_case_id_foreign` FOREIGN KEY(`case_id`) REFERENCES `Cases`(`id`);
ALTER TABLE
    `Person instances` ADD CONSTRAINT `person instances_primary_ethnicity_id_foreign` FOREIGN KEY(`primary_ethnicity_id`) REFERENCES `Ethnicity`(`id`);
ALTER TABLE
    `Addresses` ADD CONSTRAINT `addresses_county_id_foreign` FOREIGN KEY(`county_id`) REFERENCES `Counties`(`id`);
ALTER TABLE
    `Organization Case Match` ADD CONSTRAINT `organization case match_case_id_foreign` FOREIGN KEY(`case_id`) REFERENCES `Cases`(`id`);