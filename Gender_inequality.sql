
SELECT *
FROM occupation_category

-- Occupation with the Highest Female Share

select occupation, female_share
from occupation_category
order by female_share desc
limit 1;

--  Occupation with the Highest Male Share

select occupation, male_share
from occupation_category
order by Male_share desc
limit 1;

-- Occupation with the Largest Gender Gap

select occupation, ABS( Male_share - female_share) as gender_gap
from occupation_category
order by gender_gap desc
limit 1;

-- Occupations Where Female Share is Greater Than Male Share

select occupation, female_share, Male_share
from occupation_category
where female_share > male_share;

-- Occupations Where male Share is Greater Than female Share

select occupation, female_share, Male_share
from occupation_category
where male_share > female_share

select occupation, female_share, Male_share,(male_share - female_share) as difference
from occupation_category
order by difference desc
limit 10


-- Locations with Equal Gender Share

Select occupation, female_share, male_share
From occupation_category
WHERE ABS(female_share - male_share) < 2;

SELECT occupation, female_share, male_share, (female_share - male_share) AS difference
FROM occupation_category
WHERE female_share > male_share
ORDER BY difference DESC
LIMIT 15;


CREATE TABLE occupation_earnings (
    occupation VARCHAR(255),
    women_earnings INT,
    men_earnings INT
);


-- Create the occupation table

CREATE TABLE Wage_gap (
    occupation VARCHAR(255),
    women_earnings INT,
    men_earnings INT
);

-- Insert the data into the occupation table

INSERT INTO Wage_gap (occupation, women_earnings, men_earnings) VALUES  
('Registered nurses', 1274, 1437), 
('Elementary and middle school teachers', 1138, 1301), 
('Secretaries and administrative assistants, except legal, medical, and executive', 807, 1006), 
('Nursing assistants', 615, 740), 
('Receptionists and information clerks', 674, 796), 
('Office clerks, general', 726, 823), 
('Customer service representatives', 737, 867), 
('Teaching assistants', 641, 639), 
('Cashiers', 513, 520), 
('Maids and housekeeping cleaners', 529, 622), 
('Bookkeeping, accounting, and auditing clerks', 802, 1009), 
('Personal care aides', 598, 666), 
('First-line supervisors of office and administrative support workers', 913, 1184), 
('Social workers, all other', 1049, 1232), 
('Medical assistants', 668, 980), 
('Human resources workers', 1212, 1411), 
('Medical and health services managers', 1363, 1773);


CREATE TABLE occupation_mapping (
    id INT AUTO_INCREMENT PRIMARY KEY,
    occupation_category VARCHAR(255) NOT NULL,
    wage_gap VARCHAR(255) NOT NULL
);


INSERT INTO occupation_mapping (occupation_category, wage_gap) VALUES 
    ('Health Services Managers', 'Medical and health services managers'),
    ('Aged Care Services Managers', 'First-line supervisors of office and administrative support workers'),
    ('Nursing Professionals', 'Registered nurses'),
    ('Midwifery Professionals', 'Nursing assistants'),
    ('Primary School Teachers', 'Elementary and middle school teachers'),
    ('Early Childhood Educators', 'Elementary and middle school teachers'),
    ('Special Needs Teachers', 'Teaching assistants'),
    ('Social Work and Counselling Professionals', 'Social workers, all other'),
    ('Health Professionals Not Elsewhere Classified', 'Medical assistants'),
    ('Pharmacists', 'First-line supervisors of office and administrative support workers'),
    ('Librarians and Related Information Professionals', 'Secretaries and administrative assistants, except legal, medical, and executive');


SELECT occupation, female_share, male_share
FROM occupation_category
WHERE occupation LIKE '%Health Services Managers%'
   OR occupation LIKE '%Aged Care Services Managers%'
   OR occupation LIKE '%Nursing Professionals%'
   OR occupation LIKE '%Midwifery Professionals%'
   OR occupation LIKE '%Primary School Teachers%'
   OR occupation LIKE '%Early Childhood Educators%'
   OR occupation LIKE '%Special Needs Teachers%'
   OR occupation LIKE '%Social Work and Counselling Professionals%'
   OR occupation LIKE '%Health Professionals Not Elsewhere Classified%'
   OR occupation LIKE '%Pharmacists%'
   OR occupation LIKE '%Librarians and Related Information Professionals%';


SELECT occupation, women_earnings, men_earnings
FROM wage_gap 
WHERE occupation LIKE '%Medical and health services managers%'
   OR occupation LIKE '%First-line supervisors of office and administrative%'
   OR occupation LIKE '%Registered nurses%'
   OR occupation LIKE '%Nursing assistants%'
   OR occupation LIKE '%Elementary and middle school teachers%'
   OR occupation LIKE '%Teaching assistants%'
   OR occupation LIKE '%Social workers, all other%'
   OR occupation LIKE '%Medical assistants%'
   OR occupation LIKE '%Secretaries and administrative assistants%';

-- earnings gap

select occupation, women_earnings, men_earnings, (men_earnings - women_earnings) as earning_gap
from wage_gap

-- Occupations with the Highest Women's Earnings where women share is dominated in healthcare sector

select occupation, women_earnings, men_earnings
from wage_gap
order by women_earnings desc
limit 5

-- average earnings in women dominated fields

SELECT 
AVG(women_earnings) AS average_women_earnings,
AVG(men_earnings) AS average_men_earnings
FROM wage_gap;
  
-- top 5 industries having highest wage gap in us 

select industry, women_earnings, men_earnings, (men_earnings - women_earnings) as earning_gap
from gender_wage_gap_industry  
order by earning_gap desc  
limit 5

select *
from women_in_stem
limit 1;

select *
from software_developer

select *
from gender_wage_gap_in_tech_industry


CREATE TABLE us_median_earnings_2023 (
    gender VARCHAR(10),
    earnings INT);

INSERT INTO us_median_earnings_2023 (gender, earnings) 
VALUES
('Men', 66790),
('Women', 52850);


-- capitalism target

SELECT *, (Female_percentage - Male_percentage) as difference
FROM social_media_shopping_activities_2023;


SELECT * 
FROM target_sales_share_by_product_segment

SELECT 
    Genders,
    AVG(`South_korea(%)`) AS Avg_South_Korea_Spending,
    AVG(`Thailand(%)`) AS Avg_Thailand_Spending,
    AVG(`China(%)`) AS Avg_China_Spending,
    AVG(`Taiwan(%)`) AS Avg_Taiwan_Spending
FROM popular_items_when_holiday_shopping
GROUP BY Genders;

SELECT 
    Items, 
    Genders, 
    `South_korea(%)`, 
    `Thailand(%)`, 
    `China(%)`, 
    `Taiwan(%)`
FROM popular_items_when_holiday_shopping
ORDER BY `South_korea(%)` DESC, `Thailand(%)` DESC, `China(%)` DESC, `Taiwan(%)` DESC;


SET sql_mode = '';


SELECT 
    w.Items,
    CASE 
        WHEN (w.`South_korea(%)` > m.`South_korea(%)`) +
             (w.`Thailand(%)` > m.`Thailand(%)`) +
             (w.`China(%)` > m.`China(%)`) +
             (w.`Taiwan(%)` > m.`Taiwan(%)`) >= 2 
        THEN 'Women Spend More'
        ELSE 'Men Spend More'
    END AS Dominant_Spender
FROM popular_items_when_holiday_shopping w
JOIN popular_items_when_holiday_shopping m
  ON w.Items = m.Items AND m.Genders = 'Men'
  WHERE w.Genders = 'Women';



SELECT @@sql_mode;

SET sql_mode = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION';


SELECT 
    Genders, 
    AVG(`South_korea(%)`) AS Avg_South_Korea,
    AVG(`Thailand(%)`) AS Avg_Thailand,
    AVG(`China(%)`) AS Avg_China,
    AVG(`Taiwan(%)`) AS Avg_Taiwan
FROM popular_items_when_holiday_shopping
WHERE Items IN ('Consumer electronics', 'Household electronics incl. smart home electronics', 'Furniture and home improvement')
GROUP BY Genders;

SELECT 
    Genders, 
    AVG(`South_korea(%)`) AS Avg_South_Korea,
    AVG(`Thailand(%)`) AS Avg_Thailand,
    AVG(`China(%)`) AS Avg_China,
    AVG(`Taiwan(%)`) AS Avg_Taiwan
FROM popular_items_when_holiday_shopping
WHERE Items IN ('Apparel and footwear', 'Cosmetics and beauty products', 'Jewelry and fashion accessories (e.g. watches, bags, etc)')
GROUP BY Genders;


-- Item Categories with Higher Female Spending Compared to Male Averages
SELECT 
   Items,COUNT(*) AS Categories_Where_Women_Spend_More
FROM popular_items_when_holiday_shopping
WHERE `South_korea(%)` > (SELECT AVG(`South_korea(%)`) FROM popular_items_when_holiday_shopping WHERE Genders = 'Men') 
   OR `Thailand(%)` > (SELECT AVG(`Thailand(%)`) FROM popular_items_when_holiday_shopping WHERE Genders = 'Men') 
   OR `China(%)` > (SELECT AVG(`China(%)`) FROM popular_items_when_holiday_shopping WHERE Genders = 'Men') 
   OR `Taiwan(%)` > (SELECT AVG(`Taiwan(%)`) FROM popular_items_when_holiday_shopping WHERE Genders = 'Men')
   GROUP BY Items;
   
SELECT *
FROM smartphone_users_worldwide;
   
SELECT *, (Female - Male) as difference
FROM annual_healthcare_oop_costs_us_by_gender_in_billion
Order by difference desc ;

-- social causes


SELECT * 
FROM value_of_unpaid_women_work_india
order by Trillion_Indian_rupees asc

SELECT * 
FROM share_us_employees_with_moderatelevels_of_burnout;

SELECT * 
FROM population_in_paid_and_unpaid_activities_in_india;

SELECT * 
FROM global_gender_gap_index;

SELECT * 
FROM `%_of_median_earnings_of_men`;

SELECT * 
FROM us_median_earnings_2023;












