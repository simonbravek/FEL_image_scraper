CREATE DATABASE IF NOT EXISTS scraper;

USE scraper;

CREATE TABLE IF NOT EXISTS `ethnicity_abstract_description_match`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `ethnicity_id` INT NOT NULL,
    `abstract_description_id` INT NOT NULL
);
CREATE TABLE IF NOT EXISTS `cases`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `case_owning_agency_id` INT NULL,
    `namus_number` INT NULL,
    `ncmec_number` INT NULL,
    `case_type_id` INT NULL,
    `person_instance_id` INT NULL,
    `publication_status_id` INT NULL,
    `case_is_resolved` BOOLEAN NULL,
    `adress_id` INT NULL,
    `create_date_time` DATETIME NULL,
    `last_modified_date_time` DATETIME NULL,
    `fetch_date` DATETIME NOT NULL
);
CREATE TABLE IF NOT EXISTS `countries`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL,
    `name_abreviation` VARCHAR(2) NOT NULL
);
CREATE TABLE IF NOT EXISTS `physical_descriptions`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `min_weight_kg` INT NULL,
    `max_weight_kg` INT NULL,
    `min_height_m` FLOAT(53) NULL,
    `max_height_m` FLOAT(53) NULL,
    `word_describtion_id` VARCHAR(255) NULL,
    `hair_color_id` INT NULL,
    `right_eye_color_id` INT NULL,
    `left_eye_color_id` INT NULL,
    `beard_color_id` INT NULL,
    `body_shape_id` INT NULL,
    `hair_cut_id` INT NULL,
    `beard_cut_id` INT NULL
);
CREATE TABLE IF NOT EXISTS `abstract_description`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `primary_ethnicity_id` INT NULL,
    `nationality_id` INT NULL,
    `sex_id` INT NULL
);
CREATE TABLE IF NOT EXISTS `personal_names`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `first_name` VARCHAR(255) NULL,
    `middle_name` VARCHAR(255) NULL,
    `surname` VARCHAR(255) NULL
);
CREATE TABLE IF NOT EXISTS `mime_types`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL
);
CREATE TABLE IF NOT EXISTS `sex`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL
);
CREATE TABLE IF NOT EXISTS `hair_beard_cuts`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL
);
CREATE TABLE IF NOT EXISTS `person_instances`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `age_id` INT NULL,
    `physical_describtion_id` INT NULL,
    `name_id` INT NULL,
    `abstract_descripton` INT NULL
);
CREATE TABLE IF NOT EXISTS `counties`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL
);
CREATE TABLE IF NOT EXISTS `addresses`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `country_id` INT NULL,
    `state_id` INT NULL,
    `county_id` INT NULL,
    `zip_code` INT NULL,
    `city_id` INT NULL,
    `case_id` INT NULL,
    `formatted_address` INT NULL
);
CREATE TABLE IF NOT EXISTS `body_shapes`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL
);
CREATE TABLE IF NOT EXISTS `case_types`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL
);
CREATE TABLE IF NOT EXISTS `nationalities`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL
);
CREATE TABLE IF NOT EXISTS `agencies`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `agency_name` VARCHAR(255) NOT NULL
);
CREATE TABLE IF NOT EXISTS `images`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `person_instance_id` INT NOT NULL,
    `image_url` TEXT NOT NULL,
    `is_default` BOOLEAN NULL,
    `caption` VARCHAR(255) NULL,
    `create_date_time` DATETIME NULL,
    `mime_type_id` INT NULL,
    `height_px` INT NULL,
    `width_px` INT NULL
);
CREATE TABLE IF NOT EXISTS `organizations`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `org_name` TEXT NULL,
    `org_abbreviation` VARCHAR(255) NULL
);
CREATE TABLE IF NOT EXISTS `states`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL,
    `name_abbreviation` VARCHAR(2) NOT NULL
);
CREATE TABLE IF NOT EXISTS `organization_case_match`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `org_id` INT NOT NULL,
    `case_id` INT NOT NULL
);
CREATE TABLE IF NOT EXISTS `personal_ages`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `date_of_birth` DATETIME NULL,
    `min_missing_age` INT NULL,
    `max_missing_age` INT NULL,
    `min_current_age` INT NULL,
    `max_current_age` INT NULL
);
CREATE TABLE IF NOT EXISTS `agency_case_match`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `agency_id` INT NOT NULL,
    `case_id` INT NOT NULL
);
CREATE TABLE IF NOT EXISTS `publication_status`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` INT NOT NULL
);
CREATE TABLE IF NOT EXISTS `hair_colors`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL
);
CREATE TABLE IF NOT EXISTS `cities`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL
);
CREATE TABLE IF NOT EXISTS `ethnicity`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL
);
ALTER TABLE
    `agency_case_match` ADD CONSTRAINT `agency_case_match_agency_id_foreign` FOREIGN KEY(`agency_id`) REFERENCES `agencies`(`id`);
ALTER TABLE
    `addresses` ADD CONSTRAINT `addresses_city_id_foreign` FOREIGN KEY(`city_id`) REFERENCES `cities`(`id`);
ALTER TABLE
    `images` ADD CONSTRAINT `images_person_instance_id_foreign` FOREIGN KEY(`person_instance_id`) REFERENCES `person_instances`(`id`);
ALTER TABLE
    `organization_case_match` ADD CONSTRAINT `organization_case_match_org_id_foreign` FOREIGN KEY(`org_id`) REFERENCES `organizations`(`id`);
ALTER TABLE
    `person_instances` ADD CONSTRAINT `person_instances_physical_describtion_id_foreign` FOREIGN KEY(`physical_describtion_id`) REFERENCES `physical_descriptions`(`id`);
ALTER TABLE
    `addresses` ADD CONSTRAINT `addresses_country_id_foreign` FOREIGN KEY(`country_id`) REFERENCES `countries`(`id`);
ALTER TABLE
    `physical_descriptions` ADD CONSTRAINT `physical_descriptions_hair_cut_id_foreign` FOREIGN KEY(`hair_cut_id`) REFERENCES `hair_beard_cuts`(`id`);
ALTER TABLE
    `images` ADD CONSTRAINT `images_mime_type_id_foreign` FOREIGN KEY(`mime_type_id`) REFERENCES `mime_types`(`id`);
ALTER TABLE
    `abstract_description` ADD CONSTRAINT `abstract_description_nationality_id_foreign` FOREIGN KEY(`nationality_id`) REFERENCES `nationalities`(`id`);
ALTER TABLE
    `ethnicity_abstract_description_match` ADD CONSTRAINT `ethnicity_abstract_description_match_ethnicity_id_foreign` FOREIGN KEY(`ethnicity_id`) REFERENCES `ethnicity`(`id`);
ALTER TABLE
    `ethnicity_abstract_description_match` ADD CONSTRAINT `ethnicity_abstract_description_match_abstract_description_id_foreign` FOREIGN KEY(`abstract_description_id`) REFERENCES `abstract_description`(`id`);
ALTER TABLE
    `cases` ADD CONSTRAINT `cases_person_instance_id_foreign` FOREIGN KEY(`person_instance_id`) REFERENCES `person_instances`(`id`);
ALTER TABLE
    `physical_descriptions` ADD CONSTRAINT `physical_descriptions_left_eye_color_id_foreign` FOREIGN KEY(`left_eye_color_id`) REFERENCES `hair_colors`(`id`);
ALTER TABLE
    `person_instances` ADD CONSTRAINT `person_instances_age_id_foreign` FOREIGN KEY(`age_id`) REFERENCES `personal_ages`(`id`);
ALTER TABLE
    `cases` ADD CONSTRAINT `cases_case_type_id_foreign` FOREIGN KEY(`case_type_id`) REFERENCES `case_types`(`id`);
ALTER TABLE
    `cases` ADD CONSTRAINT `cases_publication_status_id_foreign` FOREIGN KEY(`publication_status_id`) REFERENCES `publication_status`(`id`);
ALTER TABLE
    `abstract_description` ADD CONSTRAINT `abstract_description_sex_id_foreign` FOREIGN KEY(`sex_id`) REFERENCES `sex`(`id`);
ALTER TABLE
    `person_instances` ADD CONSTRAINT `person_instances_abstract_descripton_foreign` FOREIGN KEY(`abstract_descripton`) REFERENCES `abstract_description`(`id`);
ALTER TABLE
    `addresses` ADD CONSTRAINT `addresses_state_id_foreign` FOREIGN KEY(`state_id`) REFERENCES `states`(`id`);
ALTER TABLE
    `cases` ADD CONSTRAINT `cases_adress_id_foreign` FOREIGN KEY(`adress_id`) REFERENCES `addresses`(`id`);
ALTER TABLE
    `physical_descriptions` ADD CONSTRAINT `physical_descriptions_beard_color_id_foreign` FOREIGN KEY(`beard_color_id`) REFERENCES `hair_colors`(`id`);
ALTER TABLE
    `agency_case_match` ADD CONSTRAINT `agency_case_match_case_id_foreign` FOREIGN KEY(`case_id`) REFERENCES `cases`(`id`);
ALTER TABLE
    `physical_descriptions` ADD CONSTRAINT `physical_descriptions_body_shape_id_foreign` FOREIGN KEY(`body_shape_id`) REFERENCES `body_shapes`(`id`);
ALTER TABLE
    `physical_descriptions` ADD CONSTRAINT `physical_descriptions_beard_cut_id_foreign` FOREIGN KEY(`beard_cut_id`) REFERENCES `hair_beard_cuts`(`name`);
ALTER TABLE
    `physical_descriptions` ADD CONSTRAINT `physical_descriptions_right_eye_color_id_foreign` FOREIGN KEY(`right_eye_color_id`) REFERENCES `hair_colors`(`id`);
ALTER TABLE
    `abstract_description` ADD CONSTRAINT `abstract_description_primary_ethnicity_id_foreign` FOREIGN KEY(`primary_ethnicity_id`) REFERENCES `ethnicity`(`id`);
ALTER TABLE
    `person_instances` ADD CONSTRAINT `person_instances_name_id_foreign` FOREIGN KEY(`name_id`) REFERENCES `personal_names`(`id`);
ALTER TABLE
    `addresses` ADD CONSTRAINT `addresses_county_id_foreign` FOREIGN KEY(`county_id`) REFERENCES `counties`(`id`);
ALTER TABLE
    `cases` ADD CONSTRAINT `cases_case_owning_agency_id_foreign` FOREIGN KEY(`case_owning_agency_id`) REFERENCES `agencies`(`id`);
ALTER TABLE
    `organization_case_match` ADD CONSTRAINT `organization_case_match_case_id_foreign` FOREIGN KEY(`case_id`) REFERENCES `cases`(`id`);