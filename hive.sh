DROP TABLE Logs;
DROP TABLE Statistic;
CREATE TABLE Logs(str STRING);
CREATE TABLE Statistic(ip STRING,sum INT,avg DOUBLE);
LOAD DATA LOCAL INPATH '000000' OVERWRITE INTO TABLE Logs;
INSERT INTO Statistic 
	SELECT 
		t.ip, 
		SUM(CASE WHEN bytesCount IS NOT NULL THEN bytesCount ELSE 0 END),
		ROUND(AVG(CASE WHEN bytesCount IS NOT NULL THEN bytesCount ELSE 0 END), 2) 
	FROM (
			SELECT 
				   REGEXP_EXTRACT(str,'ip\\d+ ',0) AS ip,
				   CAST(SPLIT(REGEXP_EXTRACT(str,' \\d+ \\d+ ',0),' ')[2] AS DOUBLE) AS bytesCount 
		    FROM Logs) t 
	GROUP BY t.ip;
SELECT * FROM Statistic;