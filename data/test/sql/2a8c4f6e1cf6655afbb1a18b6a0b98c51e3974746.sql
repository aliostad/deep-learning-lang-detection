select
	projects.name as project,
	SUM(projects.cost) as profitCompany,
	AvgDeveloper.salaryAVG as avgSalaryForDevelopers
from java6.mtm_customer_project_developer
left join mtm_customer_project
	on mtm_customer_project.customer = mtm_customer_project_developer.customer
    and mtm_customer_project.project = mtm_customer_project_developer.project
left join projects
	on mtm_customer_project.project = projects.id
left join (select 
	mtm_customer_project.customer as customer,
	mtm_customer_project.project as project,
	AVG(developers.salary) as salaryAVG
	from mtm_customer_project_developer
	left join mtm_customer_project
		on mtm_customer_project_developer.customer = mtm_customer_project.customer
        and mtm_customer_project_developer.project = mtm_customer_project.project
	left join developers
		on developers.id = mtm_customer_project_developer.developer
	group by customer, project) as AvgDeveloper
on AvgDeveloper.project = projects.id and AvgDeveloper.customer = mtm_customer_project.customer
group by project
order by profitCompany
limit 1