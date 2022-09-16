DROP DATABASE IF EXISTS new_companies; 
CREATE DATABASE new_companies;
USE new_companies;

CREATE TABLE company(
	company_code VARCHAR(5),
    founder VARCHAR(10),
    PRIMARY KEY (company_code)
);

CREATE TABLE lead_manager(
    lead_manager_code VARCHAR(5),
	company_code VARCHAR(5),
    PRIMARY KEY (lead_manager_code)
);

CREATE TABLE senior_manager(
    senior_manager_code VARCHAR(5),
    lead_manager_code VARCHAR(5),
	company_code VARCHAR(5),
    PRIMARY KEY (senior_manager_code)
);

CREATE TABLE manager(
    manager_code VARCHAR(5),
    senior_manager_code VARCHAR(5),
    lead_manager_code VARCHAR(5),
	company_code VARCHAR(5),
    PRIMARY KEY (manager_code)
);

CREATE TABLE employee(
    employee_code VARCHAR(5),
    manager_code VARCHAR(5),
    senior_manager_code VARCHAR(5),
    lead_manager_code VARCHAR(5),
	company_code VARCHAR(5),
    PRIMARY KEY (employee_code)
);



ALTER TABLE lead_manager
ADD FOREIGN KEY (company_code) REFERENCES company(company_code);

ALTER TABLE senior_manager
ADD FOREIGN KEY (lead_manager_code) REFERENCES lead_manager(lead_manager_code),
ADD FOREIGN KEY (company_code) REFERENCES company(company_code);

ALTER TABLE manager
ADD FOREIGN KEY (senior_manager_code) REFERENCES senior_manager(senior_manager_code),
ADD FOREIGN KEY (lead_manager_code) REFERENCES lead_manager(lead_manager_code),
ADD FOREIGN KEY (company_code) REFERENCES company(company_code);

ALTER TABLE employee
ADD FOREIGN KEY (manager_code) REFERENCES manager(manager_code),
ADD FOREIGN KEY (senior_manager_code) REFERENCES senior_manager(senior_manager_code),
ADD FOREIGN KEY (lead_manager_code) REFERENCES lead_manager(lead_manager_code),
ADD FOREIGN KEY (company_code) REFERENCES company(company_code);




INSERT INTO company 
VALUES ('C_1', 'Monika'), ('C_2', 'Samantha');

INSERT INTO lead_manager
VALUES ('LM_1', 'C_1'), ('LM_2', 'C_2');


INSERT INTO senior_manager
VALUES ('SM_1', 'LM_1', 'C_1'), ('SM_2', 'LM_2', 'C_1'), ('SM_3', 'LM_3', 'C_2');


INSERT INTO manager
VALUES ('M_1', 'SM_1', 'LM_1', 'C_1'),  ('M_2', 'SM_3', 'LM_2', 'C_2'), 
('M_3', 'SM_3', 'LM_2', 'C_2');


INSERT INTO employee
VALUES ('E_1', 'M_1', 'SM_1', 'LM_1', 'C_1'), ('E_2', 'M_1', 'SM_1', 'LM_1', 'C_1'),
('E_3', 'M_2', 'SM_3', 'LM_2', 'C_2'), ('E_4', 'M_3', 'SM_3', 'LM_2', 'C_2');




