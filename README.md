# Support Ticket Analysis — Multi-Tool Deep Dive

In this project, I used the very same customer support ticket dataset (with 8,469 records) which
I've analyzed in three different ways — each tool chosen for the angle it's best suited to.

This complements [support-ticket-dbt-warehouse](https://github.com/jrpalangan/support-ticket-dbt-warehouse), 
which uses this same dataset to demonstrate pipeline/warehouse engineering (dbt + Snowflake). This 
project instead focuses on analytical versatility through ad-hoc querying, exploratory data analysis, and 
interactive visualization.

## Contents
- **[SQL](sql/)** — ad-hoc aggregation and join queries answering direct 
  business questions
- **[Python](python/)** — exploratory data analysis and a classification 
  model predicting low satisfaction ratings
- **[Tableau](tableau/)** — interactive dashboard ([live link](https://public.tableau.com/views/ticket_dashboard/Dashboard1?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link))
