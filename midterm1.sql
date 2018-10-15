--------- CREATE DATABASE ----------
USE [DLRDB-CF]
GO
;

CREATE DATABASE [DLRDB-CF]
GO
;

-------------- UDDTs -------------
CREATE TYPE names
FROM VARCHAR(50) NOT NULL;

CREATE TYPE streetnames
FROM VARCHAR(50) NOT NULL;

CREATE TYPE citynames
FROM VARCHAR(30) NOT NULL;

CREATE TYPE statenames
FROM CHAR(2) NOT NULL;

CREATE TYPE zipCodes
FROM CHAR(5) NOT NULL;

---------------------- END UDDTs -------------

---------BEGIN CREATE TABLES -----------

CREATE TABLE CUST (
  [customer number] CHAR(8) NOT NULL,
  [last name] names,
  [first name] names,
  [street number] CHAR(5) NOT NULL,
  [street line 1] streetnames,
  [street line 2] streetnames NULL,
  city citynames,
  state statenames,
  [zip code] zipCodes NULL,
  [drivers license] CHAR(10) NULL,
  [date of birth] SMALLDATETIME NULL
)

CREATE TABLE DEALER (
  [dealer number] CHAR(4) NOT NULL,
  [dealer name] VARCHAR(40) NOT NULL,
  [street number] CHAR(5) NOT NULL,
  [street line 1] streetnames,
  [street line 2] streetnames NULL,
  city citynames,
  state statenames,
  [zip code] zipCodes,
  [open date] SMALLDATETIME NOT NULL
)

CREATE TABLE VEHICLE (
  [vehicle code] CHAR(7) NOT NULL,
  [year] SMALLDATETIME NOT NULL,
  make VARCHAR(15) NOT NULL,
  model VARCHAR(15) NULL,
  [time line] VARCHAR(4) NULL,
  [date model introduced] SMALLDATETIME NOT NULL,
  msrp SMALLMONEY NOT NULL
)

CREATE TABLE INVENTORY (
  [inventory code] CHAR(7) NOT NULL,
  [dealer number] CHAR(4) NOT NULL,
  [vin number] CHAR(17) NOT NULL,
  [new or used] CHAR(1) NOT NULL,
  [date arrived at dealership] SMALLDATETIME NOT NULL,
  [date available in stock] SMALLDATETIME NULL,
  [date sold] SMALLDATETIME NULL,
  [listed price] SMALLMONEY NOT NULL,
  [exterior color] VARCHAR(10) NOT NULL,
  [interior color] VARCHAR(10) NOT NULL,
  [vehicle code] CHAR(7) NOT NULL,
  [available for sale] BIT NOT NULL
)

CREATE TABLE NEWVEH (
  [inventory code] CHAR(7) NOT NULL,
  msrp SMALLMONEY NOT NULL,
  [invoice price] SMALLMONEY NOT NULL,
  [date shipped] SMALLDATETIME NOT NULL
)

CREATE TABLE USEDVEH (
  [inventory code] CHAR(7) NOT NULL,
  [purchase date] SMALLDATETIME NOT NULL,
  [purchase price] SMALLMONEY NOT NULL,
  mileage INT NOT NULL,
  [blue book value] SMALLMONEY NOT NULL,
  [trade in flag] BIT NOT NULL
)

CREATE TABLE TESTDRIVE (
  [test drive code] CHAR(7) NOT NULL,
  [customer number] CHAR(8) NOT NULL,
  [date of test drive] SMALLDATETIME NOT NULL,
  [duration of test drive] DECIMAL NULL,
  [inventory code] CHAR(7) NOT NULL
)

CREATE TABLE SALES (
  [inventory code] CHAR(7) NOT NULL,
  [customer number] CHAR(8) NOT NULL,
  [sales price] SMALLMONEY NOT NULL,
  [sales date] SMALLDATETIME NOT NULL,
  [tax amount] SMALLMONEY NOT NULL,
  [payment method] CHAR(1) NOT NULL
)

CREATE TABLE AVAILOPTION (
  [option code] CHAR(4) NOT NULL,
  [option cost] SMALLMONEY NOT NULL,
  [option msrp] SMALLMONEY NULL,
  [option description] VARCHAR(200) NULL,
  [vehicle code] CHAR(7) NOT NULL
)

CREATE TABLE INSTOPTIONS (
  [inventory code] CHAR(7) NOT NULL,
  [option code] CHAR(4) NOT NULL,
  [dealer installed flag] BIT NOT NULL
)

CREATE TABLE CUSTVEH (
  [customer number] CHAR(8) NOT NULL,
  [vin number] CHAR(17) NOT NULL,
  [vehicle code] CHAR(7) NOT NULL,
  [first seen date] SMALLDATETIME NOT NULL
)

CREATE TABLE SERVREC (
  [service record number] CHAR(8) NOT NULL,
  [customer number] CHAR(8) NOT NULL,
  [vin number] CHAR(17) NOT NULL,
  [dealer number] CHAR(4) NOT NULL,
  [type of service] CHAR(3) NOT NULL,
  [date brought in] SMALLDATETIME NOT NULL,
  mileage INT NOT NULL,
  [date service completed] SMALLDATETIME NULL,
  [date billed] SMALLDATETIME NULL,
  [total service cost] SMALLMONEY NULL
)

CREATE TABLE ROUTSERV (
  [service record number] CHAR(8) NOT NULL,
  [service type code] CHAR(3) NOT NULL,
  [list price] SMALLMONEY NOT NULL,
  discount SMALLMONEY NOT NULL
)

CREATE TABLE REPSERV (
  [service record number] CHAR(8) NOT NULL,
  [parts cost] SMALLMONEY NOT NULL,
  [labor hours] DECIMAL NOT NULL,
  [labor cost] SMALLMONEY NOT NULL
);

---------- END CREATE TABLES ----------------

------- BEGIN UNIQUE CONSTRAINTS -------
ALTER TABLE CUST
  ADD
	CONSTRAINT CUST_CUSTNUM_UQ UNIQUE ([customer number]),
	CONSTRAINT CUST_LICENSE_UQ UNIQUE ([drivers license])
;

ALTER TABLE DEALER
  ADD
	CONSTRAINT DEALER_DEALERNUM_UQ UNIQUE ([dealer number]),
	CONSTRAINT DEALER_DEALERNAME_UQ UNIQUE ([dealer name])
;

ALTER TABLE VEHICLE
  ADD CONSTRAINT VEH_VEHCODE_UQ UNIQUE ([vehicle code])
;

ALTER TABLE INVENTORY
  ADD CONSTRAINT INV_INVCODE_UQ UNIQUE ([inventory code])
;

ALTER TABLE NEWVEH
  ADD CONSTRAINT NEWVEH_INVCODE_UQ UNIQUE ([inventory code])
;

ALTER TABLE USEDVEH
  ADD CONSTRAINT USEDVEH_INVCODE_UQ UNIQUE ([inventory code])
;

ALTER TABLE TESTDRIVE
  ADD CONSTRAINT TD_CODE_UQ UNIQUE ([test drive code])
;

ALTER TABLE AVAILOPTIONS
  ADD CONSTRAINT AVAIL_OPTCODE_UQ UNIQUE ([option code])
;

ALTER TABLE SERVREC
  ADD CONSTRAINT SERVREC_RECNUM_UQ UNIQUE ([service record number])
;

ALTER TABLE ROUTSERV
  ADD CONSTRAINT ROUTERV_RECNUM_UQ UNIQUE ([service record number])
;

ALTER TABLE REPSERV
  ADD CONSTRAINT REPSERV_RECNUM_UQ UNIQUE ([service record number])
;
-------------- END UNIQUE CONSTRAINTS -------------

--------- BEGIN PKs --------
ALTER TABLE CUST
  ADD CONSTRAINT PK_CUST PRIMARY KEY ([customer number]);

ALTER TABLE DEALER
  ADD CONSTRAINT PK_DEALER PRIMARY KEY ([dealer number]);

ALTER TABLE VEHICLE
  ADD CONSTRAINT PK_VEH PRIMARY KEY ([vehicle code]);

ALTER TABLE INVENTORY
  ADD CONSTRAINT PK_INV PRIMARY KEY ([inventory code]);

ALTER TABLE NEWVEH
  ADD CONSTRAINT PK_NEW PRIMARY KEY ([inventory code]);

ALTER TABLE USEDVEH
  ADD CONSTRAINT PK_USED PRIMARY KEY ([inventory code]);

ALTER TABLE TESTDRIVE
  ADD CONSTRAINT PK_TD PRIMARY KEY ([test drive code]);

ALTER TABLE SALES
  ADD CONSTRAINT PK_SALES PRIMARY KEY ([inventory code], [customer number]);

ALTER TABLE AVAILOPTIONS
  ADD CONSTRAINT PK_AVAIL PRIMARY KEY ([option code]);

ALTER TABLE INSTOPTIONS
  ADD CONSTRAINT PK_INST PRIMARY KEY ([inventory code], [option code]);

ALTER TABLE CUSTVEH
  ADD CONSTRAINT PK_CUSTVEH PRIMARY KEY ([vin number]);

ALTER TABLE SERVREC
  ADD CONSTRAINT PK_SERVREC PRIMARY KEY ([service record number]);

ALTER TABLE ROUTSERV
  ADD CONSTRAINT PK_ROUT PRIMARY KEY ([service record number]);

ALTER TABLE REPSERV
  ADD CONSTRAINT PK_REP PRIMARY KEY ([service record number]);

--------- END PKs ----------

--------- BEGIN FKs ---------
ALTER TABLE INVENTORY
  ADD
    CONSTRAINT FK1_INV_DEAL FOREIGN KEY ([dealer number])
      REFERENCES DEALER([dealer number]),
    CONSTRAINT FK2_INV_VEH FOREIGN KEY ([vehicle code])
      REFERENCES VEHICLE([vehicle code])
;

ALTER TABLE NEWVEH
  ADD CONSTRAINT FK1_NEW_INV
  FOREIGN KEY ([inventory code]) REFERENCES INVENTORY([inventory code]);

ALTER TABLE USEDVEH
  ADD CONSTRAINT FK1_USED_INV
  FOREIGN KEY ([inventory code]) REFERENCES INVENTORY([inventory code]);

ALTER TABLE TESTDRIVE
  ADD
    CONSTRAINT FK1_TD_CUST FOREIGN KEY ([customer number])
      REFERENCES CUST([customer number]),
    CONSTRAINT FK2_TD_INV FOREIGN KEY ([inventory code])
      REFERENCES INVENTORY([inventory code])
;

ALTER TABLE SALES
  ADD
    CONSTRAINT FK1_SALES_INV FOREIGN KEY ([inventory code])
      REFERENCES INVENTORY([inventory code]),
    CONSTRAINT FK2_SALES_CUST FOREIGN KEY ([customer number])
      REFERENCES CUST([customer number])
;

ALTER TABLE AVAILOPTIONS
  ADD CONSTRAINT FK1_AVAIL_VEH FOREIGN KEY ([vehicle code])
    REFERENCES VEHICLE([vehicle code])
;

ALTER TABLE INSTOPTIONS
  ADD
    CONSTRAINT FK1_INST_INV FOREIGN KEY ([inventory code])
      REFERENCES INVENTORY([inventory code]),
    CONSTRAINT FK2_INST_AVAIL FOREIGN KEY ([option code])
      REFERENCES AVAILOPTIONS([option code])
;

ALTER TABLE CUSTVEH
  ADD
    CONSTRAINT FK1_CUSTVEH_CUST FOREIGN KEY ([customer number])
      REFERENCES CUST([customer number]),
    CONSTRAINT FK2_CUSTVEH_VEHCODE FOREIGN KEY ([vehicle code])
      REFERENCES VEHICLE([vehicle code])
;

ALTER TABLE SERVREC
  ADD
    CONSTRAINT FK1_SERVREC_CUSTNUM FOREIGN KEY ([customer number], [vin number])
      REFERENCES CUSTVEH([customer number], [vin number]),
    CONSTRAINT FK3_SERVREC_DEAL FOREIGN KEY ([dealer number])
      REFERENCES DEALER([dealer number])
;

ALTER TABLE ROUTSERV
  ADD CONSTRAINT FK1_ROUT_SERVREC FOREIGN KEY ([service record number])
	REFERENCES SERVREC([service record number])
;

ALTER TABLE REPSERV
  ADD CONSTRAINT FK1_REP_SERVREC FOREIGN KEY ([service record number])
    REFERENCES SERVREC([service record number])
;
------- END FKs ----------

---------- BEGIN CHECK CONSTRAINTS --------
ALTER TABLE CUST
  ADD
    CONSTRAINT CK1_LICENSE CHECK (([drivers license] IS NULL AND [date of birth] IS NULL)
      OR ([drivers license] IS NOT NULL AND [date of birth] IS NOT NULL)),
    CONSTRAINT CK2_CUST_AGE CHECK (DATEDIFF(year,[date of birth], getDate) >= 18),
    CONSTRAINT CK3_CUST_ZIP CHECK ([zip code] LIKE '[0-9][0-9][0-9][0-9][0-9]')
;

ALTER TABLE DEALER
  ADD
    CONSTRAINT CK1_OPEN CHECK (DATEDIFF(year,getDate(), [open date]) < 1),
    CONSTRAINT CK2_DEAL_ZIP CHECK ([zip code] LIKE '[0-9][0-9][0-9][0-9][0-9]'),
    CONSTRAINT CK3_DEAL_NAME CHECK ([dealer name] LIKE '%LLC')
;

ALTER TABLE VEHICLE
  ADD
    CONSTRAINT CK1_VEH_YR CHECK (DATEDIFF(year,[year], getDate()) > 1),
    CONSTRAINT CK2_INTRO CHECK (DATEDIFF(m,[date model introduced],getDate()) > 3)
;

ALTER TABLE INVENTORY
  ADD
    CONSTRAINT CK1_NEW_USED CHECK ([new or used] IN ('U','u','N','n')),
    CONSTRAINT CK2_ARRIVED CHECK (DATEDIFF(m,getDate(),[date arrived at dealership]) < 1),
    CONSTRAINT CK3_DATE_STOCK CHECK (DATEDIFF(d, [date available in stock],getDate()) <= 0),
    CONSTRAINT CK4_DATE_SOLD CHECK (DATEDIFF(d,[date sold],[date available in stock]) <= 0),
    CONSTRAINT CK5_SOLD_NULL CHECK (([date sold] IS NULL AND [available for sale] = 1) OR ([date sold] IS NOT NULL AND [available for sale] = 0))
;

ALTER TABLE NEWVEH
  ADD
    CONSTRAINT CK1_MSRP CHECK (msrp > 0),
    CONSTRAINT CK2_INVOICE CHECK ([invoice price] < msrp),
    CONSTRAINT CK3_SHIPPED CHECK (DATEDIFF(m,[date shipped],getDate()) <= 1)
;

ALTER TABLE USEDVEH
  ADD
    CONSTRAINT CK1_PURCHASE CHECK (DATEDIFF(d,[purchase date],getDate()) <= 0),
    CONSTRAINT CK2_TRADEIN CHECK (([trade in flag] = 1 AND [purchase price]/[blue book value] < 1.2) or ([trade in flag] = 0 AND [purchase price]/[blue book value] < .9)),
    CONSTRAINT CK3_MILES CHECK (mileage > 0),
    CONSTRAINT CK4_BLUEBOOK CHECK ([blue book value] > 0)
;

ALTER TABLE TESTDRIVE
  ADD
    CONSTRAINT CK1_DATE CHECK ([date of test drive] <= getDate()),
    CONSTRAINT CK2_DURATION CHECK ([duration of test drive] > 0)
;

ALTER TABLE SALES
  ADD
    CONSTRAINT CK1_PRICE CHECK ([sales price] > 0),
    CONSTRAINT CK2_TAX CHECK ([tax amount] > 0 AND ([tax amount]/[sales price] < .1)),
    CONSTRAINT CK3_PMT CHECK ([payment method] IN ('C', 'L', 'F', 'O'))
;

ALTER TABLE AVAILOPTIONS
  ADD
    CONSTRAINT CK1_COST CHECK ([option cost] > 0),
    CONSTRAINT CK2_MSRP CHECK ([option msrp] > 0 AND [option msrp] > [option cost])
;

ALTER TABLE SERVREC
  ADD
    CONSTRAINT CK1_TYPE CHECK ([type of service] LIKE 'RO,REP'),
    CONSTRAINT CK2_BROUGHT CHECK ([date brought in] <= getDate()),
    CONSTRAINT CK3_COMPLETED CHECK ([date service completed] <= getDate() AND [date service completed] > [date brought in]),
    CONSTRAINT CK4_DATE_BILLED CHECK ([date billed] >= [date service completed]),
    CONSTRAINT CK5_TOTAL_COST CHECK ([total service cost] >= 0)
;
---------- END CHECK CONSTRAINTS ----------

-------- BEGIN TRIGGERS ----------
CREATE TRIGGER TRG_USEDCAR
ON USEDVEH
AFTER INSERT
AS
  IF (
    NOT EXISTS (
      SELECT *
      FROM NEWVEH N JOIN INSERTED I
        ON N.[inventory code] = I.[inventory code]
      )
    AND
    EXISTS (
      SELECT *
      FROM INVENTORY INV JOIN INSERTED I
        ON INV.[inventory code] = I.[inventory code]
      WHERE UPPER(INV.[new or used] = 'U')
    )
  )
    BEGIN
      PRINT 'Record added successfully.'
    END
  ELSE
    BEGIN
      ROLLBACK
      PRINT 'Vehicle already exists in NEWVEH. Record has been removed from USEDVEH.'
    END
;

CREATE TRIGGER TRG_NEWCAR
ON NEWVEH
AFTER INSERT
AS
  IF (
    NOT EXISTS (
      SELECT *
      FROM USEDVEH U JOIN INSERTED I
        ON U.[inventory code] = I.[inventory code]
    )
    AND
    EXISTS (
      SELECT *
      FROM INVENTORY INV JOIN INSERTED I
        ON INV.[inventory code] = I.[inventory code]
      WHERE INV.[new or used] = 'N' OR INV.[new or used] = 'n'
    )
  )
    BEGIN
      PRINT 'Record added successfully.'
    END;
  ELSE
    BEGIN
      ROLLBACK
      PRINT 'Vehicle already exists in USEDVEH. Record has been deleted from NEWVEH.'
    END
;

CREATE TRIGGER TRG_CARSALES
ON SALES
AFTER INSERT
AS
  UPDATE INVENTORY
  SET [date sold] = getDate(), [available for sale] = 0
  FROM INSERTED
  WHERE INSERTED.[inventory code] = INVENTORY.[inventory code]
;

CREATE TRIGGER TRG_TESTDRIVE
ON TESTDRIVE
AFTER INSERT
AS
  IF (
    EXISTS (
      SELECT *
      FROM INVENTORY INV JOIN INSERTED I
        ON INV.[inventory code] = I.[inventory code]
      WHERE INV.[available for sale] = 1
    )
  )
    BEGIN
      PRINT 'Record added successfully.'
    END
  ELSE
    BEGIN
      ROLLBACK
      PRINT 'Vehicle not available for sale. Record deleted from TESTDRIVE.'
    END
;

CREATE TRIGGER TRG_SERVICE
ON SERVREC
AFTER INSERT
AS
  IF (
    EXISTS (
      SELECT *
      FROM SERVREC S JOIN INSERTED I
        ON S.[service record number] = I.[service record number]
      WHERE S.[type of service] LIKE 'RO'
    )
  )
    BEGIN
      INSERT INTO ROUTSERV([service record number],[service type code],[list price],[discount])
        SELECT [service record number],[type of service],[total service cost],0
        FROM INSERTED
        WHERE [type of service] = 'RO'
    END
  ELSE
    BEGIN
      INSERT INTO REPSERV([service record number],[parts cost],[labor hours],[labor cost])
        SELECT [service record number],0,0,0
        FROM INSERTED
        WHERE [type of service] = 'REP'
    END
;
--------- END TRIGGERS ----------

---------- BEGIN INSERTS ---------
INSERT INTO CUST ([customer number],[last name],[first name],[street number],[street line 1],[city],[state],[zip code], [drivers license], [date of birth])
VALUES
('1','Frashure','Chris','10','Street Rd','Fairfax','VA','22033', 'V123456789', '05/16/1989'),
('2','Ashmore','Matthew','11','Street Rd','Fairfax','VA','22033', 'V123456780', '06/14/1989'),
('3','Ejaz','Hasham','12','Street Rd','Fairfax','VA','22033', 'V123456788', '02/14/1993'),
('4','Williams','Elliott','13','Street Rd','Fairfax','VA','22033', 'V123456787', '11/02/1990'),
('5','Maldonado','Frankie','14','Street Rd','Fairfax','VA','22033', 'V12345678', '01/21/1988')
;

INSERT INTO DEALER ([dealer number],[dealer name],[street number],[street line 1],[city],[state],[zip code],[open date])
VALUES
('1','Cars R Us LLC','10','Fall Dr','Fairfax','VA','12345','10/24/2017'),
('2','RVA Auto LLC','11','Broad St','Richdmon','VA','12346','9/24/2013'),
('3','RVA Cars LLC','10','Fall Dr','Fairfax','VA','12347','1/24/2014'),
('4','NOVA Auto LLC','10','Fall Dr','Fairfax','VA','12348','4/24/2016'),
('5','Southern Auto LLC','10','Fall Dr','Fairfax','VA','12349','5/24/2015')
;


INSERT INTO VEHICLE ([vehicle code],[year],[make],[model],[date model introducted],[msrp])
VALUES
('1','1997','Honda','Civic','01/01/1997','1000'),
('2','2007','Honda','Accord','01/01/2007','5000'),
('3','2009','Acura','RSK','01/01/2009','8000'),
('4','2013','Toyota','Corolla','01/01/2013','10000'),
('5','2013','Subaru','BRZ','01/01/2013','15000'),
('6','1997','Honda','Civic','01/01/1997','1000'),
('7','2007','Honda','Accord','01/01/2007','5000'),
('8','2009','Acura','RSK','01/01/2009','8000'),
('9','2013','Toyota','Corolla','01/01/2013','10000'),
('10','2013','Subaru','BRZ','01/01/2013','15000'),
('11','1997','Honda','Civic','01/01/1997','1000'),
('12','2007','Honda','Accord','01/01/2007','5000'),
('13','2009','Acura','RSK','01/01/2009','8000'),
('14','2013','Toyota','Corolla','01/01/2013','10000'),
('15','2013','Subaru','BRZ','01/01/2013','15000')
;

INSERT INTO INVENTORY ([inventory code],[dealer number], [vin number], [new or used], [date arrived at dealership], [listed price], [exterior color], [interior color], [vehicle code], [available for sale])
VALUES
('1','1','22222222222222222', 'U', '01/02/2018', '2000', 'black', 'gray', '1', '1'),
('2','1','11111111111111111', 'U', '02/02/2018', '10000', 'white', 'gray', '2', '1'),
('3','2','33333333333333333', 'U', '03/02/2018', '16000', 'black', 'black', '3', '1'),
('4','2','44444444444444444', 'U', '04/02/2017', '20000', 'black', 'gray', '4', '1'),
('5','3','55555555555555555', 'U', '05/02/2017', '30000', 'black', 'gray', '5', '1'),
('6','1','66666666666666666', 'N', '01/02/2018', '20000', 'black', 'gray', '6', '1'),
('7','1','77777777777777777', 'N', '01/02/2018', '25000', 'black', 'gray', '7', '1'),
('8','4','88888888888888888', 'N', '01/02/2018', '26000', 'black', 'gray', '8', '1'),
('9','5','99999999999999999', 'N', '01/02/2018', '27000', 'black', 'gray', '9', '1'),
('10','5','00000000000000001', 'N', '01/02/2018', '28000', 'black', 'gray', '10', '1')
;

INSERT INTO NEWVEH ([inventory code], [msrp], [invoice price], [date shipped])
VALUES
('6', '18000', '17000', '02/01/2018'),
('7', '20000', '19000', '02/01/2018'),
('8', '21000', '20000', '02/01/2018'),
('9', '22000', '21000', '02/01/2018'),
('10', '23000', '22000', '02/01/2018')
;

INSERT INTO USEDVEH ([inventory code], [purchase date], [mileage], [purchase price], [blue book value], [trade in flag])
VALUES
('1', '01/01/2018', '1000', '100000', '1200', '1'),
('2', '02/01/2018', '8000', '80000', '10000', '1'),
('3', '03/01/2018', '12000', '60000', '14000', '1'),
('4', '03/11/2018', '16000', '40000', '10800', '1'),
('5', '02/20/2018', '20000', '30000', '24000', '1')
;

INSERT INTO TESTDRIVE ([test drive code], [customer number], [date of test drive], [duration of test drive], [inventory code])
VALUES
('1,', '1', '12/30/2017', '.5', '6'),
('2,', '2', '08/02/2017', '.5', '7'),
('3,', '4', '10/03/2017', '.5', '3'),
('4,', '3', '09/10/2017', '.5', '2'),
('5,', '5', '11/01/2017', '.5', '1')
;

INSERT INTO SALES ([inventory code], [customer number], [sales price], [sales date], [tax amount], [payment method])
VALUES
('6', '1', '20000', '03/05/2018', '100', 'L'),
('7', '2', '20000', '03/04/2018', '100', 'C'),
('3', '4', '16000', '03/03/2018', '100', 'C'),
('2', '3', '10000', '03/02/2018', '100', 'O'),
('1', '5', '2000', '03/11/2018', '500', 'O')
;

INSERT INTO AVAILOPTIONS ([option code], [option cost], [vehicle code])
VALUES
('1', '200', '5'),
('2', '300', '2'),
('3', '400', '3'),
('4', '500', '4'),
('5', '600', '5')
;

INSERT INTO INSTOPTIONS ([inventory code], [option code], [dealer installed flag])
VALUES
('5', '1', '0'),
('6', '2', '1'),
('7', '3', '0'),
('8', '4', '1'),
('9', '5', '0')
;

INSERT INTO CUSTVEH ([customer number], [vin number], [vehicle code], [first seen date])
VALUES
('1', '22332233223322331', '11', '01/02/2018'),
('2', '33223322332233221', '12', '02/02/2018'),
('3', '11221122112211221', '13', '01/01/2018'),
('4', '44554455445544551', '14', '02/01/2018'),
('5', '88998899889988991', '15', '03/04/2018')
;

INSERT INTO SERVREC ([service record number], [customer number], [vin number], [dealer number], [type of service], [date brought in], [mileage])
VALUES
('1', '1', '22332233223322331', '1', 'RO', 01/02/2018, '01/02/2018, 20000'),
('2', '2', '33223322332233221', '1', 'RO', 02/02/2018, '02/02/2018, 20000'),
('3', '3', '11221122112211221', '1', 'RO', 01/01/2018, '01/01/2018, 20000'),
('4', '4', '44554455445544551', '1', 'REP', 02/01/2018, '02/01/2018, 20000'),
('5', '5', '88998899889988991', '1', 'REP', 03/04/2018, '03/04/2018, 20000')
;

INSERT INTO ROUTSERV ()
;

INSERT INTO REPSERV ()
;

----------- END INSERTS ------------

----- BEGIN TRANSACTIONS -----
BEGIN TRANSACTION TRAN1;
BEGIN TRY
  INSERT INTO INVENTORY ([inventory code],[dealer number],[vin number],[new or used],[date arrived at dealership],[listed price],[exterior color],[interior color],[vehicle code],[available for sale])
  VALUES
  ('238','1','12345678900012345','N',getDate(),'10000','black','tan','238','1');

  INSERT INTO NEWVEH ([inventory code],[msrp],[invoice price],[date shipped])
  VALUES
  ('238','10000','10000','03/20/2018');
END TRY
BEGIN CATCH
  SELECT @@TRANCOUNT AS numTrans, ERROR_MESSAGE AS errorMessage;
  IF @@TRANCOUNT > 0
    ROLLBACK TRANSACTION TRAN1;
  END CATCH;


BEGIN TRANSACTION TRAN2
BEGIN TRY
  INSERT INTO INVENTORY ([inventory code],[dealer number],[vin number],[new or used],[date arrived at dealership],[listed price],[exterior color],[interior color],[vehicle code],[available for sale])
  VALUES
  ('239','1','12345678901234500','U',02/10/2018,'10000','blue','black','239','1');

  INSERT INTO USEDVEH ([inventory code],[purchase date],[purchase price],[mileage],[blue book value],[trade in flag])
  VALUES
  ('239','02/10/2018','7000','80000','8000','1');
END TRY
BEGIN CATCH
  SELECT @@TRANCOUNT AS numTrans, ERROR_MESSAGE() AS errorMessage;
  IF @@TRANCOUNT > 0
    ROLLBACK TRANSACTION TRAN2;
END CATCH;


BEGIN TRANSACTION TRAN3
BEGIN TRY
  INSERT INTO SALES ([inventory code],[customer number],[sales price],[sales date],[tax amount],[payment method])
  VALUES
  ('239','2','15000','02/27/2018','800','L');

  UPDATE TABLE INVENTORY
  SET [available for sale] = 0
  WHERE INVENTORY.[inventory code] = '239';
END TRY
BEGIN CATCH
  SELECT @@TRANCOUNT AS numTrans, ERROR_MESSAGE() AS errorMessage;
  IF @@TRANCOUNT > 0
    ROLLBACK TRANSACTION TRAN4
END CATCH;


BEGIN TRANSACTION TRAN4
BEGIN TRY
  INSERT INTO SERVREC ([service record number],[customer number],[vin number],[dealer number],[type of service],[date brought in],[mileage])
  VALUES
  ('1','1','12345678901234500','1','REP','02/15/2018','40000');

  INSERT INTO REPSERV ([service record number],[parts cost],[labor hours],[labor cost])
  VALUES
  ('1','200','4','100');
END TRY
BEGIN CATCH
  SELECT @@TRANCOUNT AS numTrans, ERROR_MESSAGE() AS errorMessage;
  IF @@TRANCOUNT > 0
    ROLLBACK TRANSACTION TRAN4
END CATCH;

BEGIN TRANSACTION TRAN5
BEGIN TRY
INSERT INTO SERVREC ([service record number],[customer number],[vin number],[dealer number],[type of service],[date brought in],[mileage])
VALUES
('2','2','43215678901234500','2','RO','02/24/2018','30000');

INSERT INTO ROUTSERV ([service record number],[service type code],[list price],[discount])
VALUES
  ('2','REP','300','0');
END TRY
BEGIN CATCH
  SELECTION @@TRANCOUNT AS numTrans, ERROR_MESSAGE() AS errorMessage;
  IF @@TRANCOUNT > 0
    ROLLBACK TRANSACTION TRAN5
END CATCH;

----- END TRANSACTIONS -----

---- BEGIN VIEWS -----
CREATE VIEW INSTOCK
AS
  SELECT I.[inventory code], V.[year], V.[make], V.[model], V.[trim line], I.[vin number], I.[exterior color], I.[interior color], I.[listed price], D.[dealer name]
  FROM VEHICLE V JOIN INVENTORY I
    ON V.[vehicle code] = I.[vehicle code]
  JOIN DEALER D
    ON I.[dealer number] = D.[dealer number]
  WHERE I.[available for sale] = 1
  ;

SELECT *
FROM INSTOCK
WHERE VEHICLE.[make] IN ('Honda', 'Ford')
;

CREATE VIEW INSTOCKUSED
AS
  SELECT I.[inventory code], V.[year], V.[make], V.[model], V.[trim line], I.[vin number],I.[interior color], I.[exterior color], U.[mileage], I.[listed price], U.[blue book value], D.[dealer name]
  FROM INVENTORY I JOIN VEHICLE V
    ON I.[vehicle code] = V.[vehicle code]
  JOIN USEDVEH U
    ON I.[inventory code] = U.[inventory code]
  JOIN DEALER D
    ON I.[dealer number] = D.[dealer number]
  WHERE UPPER(I.[new or used] = 'U') AND I.[available for sale] = 1
;

SELECT *
FROM INSTOCKUSED
WHERE VEHICLE.[make] IN ('Honda', 'Ford')
AND USEDVEH.[mileage] < 50000 OR (INVENTORY.[listed price]/USEDVEH.[blue book value]) <=.9)
;
