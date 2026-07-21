create database Sql_lesson13

use Sql_lesson13;

--Hometask

CREATE FUNCTION dbo.fn_MonthCalendar
(
    @Year  INT,
    @Month INT
)
RETURNS @Calendar TABLE
(
    Sunday     INT,
    Monday     INT,
    Tuesday    INT,
    Wednesday  INT,
    Thursday   INT,
    Friday     INT,
    Saturday   INT
)
AS
BEGIN

    ;WITH DateSeries AS
    (
        SELECT DATEFROMPARTS(@Year, @Month, 1) AS DateValue
        UNION ALL
        SELECT DATEADD(DAY, 1, DateValue)
        FROM DateSeries
        WHERE DateValue < EOMONTH(DATEFROMPARTS(@Year, @Month, 1))
    ),
    CalendarPrep AS
    (
        SELECT
            DateValue,
            WeekIndex =
                DATEDIFF(
                    WEEK,
                    DATEADD(DAY,
                        -((DATEDIFF(DAY, '19000107',
                            DATEFROMPARTS(@Year, @Month, 1)) % 7)),
                        DATEFROMPARTS(@Year, @Month, 1)
                    ),
                    DateValue
                ),
            WeekDayIndex =
                (DATEDIFF(DAY, '19000107', DateValue) % 7) + 1
        FROM DateSeries
    )
    INSERT INTO @Calendar
    SELECT
        MAX(CASE WHEN WeekDayIndex = 1 THEN DAY(DateValue) END),
        MAX(CASE WHEN WeekDayIndex = 2 THEN DAY(DateValue) END),
        MAX(CASE WHEN WeekDayIndex = 3 THEN DAY(DateValue) END),
        MAX(CASE WHEN WeekDayIndex = 4 THEN DAY(DateValue) END),
        MAX(CASE WHEN WeekDayIndex = 5 THEN DAY(DateValue) END),
        MAX(CASE WHEN WeekDayIndex = 6 THEN DAY(DateValue) END),
        MAX(CASE WHEN WeekDayIndex = 7 THEN DAY(DateValue) END)
    FROM CalendarPrep
    GROUP BY WeekIndex
    ORDER BY WeekIndex;

    RETURN;
END;
GO


SELECT *
FROM dbo.fn_MonthCalendar(2025,12);

--Done
