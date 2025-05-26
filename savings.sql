use bank;
DELETE FROM SavingsInterestRates;
INSERT INTO SavingsInterestRates (bank_name, min_amount, max_amount, interest_rate) 
VALUES 
('State Bank of India', 1, 1000000000, 2.70),
('State Bank of India', 1000000001, 100000000000, 3.00),

('Punjab National Bank', 1, 10000000, 2.70),
('Punjab National Bank', 10000001, 1000000000, 2.75),
('Punjab National Bank', 1000000001, 100000000000, 3.00),

('Bank of Baroda', 1, 5000000000, 2.75),
('Bank of Baroda', 5000000001, 20000000000, 3.00),
('Bank of Baroda', 20000000001, 50000000000, 3.05),
('Bank of Baroda', 50000000001, 100000000000, 4.10),
('Bank of Baroda', 100000000001, 1000000000000, 4.50),

('Canara Bank', 1, 500000000, 2.90),
('Canara Bank', 500000001, 1000000000, 2.95),
('Canara Bank', 1000000001, 10000000000, 3.05),
('Canara Bank', 10000000001, 20000000000, 3.50),
('Canara Bank', 20000000001, 50000000000, 3.10),
('Canara Bank', 50000000001, 100000000000, 3.40),
('Canara Bank', 100000000001, 200000000000, 3.55),
('Canara Bank', 200000000001, 1000000000000, 4.00),

('Union Bank', 1, 5000000, 2.75),
('Union Bank', 5000001, 1000000000, 2.90),
('Union Bank', 1000000001, 50000000000, 3.10),
('Union Bank', 50000000001, 100000000000, 3.40),
('Union Bank', 100000000001, 1000000000000, 3.55),

('Bank of India', 1, 100000, 2.75),
('Bank of India', 100001, 50000000000, 2.90),
('Bank of India', 50000000001, 100000000000, 3.00),
('Bank of India', 100000000001, 150000000000, 3.05),
('Bank of India', 150000000001, 1000000000000, 3.10),

('Indian Bank', 1, 10000000, 2.75),
('Indian Bank', 50000001, 20000000000, 2.80),
('Indian Bank', 20000000001, 1000000000000, 2.90),

('Central Bank of India', 1, 1000000000, 2.80),
('Central Bank of India', 1000000001, 10000000000, 3.00),
('Central Bank of India', 10000000001, 25000000000, 3.10),
('Central Bank of India', 25000000001, 50000000000, 3.25),
('Central Bank of India', 50000000001, 100000000000, 3.75),

('Indian Overseas Bank', 1, 10000000, 2.75),
('Indian Overseas Bank', 10000001, 1000000000000, 2.90),

('UCO Bank', 1, 10000000, 2.60),
('UCO Bank', 10000001, 1000000000000, 2.75),

('Bank of Maharashtra', 1, 2500000, 3.50),
('Bank of Maharashtra', 2500001, 1000000000000, 4.00),

('Punjab and Sind Bank', 1, 100000000, 2.70),
('Punjab and Sind Bank', 100000001, 5000000000, 2.90),
('Punjab and Sind Bank', 5000000001, 10000000000, 4.52),
('Punjab and Sind Bank', 10000000001, 50000000000, 4.55),
('Punjab and Sind Bank', 50000000001, 1000000000000, 5.00);
INSERT INTO SavingsInterestRates (bank_name, min_amount, max_amount, interest_rate) 
VALUES 
('HDFC Bank', 1, 5000000, 3.00),
('HDFC Bank', 5000001, 500000000, 3.50),

('ICICI Bank', 1, 5000000, 3.00),
('ICICI Bank', 5000001, 500000000, 3.50),

('Indusind Bank', 1, 100000, 3.00),
('Indusind Bank', 100001, 500000, 4.00),
('Indusind Bank', 500001, 1000000, 6.00),
('Indusind Bank', 1000001, 50000000, 7.00),
('Indusind Bank', 50000001, 100000000000, 7.00),

('IDFC First Bank', 1, 500000, 3.00),
('IDFC First Bank', 500001, 1000000000, 7.25),
('IDFC First Bank', 1000000001, 2000000000, 4.50),
('IDFC First Bank', 2000000001, 100000000000, 3.50),

('Jammu and Kashmir Bank', 1, 100000000000, 2.90),

('Karnataka Bank', 1, 5000000, 2.75),
('Karnataka Bank', 5000001, 10000000, 3.50),
('Karnataka Bank', 10000001, 100000000000, 4.00),

('Karur Vysya Bank', 1, 500000, 2.25),
('Karur Vysya Bank', 500001, 1000000, 2.50),
('Karur Vysya Bank', 1000001, 100000000, 3.00),
('Karur Vysya Bank', 100000001, 1000000000, 3.25),

('Kotak Mahindra Bank', 1, 500000, 3.00),
('Kotak Mahindra Bank', 500001, 5000000, 3.50),
('Kotak Mahindra Bank', 5000001, 100000000000, 4.00),

('IDBI Bank', 1, 100000, 2.75),
('IDBI Bank', 100001, 500000, 2.90),
('IDBI Bank', 500001, 50000000, 3.00),
('IDBI Bank', 50000001, 1000000000, 3.25),
('IDBI Bank', 1000000001, 10000000000, 3.50),

('Yes Bank', 1, 100000, 3.00),
('Yes Bank', 100001, 500000, 4.00),
('Yes Bank', 500001, 1000000, 5.00),
('Yes Bank', 1000001, 1000000000, 7.00);
INSERT INTO SavingsInterestRates (bank_name, min_amount, max_amount, interest_rate) 
VALUES 
('Axis Bank', 1, 5000000, 3.00),
('Axis Bank', 5000001, 20000000000, 3.50),

('Bandan Bank', 1, 100000, 3.00),
('Bandan Bank', 100001, 1000000, 6.00),
('Bandan Bank', 1000001, 20000000, 7.00),
('Bandan Bank', 20000001, 100000000, 6.25),
('Bandan Bank', 100000001, 500000000, 6.50),
('Bandan Bank', 500000001, 1000000000, 8.00),

('CSB Bank', 1, 100000, 2.10),
('CSB Bank', 100001, 2500000, 2.50),
('CSB Bank', 2500001, 5000000, 3.00),
('CSB Bank', 5000001, 50000000, 4.00),
('CSB Bank', 50000001, 250000000, 5.00),
('CSB Bank', 250000001, 500000000, 5.50),
('CSB Bank', 500000001, 1100000000, 6.00),
('CSB Bank', 1100000001, 2000000000, 7.75),

('City Union Bank', 1, 500000, 2.75),
('City Union Bank', 500001, 1000000, 3.00),
('City Union Bank', 1000001, 2500000, 3.50),
('City Union Bank', 2500001, 500000000, 4.00),
('City Union Bank', 500000001, 100000000000, 5.00),

('DCB Bank', 1, 100000, 1.75),
('DCB Bank', 100001, 500000, 2.65),
('DCB Bank', 500001, 1000000, 4.75),
('DCB Bank', 1000001, 5000000, 6.75),
('DCB Bank', 5000001, 10000000, 7.50),
('DCB Bank', 10000001, 20000000, 7.75),
('DCB Bank', 20000001, 30000000, 8.00),
('DCB Bank', 30000001, 250000000, 7.25),
('DCB Bank', 250000001, 500000000, 7.50),
('DCB Bank', 500000001, 3000000000, 8.00),
('DCB Bank', 3000000001, 100000000000, 5.50),

('Dhanlaxmi Bank', 1, 100000, 2.50),
('Dhanlaxmi Bank', 100001, 500000, 2.75),
('Dhanlaxmi Bank', 500001, 5000000, 3.25),
('Dhanlaxmi Bank', 5000001, 100000000000, 4.00),

('Federal Bank', 1, 5000000, 3.00),
('Federal Bank', 5000001, 20000000, 3.75),
('Federal Bank', 20000001, 50000000, 4.00),
('Federal Bank', 50000001, 400000000, 5.50),
('Federal Bank', 400000001, 1500000000, 7.00),
('Federal Bank', 1500000001, 3000000000, 5.75),
('Federal Bank', 3000000001, 100000000000, 3.00);



