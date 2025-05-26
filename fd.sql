CREATE DATABASE multi_bank_fd_rates;
USE multi_bank_fd_rates;
CREATE TABLE banks (
    bank_id INT PRIMARY KEY AUTO_INCREMENT,
    bank_name VARCHAR(100) NOT NULL UNIQUE,
    website VARCHAR(255)
);
CREATE TABLE fd_rates (
    rate_id INT PRIMARY KEY AUTO_INCREMENT,
    bank_id INT NOT NULL,
    tenure_range VARCHAR(50) NOT NULL, -- e.g., "7 days - 45 days"
    tenure_min_days INT, -- Minimum tenure in days
    tenure_max_days INT, -- Maximum tenure in days
    regular_rate DECIMAL(5, 2) NOT NULL, -- Regular customer rate
    senior_citizen_rate DECIMAL(5, 2) NOT NULL, -- Senior citizen rate
    min_deposit DECIMAL(15, 2) DEFAULT 10000.00, -- Minimum deposit amount
    max_deposit DECIMAL(15, 2), -- Maximum deposit amount (NULL for no limit)
    compounding VARCHAR(20) DEFAULT 'Quarterly', -- Compounding frequency
    effective_date DATE, -- Effective date of rates
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (bank_id) REFERENCES banks(bank_id),
    UNIQUE (bank_id, tenure_range, effective_date) -- Prevent duplicate rates for same tenure and date
);
CREATE TABLE fd_summary (
    summary_id INT PRIMARY KEY AUTO_INCREMENT,
    bank_id INT NOT NULL,
    interest_rate_min DECIMAL(5, 2) NOT NULL, -- Min interest rate
    interest_rate_max DECIMAL(5, 2) NOT NULL, -- Max interest rate
    tenure_min_days INT NOT NULL, -- Min time period in days
    tenure_max_days INT NOT NULL, -- Max time period in days
    min_deposit DECIMAL(15, 2) DEFAULT 10000.00, -- Minimum deposit amount
    max_deposit DECIMAL(15, 2), -- Maximum deposit amount (NULL for no limit)
    compounding VARCHAR(20) DEFAULT 'Quarterly', -- Compounding frequency
    effective_date DATE, -- Effective date of summary
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (bank_id) REFERENCES banks(bank_id),
    UNIQUE (bank_id, effective_date) -- Prevent duplicate summaries for same date
);
-- Indexes for performance
CREATE INDEX idx_tenure ON fd_rates (tenure_min_days, tenure_max_days);
CREATE INDEX idx_bank_id ON fd_rates (bank_id);
CREATE INDEX idx_summary_bank_id ON fd_summary (bank_id);
INSERT INTO banks (bank_name, website)
VALUES ('State Bank of India', 'https://www.sbi.co.in');
INSERT INTO fd_rates (bank_id, tenure_range, tenure_min_days, tenure_max_days, regular_rate, senior_citizen_rate, min_deposit, max_deposit, compounding, effective_date)
VALUES
    (1, '7 days - 45 days', 7, 45, 3.50, 4.00, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (1, '46 days - 179 days', 46, 179, 5.50, 6.00, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (1, '180 days - 210 days', 180, 210, 6.25, 6.75, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (1, '211 days - 364 days', 211, 364, 6.50, 7.00, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (1, '1 year - 1 year 364 days', 365, 729, 6.80, 7.30, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (1, '2 years - 2 years 364 days', 730, 1094, 7.00, 7.50, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (1, '3 years - 4 years 364 days', 1095, 1824, 6.75, 7.25, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (1, '5 years - 10 years', 1825, 3650, 6.50, 7.50, 10000.00, NULL, 'Quarterly', '2025-04-16');
INSERT INTO fd_summary (bank_id, interest_rate_min, interest_rate_max, tenure_min_days, tenure_max_days, min_deposit, max_deposit, compounding, effective_date)
VALUES (1, 5.50, 6.50, 90, 3650, 10000.00, NULL, 'Quarterly', '2025-04-16');

INSERT INTO banks (bank_name, website)
VALUES ('Punjab National Bank', 'https://www.pnbindia.in/fixeddeposit.html');

INSERT INTO fd_rates (
    bank_id, tenure_range, tenure_min_days, tenure_max_days,
    regular_rate, senior_citizen_rate, min_deposit, max_deposit,
    compounding, effective_date
) VALUES
    (2, '7 days - 14 days', 7, 14, 3.50, 4.00, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (2, '15 days - 29 days', 15, 29, 3.50, 4.00, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (2, '30 days - 45 days', 30, 45, 3.50, 4.00, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (2, '46 days - 90 days', 46, 90, 4.50, 5.00, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (2, '91 days - 179 days', 91, 179, 5.50, 6.00, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (2, '180 days - 270 days', 180, 270, 6.25, 6.75, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (2, '271 days - 299 days', 271, 299, 6.50, 7.00, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (2, '1 year', 365, 365, 6.80, 7.30, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (2, '1 year 1 day - 399 days', 366, 399, 6.80, 7.30, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (2, '400 days', 400, 400, 7.25, 7.75, 10000.00, NULL, 'Quarterly', '2025-04-16');
INSERT INTO fd_summary (
    bank_id, interest_rate_min, interest_rate_max, tenure_min_days, tenure_max_days,
    min_deposit, max_deposit, compounding, effective_date
) VALUES (
    2, 4.50, 6.50, 90, 3650, 1000.00, NULL, 'Quarterly', '2025-04-16'
);

INSERT INTO banks (bank_name, website)
VALUES ('Bank of Baroda', 'https://www.bankofbaroda.in/interest-rate-and-service-charges/deposits-interest-rates');

INSERT INTO fd_rates (
    bank_id, tenure_range, tenure_min_days, tenure_max_days,
    regular_rate, senior_citizen_rate, min_deposit, max_deposit,
    compounding, effective_date
) VALUES
    (3, '7 days - 14 days', 7, 14, 4.25, 4.75, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (3, '15 days - 45 days', 15, 45, 4.50, 5.00, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (3, '46 days - 90 days', 46, 90, 5.50, 6.00, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (3, '91 days - 180 days', 91, 180, 5.60, 6.10, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (3, '181 days - 210 days', 181, 210, 5.75, 6.25, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (3, '211 days - 270 days', 211, 270, 6.25, 6.75, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (3, '271 days - less than 1 year', 271, 364, 6.50, 7.00, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (3, '1 year', 365, 365, 6.85, 7.35, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (3, '1 year 1 day - 400 days', 366, 400, 7.00, 7.50, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (3, 'Above 400 days - 2 years', 401, 730, 7.00, 7.50, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (3, '2 years 1 day - 3 years', 731, 1095, 7.15, 7.65, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (3, '3 years 1 day - 5 years', 1096, 1825, 6.80, 7.40, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (3, '5 years 1 day - 10 years', 1826, 3650, 6.50, 7.50, 10000.00, NULL, 'Quarterly', '2025-04-16');
    
INSERT INTO fd_summary (
    bank_id, interest_rate_min, interest_rate_max, tenure_min_days, tenure_max_days,
    min_deposit, max_deposit, compounding, effective_date
) VALUES (
    3, 4.25, 7.15, 7, 3650, 10000.00, NULL, 'Quarterly', '2025-04-16'
);

INSERT INTO banks (bank_name, website)
VALUES ('Canara Bank', 'https://canarabank.com/pages/deposit-interest-rates');

INSERT INTO fd_rates (
    bank_id, tenure_range, tenure_min_days, tenure_max_days,
    regular_rate, senior_citizen_rate, min_deposit, max_deposit,
    compounding, effective_date
) VALUES
    (5, '7 days - 45 days', 7, 45, 4.00, 4.00, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (5, '46 days - 90 days', 46, 90, 5.25, 5.25, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (5, '91 days - 179 days', 91, 179, 5.50, 5.50, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (5, '180 days - 269 days', 180, 269, 6.15, 6.65, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (5, '270 days - less than 1 year', 270, 364, 6.25, 6.75, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (5, '1 year - less than 2 years', 365, 729, 6.85, 7.35, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (5, '2 years 1 day - less than 3 years', 731, 1094, 7.30, 7.80, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (5, '3 years - 5 years', 1095, 1825, 7.40, 7.90, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (5, '5 years - 10 years', 1825, 3650, 6.70, 7.20, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (5, '444 days', 444, 444, 7.25, 7.75, 10000.00, NULL, 'Quarterly', '2025-04-16');

INSERT INTO fd_summary (
    bank_id, interest_rate_min, interest_rate_max, tenure_min_days, tenure_max_days,
    min_deposit, max_deposit, compounding, effective_date
) VALUES (
    5, 5.50, 6.70, 90, 3650, 1000.00, NULL, 'Quarterly', '2025-04-16'
);

INSERT INTO banks (bank_name, website)
VALUES ('Union Bank', 'https://www.unionbankofindia.co.in/en/details/rate-of-interest');

INSERT INTO fd_rates (
    bank_id, tenure_range, tenure_min_days, tenure_max_days,
    regular_rate, senior_citizen_rate, min_deposit, max_deposit,
    compounding, effective_date
) VALUES
    (7, '7 days - 14 days', 7, 14, 3.50, 4.00, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (7, '15 days - 30 days', 15, 30, 3.50, 4.00, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (7, '31 days - 45 days', 31, 45, 3.50, 4.00, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (7, '46 days - 90 days', 46, 90, 4.50, 5.00, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (7, '91 days - 120 days', 91, 120, 4.80, 5.30, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (7, '121 days - 180 days', 121, 180, 5.00, 5.50, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (7, '181 days - 332 days', 181, 332, 6.35, 6.85, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (7, '1 year', 365, 365, 6.80, 7.30, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (7, '1 year 1 day - 398 days', 366, 398, 6.80, 7.30, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (7, '2 years 1 day - 996 days', 731, 996, 6.60, 7.10, 10000.00, NULL, 'Quarterly', '2025-04-16');
    
INSERT INTO fd_summary (
    bank_id, interest_rate_min, interest_rate_max, tenure_min_days, tenure_max_days,
    min_deposit, max_deposit, compounding, effective_date
) VALUES (
    7, 3.50, 6.50, 90, 3650, 1000.00, NULL, 'Quarterly', '2025-04-16'
);

INSERT INTO banks (bank_name, website)
VALUES ('Bank of India', 'https://bankofindia.co.in/interest-rate/rupee-term-deposit-rate');

INSERT INTO fd_rates (
    bank_id, tenure_range, tenure_min_days, tenure_max_days,
    regular_rate, senior_citizen_rate, min_deposit, max_deposit,
    compounding, effective_date
) VALUES
    (8, '7 days - 14 days', 7, 14, 3.00, 3.50, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (8, '15 days - 30 days', 15, 30, 3.00, 3.50, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (8, '31 days - 45 days', 31, 45, 3.00, 3.50, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (8, '46 days - 90 days', 46, 90, 4.50, 5.00, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (8, '91 days - 179 days', 91, 179, 4.50, 5.00, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (8, '180 days - 269 days', 180, 269, 6.00, 6.50, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (8, '270 days - less than 1 year', 270, 364, 6.00, 6.50, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (8, '1 year - less than 2 years', 365, 729, 6.80, 7.30, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (8, '2 years', 730, 730, 6.80, 7.30, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (8, 'Above 2 years - less than 3 years', 731, 1094, 6.75, 7.25, 10000.00, NULL, 'Quarterly', '2025-04-16');
    
INSERT INTO fd_summary (
    bank_id, interest_rate_min, interest_rate_max, tenure_min_days, tenure_max_days,
    min_deposit, max_deposit, compounding, effective_date
) VALUES (
    8, 4.50, 6.00, 90, 3650, 10000.00, NULL, 'Quarterly', '2025-04-16'
);

INSERT INTO banks (bank_name, website)
VALUES ('Indian Bank', 'https://www.indianbank.in/departments/deposit-rates/');

INSERT INTO fd_rates (
    bank_id, tenure_range, tenure_min_days, tenure_max_days,
    regular_rate, senior_citizen_rate, min_deposit, max_deposit,
    compounding, effective_date
) VALUES
    (9, '7 days - 14 days', 7, 14, 2.80, 3.30, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (9, '15 days - 29 days', 15, 29, 2.80, 3.30, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (9, '30 days - 45 days', 30, 45, 3.00, 3.50, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (9, '46 days - 90 days', 46, 90, 3.25, 3.75, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (9, '91 days - 180 days', 91, 180, 3.50, 4.00, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (9, '121 days - 180 days', 121, 180, 3.85, 4.35, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (9, '181 days - less than 9 months', 181, 269, 4.50, 5.00, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (9, '9 months - 364 days', 270, 364, 4.75, 5.25, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (9, '1 year', 365, 365, 6.10, 6.60, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (9, '1 year 1 day - 1 year 364 days', 366, 729, 7.10, 7.60, 10000.00, NULL, 'Quarterly', '2025-04-16');

INSERT INTO fd_summary (
    bank_id, interest_rate_min, interest_rate_max, tenure_min_days, tenure_max_days,
    min_deposit, max_deposit, compounding, effective_date
) VALUES (
    9, 2.80, 7.10, 7, 729, 10000.00, NULL, 'Quarterly', '2025-04-16'
);

INSERT INTO banks (bank_name, website)
VALUES ('Central Bank of India', 'https://www.centralbankofindia.co.in/en/interest-rates-on-deposit');

INSERT INTO fd_rates (
    bank_id, tenure_range, tenure_min_days, tenure_max_days,
    regular_rate, senior_citizen_rate, min_deposit, max_deposit,
    compounding, effective_date
) VALUES
    (10, '7 days - 14 days', 7, 14, 3.50, 4.00, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (10, '15 days - 30 days', 15, 30, 3.75, 4.25, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (10, '31 days - 45 days', 31, 45, 3.75, 4.25, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (10, '46 days - 59 days', 46, 59, 4.50, 5.00, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (10, '60 days - 90 days', 60, 90, 4.75, 5.25, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (10, '91 days - 179 days', 91, 179, 5.00, 5.50, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (10, '180 days - 270 days', 180, 270, 6.00, 6.50, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (10, '271 days - 364 days', 271, 364, 6.25, 6.75, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (10, '1 year - less than 2 years', 365, 729, 6.75, 7.25, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (10, '2 years - less than 3 years', 730, 1094, 7.00, 7.50, 10000.00, NULL, 'Quarterly', '2025-04-16');
    
INSERT INTO fd_summary (
    bank_id, interest_rate_min, interest_rate_max, tenure_min_days, tenure_max_days,
    min_deposit, max_deposit, compounding, effective_date
) VALUES (
    10, 4.75, 6.25, 90, 3650, 5000.00, NULL, 'Quarterly', '2025-04-16'
);

INSERT INTO banks (bank_name, website)
VALUES ('Indian Overseas Bank', 'https://www.iob.in/Domestic_Rates');

INSERT INTO fd_rates (
    bank_id, tenure_range, tenure_min_days, tenure_max_days,
    regular_rate, senior_citizen_rate, min_deposit, max_deposit,
    compounding, effective_date
) VALUES
    (11, '7 days - 14 days', 7, 14, 4.00, 4.50, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (11, '15 days - 29 days', 15, 29, 4.50, 5.00, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (11, '30 days - 45 days', 30, 45, 4.50, 5.00, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (11, '46 days - 60 days', 46, 60, 4.50, 5.00, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (11, '61 days - 90 days', 61, 90, 4.25, 4.75, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (11, '91 days - 120 days', 91, 120, 4.75, 5.25, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (11, '121 days - 179 days', 121, 179, 4.25, 4.75, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (11, '180 days - 269 days', 180, 269, 5.75, 6.25, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (11, '270 days - less than 1 year', 270, 364, 5.75, 6.25, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (11, '1 year - less than 2 years (except 444 days)', 365, 729, 7.10, 7.60, 10000.00, NULL, 'Quarterly', '2025-04-16');
    
INSERT INTO fd_summary (
    bank_id, interest_rate_min, interest_rate_max, tenure_min_days, tenure_max_days,
    min_deposit, max_deposit, compounding, effective_date
) VALUES (
    11, 4.50, 6.50, 90, 3650, 100000.00, NULL, 'Quarterly', '2025-04-16'
);

INSERT INTO banks (bank_name, website)
VALUES ('Uco Bank', 'https://www.ucobank.com/interest-rates-on-deposit-schemes');

INSERT INTO fd_rates (
    bank_id, tenure_range, tenure_min_days, tenure_max_days,
    regular_rate, senior_citizen_rate, min_deposit, max_deposit,
    compounding, effective_date
) VALUES
    (12, '7 days - 29 days', 7, 29, 2.90, 3.15, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (12, '30 days - 45 days', 30, 45, 3.00, 3.25, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (12, '46 days - 60 days', 46, 60, 3.50, 4.00, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (12, '61 days - 90 days', 61, 90, 3.50, 4.00, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (12, '91 days - 150 days', 91, 150, 4.50, 4.75, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (12, '151 days - 180 days', 151, 180, 5.00, 5.25, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (12, '1 year - 399 days', 365, 399, 6.50, 7.00, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (12, '400 days', 400, 400, 7.05, 7.55, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (12, '401 days - 2 years', 401, 730, 6.50, 7.00, 10000.00, NULL, 'Quarterly', '2025-04-16'),
    (12, '2 years 1 day - 3 years', 731, 1095, 6.30, 6.80, 10000.00, NULL, 'Quarterly', '2025-04-16');

INSERT INTO fd_summary (
    bank_id, interest_rate_min, interest_rate_max, tenure_min_days, tenure_max_days,
    min_deposit, max_deposit, compounding, effective_date
) VALUES (
    12, 4.50, 6.10, 90, 3650, 1000.00, NULL, 'Quarterly', '2025-04-16'
)





