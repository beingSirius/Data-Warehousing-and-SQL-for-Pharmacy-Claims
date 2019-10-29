use final_assignment;

alter table brand_generic_code_dimesion
add primary key (brand_generic_code_id);

alter table drug_form_code_dimension
add primary key (drug_form_code_id);

alter table drug_dimension
add primary key (drug_id);

alter table member_dimension
add primary key (member_id);

alter table drug_dimension
add foreign key drug_form_code_id_fk (drug_form_code_id)
references drug_form_code_dimension (drug_form_code_id)
on delete restrict
on update cascade;

alter table drug_dimension
add foreign key brand_generic_code_id_fk (brand_generic_code_id)
references brand_generic_code_dimesion (brand_generic_code_id)
on delete restrict
on update cascade;

alter table insurance_claim_fact
add foreign key member_id_fk (member_id)
references member_dimension (member_id)
on delete restrict
on update cascade;

alter table insurance_claim_fact
add foreign key drug_id_fk (drug_id)
references drug_dimension (drug_id)
on delete restrict
on update cascade;
-- ---------------------------------------------------------------------------------------------------------------------------------
select count(*) as No_of_prescriptions, b.drug_name  from insurance_claim_fact a inner join drug_dimension b on a.Drug_id=b.drug_id group by a.Drug_id;
-- ---------------------------------------------------------------------------------------------------------------------------------

select  count(distinct (c.member_id)) as no_of_members, count(c.member_id) as no_of_prescriptions, sum(c.copay) as total_copay, sum(c.insurancepaid) as total_insurancepaid,
			case when c.member_age < 65 then "less than 65"
				 else "equal or more than 65" end as age_group from
(select a.*, b.member_age from insurance_claim_fact a inner join member_dimension b on a.member_id = b.member_id) c group by age_group ;

-- -----------------------------------------------------------------------------------------------------------------------------------------

select e.member_id,e.member_first_name,e.member_last_name, e.drug_name,e.Fill_date,e.insurancepaid  from 
(select d.member_id,d.Fill_date,d.insurancepaid ,d.member_first_name, d.member_last_name, d.drug_name, rank() over
(partition by d.member_id order by d.Fill_date desc) as ranking from (select a.member_id,a.Fill_date,a.insurancepaid,
b.member_first_name, b.member_last_name, c.drug_name from insurance_claim_fact a inner join
member_dimension b on a.member_id = b.member_id inner join drug_dimension c on a.Drug_id = c.Drug_id)d)e where e.ranking = 1;
-- -----------------------------------------------------------------------------------------------------------------------------------------

 
 select e.*, rank() over (partition by e.member_id employeesorder by e.Fill_date desc) as RANKING from
(select a.member_id,a.Fill_date,a.insurancepaid,b.member_first_name, b.member_last_name, c.drug_name from insurance_claim_fact a inner join
member_dimension b on a.member_id = b.member_id inner join drug_dimension c on a.Drug_id = c.Drug_id) e ;