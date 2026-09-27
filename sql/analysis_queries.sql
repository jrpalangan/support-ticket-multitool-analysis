-- Query for resolution time by priority

SELECT
    ticket_priority,
    COUNT(*) AS total_tickets,
    ROUND(AVG(CASE 
        WHEN EXTRACT(EPOCH FROM (time_to_resolution - first_response_time)) / 3600 >= 0 
        THEN EXTRACT(EPOCH FROM (time_to_resolution - first_response_time)) / 3600 
    END)::numeric, 1) AS avg_handling_time_hours,
    ROUND(AVG(customer_satisfaction_rating), 2) AS avg_satisfaction
FROM tickets
GROUP BY ticket_priority
ORDER BY avg_handling_time_hours DESC;



-- Query for satisfaction by channel
SELECT
    ticket_channel,
    COUNT(*) AS total_tickets,
    ROUND(AVG(customer_satisfaction_rating), 2) AS avg_satisfaction
FROM tickets
GROUP BY ticket_channel
ORDER BY avg_satisfaction DESC;



-- Query for ticket volume by product and ranked
SELECT
    product_purchased,
    COUNT(*) AS total_tickets,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS volume_rank
FROM tickets
GROUP BY product_purchased
ORDER BY volume_rank;



-- Query for High and Critical priority tickets by satisfaction bucket
SELECT
    CASE 
        WHEN customer_satisfaction_rating <= 2 THEN 'At Risk'
        WHEN customer_satisfaction_rating = 3 THEN 'Neutral'
        ELSE 'Satisfied'
    END AS satisfaction_bucket,
    COUNT(*) AS total_tickets
FROM tickets
WHERE ticket_priority IN ('High', 'Critical')
GROUP BY satisfaction_bucket
ORDER BY total_tickets DESC;



--  Query for tickets joined to a priority-weight reference table (using JOIN)
WITH priority_weights (ticket_priority, urgency_score) AS (
    VALUES 
        ('Low', 1),
        ('Medium', 2),
        ('High', 3),
        ('Critical', 4)
)
SELECT
    t.ticket_priority,
    t.ticket_type,
    pw.urgency_score,
    COUNT(*) AS total_tickets
FROM tickets t
JOIN priority_weights pw ON t.ticket_priority = pw.ticket_priority
GROUP BY t.ticket_priority, t.ticket_type, pw.urgency_score
ORDER BY pw.urgency_score DESC, total_tickets DESC;



--  Query for ticket type resolution summary
SELECT
    ticket_type,
    COUNT(*) AS total_tickets,
    SUM(CASE WHEN EXTRACT(EPOCH FROM (time_to_resolution - first_response_time)) / 3600 < 0 THEN 1 ELSE 0 END) AS excluded_negative_rows,
    ROUND(AVG(CASE 
        WHEN EXTRACT(EPOCH FROM (time_to_resolution - first_response_time)) / 3600 >= 0 
        THEN EXTRACT(EPOCH FROM (time_to_resolution - first_response_time)) / 3600 
    END)::numeric, 1) AS avg_handling_time_hours
FROM tickets
GROUP BY ticket_type
ORDER BY avg_handling_time_hours DESC;