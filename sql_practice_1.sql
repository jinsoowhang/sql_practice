select 
    contests.contest_id, 
    contests.hacker_id,
    contests.name,
    sum(submission_sum.sum_submissions) as sum_total_submissions,
    sum(submission_sum.sum_accepted_submissions) as sum_total_accepted_submissions,
    sum(views_sum.sum_views) as sum_total_views,
    sum(views_sum.sum_unique_views) as sum_total_unique_views   
from contests
left join colleges
       on contests.contest_id = colleges.contest_id
left join challenges
       on colleges.college_id = challenges.college_id
       
-- subquery to get total views sum
left join 
(select 
    challenge_id,
    sum(total_views) as sum_views,
    sum(total_unique_views) as sum_unique_views
    from view_stats
    group by challenge_id) as views_sum
on challenges.challenge_id = views_sum.challenge_id

-- subquery to get total submission sum
left join 
(select 
    challenge_id,
    sum(total_submissions) as sum_submissions,
    sum(total_accepted_submissions) as sum_accepted_submissions
    from submission_stats
    group by challenge_id) as submission_sum
on challenges.challenge_id = submission_sum.challenge_id

-- group by contest_id, hacker_id, name
group by contests.contest_id, contests.hacker_id, contests.name 
having (sum_total_submissions +
   sum_total_accepted_submissions +
   sum_total_views +
   sum_total_unique_views) > 0
order by contests.contest_id      
