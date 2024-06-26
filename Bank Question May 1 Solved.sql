CREATE TABLE bank_transactions (
    transaction_id SERIAL PRIMARY KEY,
    bank_id INT,
    customer_id INT,
    transaction_amount DECIMAL(10, 2),
    transaction_type VARCHAR(10),
    transaction_date DATE
);


INSERT INTO bank_transactions (bank_id, customer_id, transaction_amount, transaction_type, transaction_date) VALUES
(1, 101, 500.00, 'credit', '2024-01-01'),
(1, 101, 200.00, 'debit', '2024-01-02'),
(1, 101, 300.00, 'credit', '2024-01-05'),
(1, 101, 150.00, 'debit', '2024-01-08'),
(1, 102, 1000.00, 'credit', '2024-01-01'),
(1, 102, 400.00, 'debit', '2024-01-03'),
(1, 102, 600.00, 'credit', '2024-01-05'),
(1, 102, 200.00, 'debit', '2024-01-09');


SELECT * FROM BANK_TRANSACTIONS


-- Write a query to find starting and ending trans amount for each customer

--Return cx_id, their first_transaction_amt, 
--last_transaction and these transaction_date

--Customer id
--First Transaction Amount
--Second Transaction Amount
--Transaction Date

WITH CTE1 AS
(SELECT *,
ROW_NUMBER()OVER (PARTITION BY CUSTOMER_ID ORDER BY TRANSACTION_DATE)AS RN
FROM BANK_TRANSACTIONS),
CTE2 AS --FIRST TRANSACTION DETAILS
(
SELECT CUSTOMER_ID,TRANSACTION_AMOUNT,TRANSACTION_DATE 
FROM CTE1
WHERE RN = (SELECT MIN(RN) FROM CTE1)
),
CTE3 AS -- LAST TRANSACTION DETAILS
(SELECT CUSTOMER_ID,TRANSACTION_AMOUNT,TRANSACTION_DATE 
FROM CTE1 
WHERE RN = (SELECT MAX(RN) FROM CTE1)
)
SELECT CTE2.CUSTOMER_ID,
       CTE2.TRANSACTION_AMOUNT AS FIRST_TRANS_AMOUNT,
	   CTE2.TRANSACTION_DATE AS FIRST_TRANS_DATE,
	   CTE3.TRANSACTION_AMOUNT AS LAST_TRANS_AMOUNT,
	   CTE3.TRANSACTION_DATE AS LAST_TRANS_DATE
FROM CTE2 JOIN CTE3 
ON CTE2.CUSTOMER_ID=CTE3.CUSTOMER_ID


-- Your task 
-- Write a query to return each cx_id and their bank balance
-- Note bank balance = Total Credit - Total_debit


-- CUSTOMER_ID
-- CREDIT
-- DEBIT
-- BANK BALANCE

WITH CTE1 AS
(SELECT CUSTOMER_ID,
	    TRANSACTION_AMOUNT
FROM BANK_TRANSACTIONS
WHERE TRANSACTION_TYPE='credit'
),
CTE2 AS
(SELECT CUSTOMER_ID,
	    TRANSACTION_AMOUNT
FROM BANK_TRANSACTIONS
WHERE TRANSACTION_TYPE='debit'
)
SELECT CTE1.CUSTOMER_ID,
       CTE1.TRANSACTION_AMOUNT AS CREDIT_AMOUNT,
       CTE2.TRANSACTION_AMOUNT AS DEBIT_AMOUNT,
       CTE1.TRANSACTION_AMOUNT - CTE2.TRANSACTION_AMOUNT AS TRANSACTION_DIFFERENCE
FROM CTE1
JOIN CTE2 ON CTE1.CUSTOMER_ID = CTE2.CUSTOMER_ID;



