/*
SQL question prompt:

Samantha interviews many candidates from different colleges using coding challenges and contests. 
Write a query to print the contest_id, hacker_id, name, and the sums of total_submissions, total_accepted_submissions, total_views, 
and total_unique_views for each contest sorted by contest_id. Exclude the contest from the result if all four sums are 0.

Input Format

The following tables hold interview data:

Contests: The contest_id is the id of the contest, hacker_id is the id of the hacker who created the contest, 
and name is the name of the hacker. 

Colleges: The college_id is the id of the college, and contest_id is the id of the contest that Samantha used to screen the candidates. 

Challenges: The challenge_id is the id of the challenge that belongs to one of the contests whose contest_id Samantha forgot, 
and college_id is the id of the college where the challenge was given to candidates. 

View_Stats: The challenge_id is the id of the challenge, total_views is the number of times the challenge was viewed by candidates, 
and total_unique_views is the number of times the challenge was viewed by unique candidates. 

Submission_Stats: The challenge_id is the id of the challenge, total_submissions is the number of submissions for the challenge, 
and total_accepted_submission is the number of submissions that achieved full scores. 

*/

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
