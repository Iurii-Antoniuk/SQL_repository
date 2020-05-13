BEGIN TRANSACTION
UPDATE CurrentAccounts
SET  amount = ( CASE
                  WHEN ((amount - {amount}) >= overdraft) THEN amount - {amount}
				  ELSE overdraft
			  END )
WHERE id = {currentAccountID};

INSERT INTO \"Transaction\" (currentAccount_id, transactionType, amount, \"date\")
VALUES ({currentAccountID}, 'withdrawal', {amount}, {dateOp})
COMMIT TRANSACTION;

SELECT * FROM "Transaction";
SELECT * FROM Person;
SELECT * FROM SavingAccounts;
SELECT * FROM CurrentAccounts;
SELECT amount FROM CurrentAccounts WHERE id=100;

INSERT INTO Person 
VALUES ('Buba', '?gB??\v???U?g?6#????E??x??F?');

INSERT INTO CurrentAccounts (client_id, amount, overdraft, openingDate) 
VALUES
(4, 100, -100, '2020-04-01 04:15:00'),
(5, 1000, -200, '2020-02-01 02:15:00'),
(6, 400, -100, '2020-04-01 02:15:00');


INSERT INTO \"Transaction\" (currentAccount_id, transactionType, amount, \"date\")
VALUES ({currentAccountID}, 'withdrawal', {amount}, {dateOp})

$"UPDATE CurrentAccounts SET amount = (amount - {amount}) WHERE id = { currentAccountID }; 
INSERT INTO \"Transaction\" (currentAccount_id, transactionType, amount, \"date\") VALUES({ currentAccountID}, 'withdrawal', { amount}, { dateOp})";


UPDATE Person
SET password = '?gB??\v???U?g?6#????E??x??F?';