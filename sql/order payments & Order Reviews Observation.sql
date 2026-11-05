LOAD DATA LOCAL INFILE
'C:/Users/hp/Downloads/Olist/olist_order_payments_dataset.csv'
INTO TABLE order_payments
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE
'C:/Users/hp/Downloads/Olist/olist_order_reviews_dataset.csv'
INTO TABLE order_reviews
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

#check total reviews
SELECT COUNT(*) AS total_reviews
FROM order_reviews;

#Investigate missing review information
SELECT
    COUNT(*) AS total_reviews,

    SUM(review_comment_title IS NULL)
        AS missing_titles,

    SUM(review_comment_message IS NULL)
        AS missing_messages,

    SUM(review_score IS NULL)
        AS missing_scores

FROM order_reviews;

#Check some review records
SELECT *
FROM order_reviews
LIMIT 10;

#investigate the empty comments
SELECT
    COUNT(*) AS total_reviews,

    SUM(review_comment_title = '')
        AS empty_titles,

    SUM(review_comment_message = '')
        AS empty_messages,

    SUM(review_comment_title = ''
        AND review_comment_message = '')
        AS both_empty

FROM order_reviews;

#check review scores
SELECT
    review_score,
    COUNT(*) AS number_of_reviews
FROM order_reviews
GROUP BY review_score
ORDER BY review_score;

#check missing record
SELECT
    COUNT(DISTINCT review_id) AS unique_review_ids,
    COUNT(DISTINCT order_id) AS unique_order_ids
FROM order_reviews;

#Check duplicate review IDs
SELECT
    review_id,
    COUNT(*) AS occurrences
FROM order_reviews
GROUP BY review_id
HAVING COUNT(*) > 1
ORDER BY occurrences DESC
LIMIT 10;

#Check whether duplicate reviews are identical
SELECT
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    COUNT(*) AS occurrences
FROM order_reviews
GROUP BY
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message
HAVING COUNT(*) > 1
LIMIT 10;

#investigate one duplicate review ID
SELECT *
FROM order_reviews
WHERE review_id = '08528f70f579f0c830189efc523d2182';

#Calculate average customer rating
SELECT
    ROUND(AVG(review_score), 2) AS average_rating,

    ROUND(
        SUM(CASE WHEN review_score >= 4
        THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2
    ) AS positive_review_percentage,

    ROUND(
        SUM(CASE WHEN review_score <= 2
        THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2
    ) AS negative_review_percentage

FROM order_reviews;

#Widespread of duplicate review groups
SELECT
    COUNT(*) AS duplicate_review_groups
FROM (
    SELECT review_id
    FROM order_reviews
    GROUP BY review_id
    HAVING COUNT(*) > 1
) AS duplicates;

SELECT
    MAX(review_count) AS maximum_occurrences
FROM (
    SELECT COUNT(*) AS review_count
    FROM order_reviews
    GROUP BY review_id
) AS review_groups;

#Order reviews
#Data Quality Finding: Duplicate Review Identifiers
#An investigation of the Olist order reviews table identified 789 review IDs occurring more than once.
#A sample investigation revealed that one review ID appeared three times against three different orders, with identical review scores, comments and timestamps.
#Analytical implication: Counting distinct review IDs would produce a different result from counting review records or orders. The appropriate counting method should depend on the business question.
#Recommended action: Investigate repeated identifiers and preserve the original records until their source and meaning are understood.