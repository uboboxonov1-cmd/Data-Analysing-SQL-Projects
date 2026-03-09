create database projects


-- 1️ Customers
CREATE TABLE Customers1 (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    DOB DATE,
    Email VARCHAR(100) UNIQUE,
    PhoneNumber VARCHAR(20) UNIQUE,
    Address VARCHAR(255),
    NationalID VARCHAR(50),
    TaxID VARCHAR(50),
    EmploymentStatus VARCHAR(50),
    AnnualIncome DECIMAL(18,2),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE()
);
--  Customers (2,000 row)
----------------------------
DECLARE @i INT = 1;
WHILE @i <= 2000
BEGIN
    INSERT INTO Customers1 (FullName, DOB, Email, PhoneNumber, Address, NationalID, TaxID, EmploymentStatus, AnnualIncome)
    VALUES (
    'Customer ' + CAST(@i AS VARCHAR(10)),
      DATEADD(DAY, -((@i * 10) % 10000), GETDATE()),
     'customer' + CAST(@i AS VARCHAR(10)) + '@mail.com',
      '9989' + RIGHT('000000' + CAST(@i AS VARCHAR(6)),6),
      'Address ' + CAST(@i AS VARCHAR(10)),
      'NID' + CAST(@i AS VARCHAR(10)),
      'TID' + CAST(@i AS VARCHAR(10)),
        CASE WHEN @i % 3 = 0 THEN 'Employed'
         WHEN @i % 3 = 1 THEN 'Self-Employed'
         ELSE 'Unemployed' END,
        ROUND(RAND()*10000+1000,2)
    );
    SET @i = @i + 1;
END
select * from Customers1 
--  Accounts
CREATE TABLE Accounts (
    AccountID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    AccountType VARCHAR(50),
    Balance DECIMAL(18,2) DEFAULT 0,
    Currency VARCHAR(10),
    Status VARCHAR(20),
    BranchID INT,
    CreatedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CustomerID) REFERENCES Customers1 (CustomerID),
    FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
);
--  Accounts (2,500 row)
----------------------------
DECLARE @a INT = 1;
WHILE @a <= 2500
BEGIN
    INSERT INTO Accounts (CustomerID, AccountType, Balance, Currency, Status, BranchID)
    VALUES (
    ((@a % 2000) + 1),
    CASE WHEN @a % 3 = 0 THEN 'Savings'
    WHEN @a % 3 = 1 THEN 'Checking'
    ELSE 'Business' END,
        ROUND(RAND()*10000,2),
        CASE WHEN @a % 2 = 0 THEN 'USD' ELSE 'UZS' END,
        CASE WHEN @a % 2 = 0 THEN 'Active' ELSE 'Inactive' END,
        ((@a % 10) + 1)
    );
    SET @a = @a + 1;
END
--  Transactions
CREATE TABLE Transactions (
    TransactionID INT IDENTITY(1,1) PRIMARY KEY,
    AccountID INT NOT NULL,
    TransactionType VARCHAR(50),
    Amount DECIMAL(18,2),
    Currency VARCHAR(10),
    Date DATETIME DEFAULT GETDATE(),
    Status VARCHAR(20),
    ReferenceNo VARCHAR(50),
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);
--  Transactions (5,000 row)
----------------------------
DECLARE @t INT = 1;
WHILE @t <= 5000
BEGIN
    INSERT INTO Transactions (AccountID, TransactionType, Amount, Currency, Date, Status, ReferenceNo)
    VALUES (
 ((@t % 2500) + 1),
  CASE WHEN @t % 4 = 0 THEN 'Deposit'
    WHEN @t % 4 = 1 THEN 'Withdrawal'
    WHEN @t % 4 = 2 THEN 'Transfer'
    ELSE 'Payment' END,
        ROUND(RAND()*5000,2),
        CASE WHEN @t % 2 = 0 THEN 'USD' ELSE 'UZS' END,
        DATEADD(DAY, -(@t % 365), GETDATE()),
        CASE WHEN @t % 2 = 0 THEN 'Completed' ELSE 'Pending' END,
        'REF' + RIGHT('00000' + CAST(@t AS VARCHAR(5)),5)
    );
    SET @t = @t + 1;
END


--CREATE TABLE Branches (
--    BranchID INT IDENTITY(1,1) PRIMARY KEY,
--    BranchName VARCHAR(100),
--    Address VARCHAR(255),
--    City VARCHAR(50),
--    State VARCHAR(50),
--    Country VARCHAR(50),
--    ContactNumber VARCHAR(20)
--);
--CREATE TABLE Employees (
--    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
--    BranchID INT,
--    FullName VARCHAR(100),
--    Position VARCHAR(50),
--    Department VARCHAR(50),
--    Salary DECIMAL(18,2),
--    HireDate DATE,
--    Status VARCHAR(20),
--    FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
--);
--ALTER TABLE Branches
--ADD ManagerID INT;

--ALTER TABLE Branches
--ADD CONSTRAINT FK_Branches_Manager
--FOREIGN KEY (ManagerID) REFERENCES Employees(EmployeeID);

--  Branches
CREATE TABLE Branches (
    BranchID INT IDENTITY(1,1) PRIMARY KEY,
    BranchName VARCHAR(100),
    Address VARCHAR(255),
    City VARCHAR(50),
    State VARCHAR(50),
    Country VARCHAR(50),
    ManagerID INT,
    ContactNumber VARCHAR(20),
    FOREIGN KEY (ManagerID) REFERENCES Employees(EmployeeID)
);
--  Branches (10 row)
----------------------------
DECLARE @b INT = 1;
WHILE @b <= 10
BEGIN
    INSERT INTO Branches (BranchName, Address, City, State, Country)
    VALUES (
    'Branch ' + CAST(@b AS VARCHAR(10)),
    'Branch Address ' + CAST(@b AS VARCHAR(10)),
    'City ' + CAST(@b AS VARCHAR(10)),
    'State ' + CAST(@b AS VARCHAR(10)),
    'Country'
    );
    SET @b = @b + 1;
   END;



-- 5 Employees
CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    BranchID INT,
    FullName VARCHAR(100),
    Position VARCHAR(50),
    Department VARCHAR(50),
    Salary DECIMAL(18,2),
    HireDate DATE,
    Status VARCHAR(20),
    FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
);

-
DECLARE @e INT = 1;
WHILE @e <= 50
BEGIN
    INSERT INTO Employees (BranchID, FullName, Position, Department, Salary, HireDate, Status)
    VALUES (
        ((@e % 10) + 1),
        'Employee ' + CAST(@e AS VARCHAR(10)),
        CASE WHEN @e % 3 = 0 THEN 'Manager' ELSE 'Staff' END,
        CASE WHEN @e % 2 = 0 THEN 'HR' ELSE 'Finance' END,
        ROUND(RAND()*3000+500,2),
        DATEADD(DAY, -(@e * 30), GETDATE()),
        'Active'
    );
    SET @e = @e + 1;
END
-- 6️ CreditCards
CREATE TABLE CreditCards (
    CardID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    CardNumber VARCHAR(20) UNIQUE,
    CardType VARCHAR(50),
    CVV VARCHAR(5),
    ExpiryDate DATE,
    Limit DECIMAL(18,2),
    Status VARCHAR(20),
    FOREIGN KEY (CustomerID) REFERENCES Customers1 (CustomerID)
);


DECLARE @i INT = 1;

WHILE @i <= 1000
BEGIN
    INSERT INTO CreditCards
    (
        CustomerID,
        CardNumber,
        CardType,
        CVV,
        ExpiryDate,
        [Limit],
        Status
    )
    VALUES
    (
        @i,  -- CustomerID
        CONCAT('4000', RIGHT('000000000000' + CAST(@i AS VARCHAR), 12)), -- UNIQUE card number
        CASE 
         WHEN @i % 3 = 0 THEN 'Platinum'
         WHEN @i % 2 = 0 THEN 'Gold'
           ELSE 'Classic'
        END,
        RIGHT('000' + CAST((100 + @i % 900) AS VARCHAR), 3),
        DATEADD(YEAR, 3 + (@i % 3), GETDATE()),
        CASE 
         WHEN @i % 3 = 0 THEN 15000
         WHEN @i % 2 = 0 THEN 10000
           ELSE 5000
        END,
        'Active'
    );

    SET @i = @i + 1;
END;





-- 7 CreditCardTransactions
CREATE TABLE CreditCardTransactions (
    TransactionID INT IDENTITY(1,1) PRIMARY KEY,
    CardID INT NOT NULL,
    Merchant VARCHAR(100),
    Amount DECIMAL(18,2),
    Currency VARCHAR(10),
    Date DATETIME DEFAULT GETDATE(),
    Status VARCHAR(20),
    FOREIGN KEY (CardID) REFERENCES CreditCards(CardID)
);

--  CreditCardTransactions (1,000 row)
----------------------------
DECLARE @cct INT = 1;
WHILE @cct <= 1000
BEGIN
    INSERT INTO CreditCardTransactions (CardID, Merchant, Amount, Currency, Date, Status)
    VALUES (
        ((@cct % 500) + 1),
        'Merchant ' + CAST((@cct % 50 + 1) AS VARCHAR(10)),
        ROUND(RAND()*1000,2),
        CASE WHEN @cct % 2 = 0 THEN 'USD' ELSE 'UZS' END,
        DATEADD(DAY, -(@cct % 365), GETDATE()),
        CASE WHEN @cct % 2 = 0 THEN 'Completed' ELSE 'Pending' END
    );
    SET @cct = @cct + 1;
END


--  OnlineBankingUsers
CREATE TABLE OnlineBankingUsers (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    Username VARCHAR(50) UNIQUE,
    PasswordHash VARCHAR(255),
    LastLogin DATETIME,
    FOREIGN KEY (CustomerID) REFERENCES Customers1(CustomerID)
);
-- 8 OnlineBankingUsers (1,500 row)
----------------------------
DECLARE @obu INT = 1;
WHILE @obu <= 1500
BEGIN
    INSERT INTO OnlineBankingUsers (CustomerID, Username, PasswordHash, LastLogin)
    VALUES (
        ((@obu % 2000) + 1),
        'user' + CAST(@obu AS VARCHAR(10)),
        HASHBYTES('SHA2_256','password'+CAST(@obu AS VARCHAR(10))),
        DATEADD(DAY, -(@obu % 30), GETDATE())
    );
    SET @obu = @obu + 1;
END
SELECT * FROM OnlineBankingUsers

-- 9 BillPayments
CREATE TABLE BillPayments (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    BillerName VARCHAR(100),
    Amount DECIMAL(18,2),
    Date DATETIME DEFAULT GETDATE(),
    Status VARCHAR(20),
    FOREIGN KEY (CustomerID) REFERENCES Customers1(CustomerID)
);
--  BillPayments (1,000 row)
----------------------------
DECLARE @bp INT = 1;
WHILE @bp <= 1000
BEGIN
    INSERT INTO BillPayments (CustomerID, BillerName, Amount, Date, Status)
    VALUES (
        ((@bp % 2000) + 1),
        'Biller ' + CAST((@bp % 50 + 1) AS VARCHAR(10)),
        ROUND(RAND()*500,2),
        DATEADD(DAY, -(@bp % 90), GETDATE()),
        CASE WHEN @bp % 2 = 0 THEN 'Paid' ELSE 'Pending' END
    );
    SET @bp = @bp + 1;
END

-- 10 MobileBankingTransactions
CREATE TABLE MobileBankingTransactions (
    TransactionID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    DeviceID VARCHAR(50),
    AppVersion VARCHAR(20),
    TransactionType VARCHAR(50),
    Amount DECIMAL(18,2),
    Date DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CustomerID) REFERENCES Customers1(CustomerID)
);
--  MobileBankingTransactions (1,200 row)
----------------------------
DECLARE @mbt INT = 1;
WHILE @mbt <= 1200
BEGIN
    INSERT INTO MobileBankingTransactions (CustomerID, DeviceID, AppVersion, TransactionType, Amount, Date)
    VALUES (
        ((@mbt % 2000) + 1),
        'Device' + CAST(@mbt AS VARCHAR(10)),
        'v' + CAST((@mbt % 10 + 1) AS VARCHAR(2)) + '.0',
        CASE WHEN @mbt % 3 = 0 THEN 'Deposit'
             WHEN @mbt % 3 = 1 THEN 'Withdrawal'
             ELSE 'Payment' END,
        ROUND(RAND()*2000,2),
        DATEADD(DAY, -(@mbt % 60), GETDATE())
    );
    SET @mbt = @mbt + 1;
END
-- 11 Loans
CREATE TABLE Loans (
    LoanID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    LoanType VARCHAR(50),
    Amount DECIMAL(18,2),
    InterestRate DECIMAL(5,2),
    StartDate DATE,
    EndDate DATE,
    Status VARCHAR(20),
    FOREIGN KEY (CustomerID) REFERENCES Customers1(CustomerID)
);
--  Loans (500 row)
----------------------------
DECLARE @l INT = 1;
WHILE @l <= 500
BEGIN
    INSERT INTO Loans (CustomerID, LoanType, Amount, InterestRate, StartDate, EndDate, Status)
    VALUES (
        ((@l % 2000) + 1),
        CASE WHEN @l % 4 = 0 THEN 'Mortgage'
             WHEN @l % 4 = 1 THEN 'Personal'
             WHEN @l % 4 = 2 THEN 'Auto'
             ELSE 'Business' END,
        ROUND(RAND()*20000+1000,2),
        ROUND(RAND()*10+5,2),
        DATEADD(DAY, -(@l * 30), GETDATE()),
        DATEADD(DAY, 365+(@l % 5)*30, GETDATE()),
        CASE WHEN @l % 2 = 0 THEN 'Active' ELSE 'Closed' END
    );
    SET @l = @l + 1;
END
-- 12️ LoanPayments
CREATE TABLE LoanPayments (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    LoanID INT NOT NULL,
    AmountPaid DECIMAL(18,2),
    PaymentDate DATE,
    RemainingBalance DECIMAL(18,2),
    FOREIGN KEY (LoanID) REFERENCES Loans(LoanID)
);
--  LoanPayments (800 row)
----------------------------
DECLARE @lp INT = 1;
WHILE @lp <= 800
BEGIN
    INSERT INTO LoanPayments (LoanID, AmountPaid, PaymentDate, RemainingBalance)
    VALUES (
        ((@lp % 500) + 1),
        ROUND(RAND()*2000,2),
        DATEADD(DAY, -(@lp % 365), GETDATE()),
        ROUND(RAND()*15000,2)
    );
    SET @lp = @lp + 1;
END

-- 13️ CreditScores
CREATE TABLE CreditScores (
    CustomerID INT PRIMARY KEY,
    CreditScore INT,
    UpdatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CustomerID) REFERENCES Customers1(CustomerID)
);
-- CreditScores (2,000 row)
----------------------------
DECLARE @cs INT = 1;
WHILE @cs <= 2000
BEGIN
    INSERT INTO CreditScores (CustomerID, CreditScore, UpdatedAt)
    VALUES (
        @cs,
        CAST(RAND()*300+550 AS INT),
        DATEADD(DAY, -(@cs % 365), GETDATE())
    );
    SET @cs = @cs + 1;
END


-- 14️ DebtCollection
CREATE TABLE DebtCollection (
    DebtID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    AmountDue DECIMAL(18,2),
    DueDate DATE,
    CollectorAssigned VARCHAR(100),
    FOREIGN KEY (CustomerID) REFERENCES Customers1(CustomerID)
);
--  DebtCollection (100 row)
----------------------------
DECLARE @dc INT = 1;
WHILE @dc <= 100
BEGIN
    INSERT INTO DebtCollection (CustomerID, AmountDue, DueDate, CollectorAssigned)
    VALUES (
        ((@dc % 2000) + 1),
        ROUND(RAND()*5000+500,2),
        DATEADD(DAY, 30 + (@dc % 60), GETDATE()),
        'Collector ' + CAST((@dc % 10 + 1) AS VARCHAR(5))
    );
    SET @dc = @dc + 1;
END

-- 15️ KYC
CREATE TABLE KYC (
    KYCID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    DocumentType VARCHAR(50),
    DocumentNumber VARCHAR(50),
    VerifiedBy VARCHAR(100),
    FOREIGN KEY (CustomerID) REFERENCES Customers1(CustomerID)
);
----------------------------
--  KYC (2,000 row)
----------------------------
DECLARE @kyc INT = 1;
WHILE @kyc <= 2000
BEGIN
    INSERT INTO KYC (CustomerID, DocumentType, DocumentNumber, VerifiedBy)
    VALUES (
        @kyc,
        CASE WHEN @kyc % 2 = 0 THEN 'Passport' ELSE 'ID Card' END,
        'DOC' + CAST(@kyc AS VARCHAR(10)),
        'Verifier ' + CAST((@kyc % 10 + 1) AS VARCHAR(5))
    );
    SET @kyc = @kyc + 1;
END

-- 16️ FraudDetection
CREATE TABLE FraudDetection (
    FraudID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    TransactionID INT,
    RiskLevel VARCHAR(20),
    ReportedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CustomerID) REFERENCES Customers1(CustomerID),
    FOREIGN KEY (TransactionID) REFERENCES Transactions(TransactionID)
);
--  FraudDetection (200 row)
----------------------------
DECLARE @fd INT = 1;
DECLARE @TransactionID INT;

WHILE @fd <= 200
BEGIN
SELECT TOP 1 @TransactionID = TransactionID
FROM Transactions
ORDER BY NEWID();  -- Random transaction

 INSERT INTO FraudDetection (CustomerID, TransactionID, RiskLevel, ReportedDate)
 VALUES (
 ((@fd % 2000) + 1),  -- CustomerID, Transactions bilan mos bo'lishi kerak
 @TransactionID,       -- EXISTING TransactionID
 CASE WHEN @fd % 3 = 0 THEN 'High'
 WHEN @fd % 3 = 1 THEN 'Medium'
 ELSE 'Low' END,
 DATEADD(DAY, -(@fd % 30), GETDATE())
    );
SET @fd = @fd + 1;
END;

----------------------------
-- AMLCases Table
----------------------------
CREATE TABLE AMLCases (
    CaseID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT,
    CaseType VARCHAR(50),
    Status VARCHAR(20),
    InvestigatorID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers1(CustomerID)
);



----------------------------
DECLARE @aml INT = 1;

WHILE @aml <= 100
BEGIN
    INSERT INTO AMLCases (CustomerID, CaseType, Status, InvestigatorID)
    VALUES (
        ((@aml % 2000) + 1),  -- CustomerID 1–2000
    CASE 
    WHEN @aml % 3 = 0 THEN 'Money Laundering'
    WHEN @aml % 3 = 1 THEN 'Fraud'
    ELSE 'Terrorist Financing'
    END,
    CASE 
     WHEN @aml % 2 = 0 THEN 'Open'
     ELSE 'Closed'
	 END,
     ((@aml % 50) + 51)  -- InvestigatorID 51–100
    );

    SET @aml = @aml + 1;
END;



SELECT MIN(EmployeeID), MAX(EmployeeID) FROM Employees;



--- 18️ RegulatoryReports
CREATE TABLE RegulatoryReports (
    ReportID INT IDENTITY(1,1) PRIMARY KEY,
    ReportType VARCHAR(50),
    SubmissionDate DATE
);

--  RegulatoryReports (50 row)
----------------------------
DECLARE @rr INT = 1;
WHILE @rr <= 50
BEGIN
    INSERT INTO RegulatoryReports (ReportType, SubmissionDate)
    VALUES (
        CASE WHEN @rr % 2 = 0 THEN 'Annual' ELSE 'Quarterly' END,
        DATEADD(DAY, -(@rr * 30), GETDATE())
    );
    SET @rr = @rr + 1;
END


-- 19️ Departments
CREATE TABLE Departments (
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentName VARCHAR(100),
    ManagerID INT,
    FOREIGN KEY (ManagerID) REFERENCES Employees(EmployeeID)
);
--  Departments (5 row)
----------------------------
----------------------------
-- Departments: 5 row insert (ManagerID 51–55)
----------------------------
DECLARE @dep INT = 1;

WHILE @dep <= 5
BEGIN
    INSERT INTO Departments (DepartmentName, ManagerID)
    VALUES (
    CASE @dep 
     WHEN 1 THEN 'HR'
     WHEN 2 THEN 'Finance'
     WHEN 3 THEN 'Loans'
     WHEN 4 THEN 'IT'
    ELSE 'Operations'
  END,
 (50 + @dep)  -- ManagerID 51–55
    );

 SET @dep = @dep + 1;
END


-- 20 Salaries
CREATE TABLE Salaries (
    SalaryID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT NOT NULL,
    BaseSalary DECIMAL(18,2),
    Bonus DECIMAL(18,2),
    Deductions DECIMAL(18,2),
    PaymentDate DATE,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);
----------------------------
--  Salaries (50 row)
----------------------------
DECLARE @sal INT = 1;
WHILE @sal <= 50
BEGIN
    INSERT INTO Salaries (EmployeeID, BaseSalary, Bonus, Deductions, PaymentDate)
    VALUES (
        (50 + @sal),  -- EmployeeID 51–100
        ROUND(RAND()*3000+500,2),
        ROUND(RAND()*500,2),
        ROUND(RAND()*200,2),
        DATEADD(MONTH, -(@sal % 12), GETDATE())
    );

    SET @sal = @sal + 1;
END


-- 21️ EmployeeAttendance
CREATE TABLE EmployeeAttendance (
    AttendanceID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT NOT NULL,
    CheckInTime DATETIME,
    CheckOutTime DATETIME,
    TotalHours DECIMAL(5,2),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);
--  EmployeeAttendance (5,000 row)
----------------------------
DECLARE @ea INT = 1;
WHILE @ea <= 5000
BEGIN
    INSERT INTO EmployeeAttendance (EmployeeID, CheckInTime, CheckOutTime, TotalHours)
    VALUES (
        (50 + ((@ea - 1) % 50) + 1),  -- EmployeeID 51–100
        DATEADD(MINUTE, -((@ea % 480) + 480), GETDATE()),
        GETDATE(),
        ROUND(RAND()*8+1,2)
    );

    SET @ea = @ea + 1;
END


-- 22️ Investments
CREATE TABLE Investments (
    InvestmentID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    InvestmentType VARCHAR(50),
    Amount DECIMAL(18,2),
    ROI DECIMAL(5,2),
    MaturityDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers1(CustomerID)
);
-- Investments (500 row)
----------------------------
DECLARE @inv INT = 1;
WHILE @inv <= 500
BEGIN
    INSERT INTO Investments (CustomerID, InvestmentType, Amount, ROI, MaturityDate)
    VALUES (
        ((@inv % 2000) + 1),
        CASE WHEN @inv % 3 = 0 THEN 'Stocks'
             WHEN @inv % 3 = 1 THEN 'Bonds'
             ELSE 'Mutual Fund' END,
        ROUND(RAND()*10000+1000,2),
        ROUND(RAND()*15,2),
        DATEADD(DAY, 365 + (@inv % 365), GETDATE())
    );
    SET @inv = @inv + 1;
END
-- 23️ StockTradingAccounts
CREATE TABLE StockTradingAccounts (
    AccountID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    BrokerageFirm VARCHAR(100),
    TotalInvested DECIMAL(18,2),
    CurrentValue DECIMAL(18,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers1(CustomerID)
);
-- StockTradingAccounts (400 row)
----------------------------
DECLARE @sta INT = 1;
WHILE @sta <= 400
BEGIN
    INSERT INTO StockTradingAccounts (CustomerID, BrokerageFirm, TotalInvested, CurrentValue)
    VALUES (
        ((@sta % 2000) + 1),
        'Brokerage ' + CAST((@sta % 20 + 1) AS VARCHAR(5)),
        ROUND(RAND()*10000+1000,2),
        ROUND(RAND()*12000+1000,2)
    );
    SET @sta = @sta + 1;
END
-- 24️ ForeignExchange
CREATE TABLE ForeignExchange (
    FXID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    CurrencyPair VARCHAR(10),
    ExchangeRate DECIMAL(10,4),
    AmountExchanged DECIMAL(18,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers1(CustomerID)
);
---  ForeignExchange (200 row)
----------------------------
DECLARE @fx INT = 1;
WHILE @fx <= 200
BEGIN
    INSERT INTO ForeignExchange (CustomerID, CurrencyPair, ExchangeRate, AmountExchanged)
    VALUES (
        ((@fx % 2000) + 1),
        CASE WHEN @fx % 2 = 0 THEN 'USD/UZS' ELSE 'EUR/UZS' END,
        ROUND(RAND()*12000+1000,2),
        ROUND(RAND()*5000+100,2)
    );
    SET @fx = @fx + 1;
END
-- 25️ InsurancePolicies
CREATE TABLE InsurancePolicies (
    PolicyID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    InsuranceType VARCHAR(50),
    PremiumAmount DECIMAL(18,2),
    CoverageAmount DECIMAL(18,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers1(CustomerID)
);
--  InsurancePolicies (300 row)
----------------------------
DECLARE @ins INT = 1;
WHILE @ins <= 300
BEGIN
    INSERT INTO InsurancePolicies (CustomerID, InsuranceType, PremiumAmount, CoverageAmount)
    VALUES (
        ((@ins % 2000) + 1),
        CASE WHEN @ins % 3 = 0 THEN 'Health'
        WHEN @ins % 3 = 1 THEN 'Life'
        ELSE 'Vehicle' END,
        ROUND(RAND()*500+50,2),
        ROUND(RAND()*20000+5000,2)
    );
    SET @ins = @ins + 1;
END
-- 26️ Claims
CREATE TABLE Claims (
    ClaimID INT IDENTITY(1,1) PRIMARY KEY,
    PolicyID INT NOT NULL,
    ClaimAmount DECIMAL(18,2),
    Status VARCHAR(20),
    FiledDate DATE,
    FOREIGN KEY (PolicyID) REFERENCES InsurancePolicies(PolicyID)
);

--  Claims (100 row)
----------------------------
DECLARE @cl INT = 1;
WHILE @cl <= 100
BEGIN
    INSERT INTO Claims (PolicyID, ClaimAmount, Status, FiledDate)
    VALUES (
    ((@cl % 300) + 1),
     ROUND(RAND()*5000+500,2),
     CASE WHEN @cl % 2 = 0 THEN 'Approved' ELSE 'Pending' END,
     DATEADD(DAY, -(@cl % 90), GETDATE())
    );
SET @cl = @cl + 1;
END

-- 27️⃣ UserAccessLogs
CREATE TABLE UserAccessLogs (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    ActionType VARCHAR(50),
    Timestamp DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES OnlineBankingUsers(UserID)
);
-- 27 UserAccessLogs (2,000 row)
----------------------------
DECLARE @ual INT = 1;
WHILE @ual <= 2000
BEGIN
    INSERT INTO UserAccessLogs (UserID, ActionType, Timestamp)
    VALUES (
        ((@ual % 1500) + 1),
        CASE WHEN @ual % 3 = 0 THEN 'Login'
        WHEN @ual % 3 = 1 THEN 'Transfer'
        ELSE 'Bill Payment' END,
        DATEADD(MINUTE, -(@ual % 1440), GETDATE())
    );
    SET @ual = @ual + 1;
END
-- CyberSecurityIncidents
CREATE TABLE CyberSecurityIncidents (
    IncidentID INT IDENTITY(1,1) PRIMARY KEY,
    AffectedSystem VARCHAR(100),
    ReportedDate DATETIME DEFAULT GETDATE(),
    ResolutionStatus VARCHAR(50)
);
--- CyberSecurityIncidents (20 row)
----------------------------
DECLARE @csi INT = 1;
WHILE @csi <= 20
BEGIN
    INSERT INTO CyberSecurityIncidents (AffectedSystem, ReportedDate, ResolutionStatus)
    VALUES (
    'System ' + CAST(@csi AS VARCHAR(5)),
    DATEADD(DAY, -(@csi % 30), GETDATE()),
    CASE WHEN @csi % 2 = 0 THEN 'Resolved' ELSE 'Open' END
    );
    SET @csi = @csi + 1;
END

-- 29️ Merchants
CREATE TABLE Merchants (
    MerchantID INT IDENTITY(1,1) PRIMARY KEY,
    MerchantName VARCHAR(100),
    Industry VARCHAR(50),
    Location VARCHAR(255),
    CustomerID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers1(CustomerID)
);
--  Merchants (50 row)
----------------------------
DECLARE @m INT = 1;
WHILE @m <= 50
BEGIN
    INSERT INTO Merchants (MerchantName, Industry, Location, CustomerID)
    VALUES (
    'Merchant ' + CAST(@m AS VARCHAR(5)),
     CASE WHEN @m % 2 = 0 THEN 'Retail' ELSE 'Food' END,
     'Location ' + CAST(@m AS VARCHAR(5)),
     ((@m % 2000) + 1)
    );
    SET @m = @m + 1;
END

-- 30️ MerchantTransactions
CREATE TABLE MerchantTransactions (
    TransactionID INT IDENTITY(1,1) PRIMARY KEY,
    MerchantID INT NOT NULL,
    Amount DECIMAL(18,2),
    PaymentMethod VARCHAR(50),
    Date DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (MerchantID) REFERENCES Merchants(MerchantID)
);
--  MerchantTransactions (200 row)
----------------------------
DECLARE @mt INT = 1;
WHILE @mt <= 200
BEGIN
    INSERT INTO MerchantTransactions (MerchantID, Amount, PaymentMethod, Date)
    VALUES (
     ((@mt % 50) + 1),
     ROUND(RAND()*5000+100,2),
     CASE 
	 WHEN @mt % 2 = 0 THEN 'Card' ELSE 'Cash' END,
     DATEADD(DAY, -(@mt % 60), GETDATE())
    );
    SET @mt = @mt + 1;
END




--Tasks
--1
SELECT TOP 3 c.CustomerID, c.FullName, SUM(a.Balance) AS TotalBalance
FROM Customers1 c
JOIN Accounts a ON c.CustomerID = a.CustomerID
GROUP BY c.CustomerID, c.FullName
ORDER BY SUM(a.Balance) DESC;

--2
SELECT c.CustomerID, c.FullName, COUNT(l.LoanID) AS ActiveLoanCount
FROM Customers1 c
JOIN Loans l ON c.CustomerID = l.CustomerID
WHERE l.Status = 'Active'
GROUP BY c.CustomerID, c.FullName
HAVING COUNT(l.LoanID) > 1;
--3
SELECT c.CustomerID, c.FullName, COUNT(l.LoanID) AS ActiveLoanCount
FROM Customers1 c
JOIN Loans l ON c.CustomerID = l.CustomerID
WHERE l.Status = 'Active'
GROUP BY c.CustomerID, c.FullName
HAVING COUNT(l.LoanID) > 1;
--4
SELECT b.BranchID, b.BranchName, SUM(l.Amount) AS TotalLoanAmount
FROM Loans l
JOIN Accounts a ON l.CustomerID = a.CustomerID
JOIN Branches b ON a.BranchID = b.BranchID
WHERE l.Status = 'Active'
GROUP BY b.BranchID, b.BranchName
ORDER BY TotalLoanAmount DESC;
--5
WITH LargeTx AS (
SELECT t.CustomerID, t.TransactionID, t.Amount, t.Date,
 LEAD(t.Date) OVER(PARTITION BY t.CustomerID ORDER BY t.Date) AS NextTx
 FROM Transactions t
 JOIN Accounts a ON t.AccountID = a.AccountID
 WHERE t.Amount > 10000
)
SELECT CustomerID
FROM LargeTx
WHERE DATEDIFF(MINUTE, Date, NextTx) <= 60
GROUP BY CustomerID;
--6
SELECT DISTINCT t1.CustomerID
FROM Transactions t1
JOIN Transactions t2
    ON t1.CustomerID = t2.CustomerID
    AND t1.TransactionID <> t2.TransactionID
    AND t1.Country <> t2.Country
    AND ABS(DATEDIFF(MINUTE, t1.TransactionDate, t2.TransactionDate)) <= 10;
	


--7
--Average Account Balance Per Customer
SELECT c.CustomerID, c.FullName, AVG(a.Balance) AS AvgBalance
FROM Customers1 c
JOIN Accounts a ON c.CustomerID = a.CustomerID
GROUP BY c.CustomerID, c.FullName
ORDER BY AvgBalance DESC;
--8
SELECT 
b.BranchID, b.BranchName, 
CAST(t.Date AS DATE) AS TransactionDate,
COUNT(t.TransactionID) AS TotalTransactions
FROM Transactions t
JOIN Accounts a ON  t.AccountID = a.AccountID
JOIN Branches b ON a.BranchID =  b.BranchID
GROUP BY b.BranchID, b.BranchName, CAST   (t.Date AS DATE)
ORDER BY TransactionDate, TotalTransactions DESC;
--9

--Average Loan Amount Per Customer
SELECT AVG(Amount) AS AvgLoanAmount
FROM Loans
WHERE Status = 'Active';


