/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

 insert into zstg_pid_complex_component(pid_complex_id, order_of_complex, pid_component_id, complex_id, component_id) select field1, field2, field3, null, null from zstg_pid_dump where identifier = 'pid_complex_component';
commit;

insert into zstg_pid_comp_partcipant_actst select field1, field2, field3 from zstg_pid_dump where identifier = 'pid_complex_participant_activity_state';
commit;

insert into zstg_pid_compl_participant_loc select field1, field2, field3, field4 from zstg_pid_dump where identifier = 'pid_complex_participant_location';
commit;

insert into zstg_pid_comp_partcipant_ptm select field1, field2, field3 from zstg_pid_dump where identifier = 'pid_complex_participant_ptm';
commit;


update zstg_pid_compl_participant_loc set location = location ||' '|| xref;
update zstg_pid_compl_participant_loc set xref = null;

commit;

insert into zstg_pid_entityaccession select  field1, field2, field3 from zstg_pid_dump where identifier = 'pid_entityaccession';
commit;

insert into zstg_pid_entityname select field1, field2, field3 from zstg_pid_dump where identifier = 'pid_entityname';
commit;

insert into zstg_pid_evidencecode select field1, field2 from zstg_pid_dump where identifier = 'pid_evidencekind';
commit;

insert into zstg_pid_family_member select field1, field2 from zstg_pid_dump where identifier = 'pid_family_member';
commit;


update zstg_pid_dump set field4 =field3 where identifier = 'pid_interactants' and field3 = 'condition';
commit;
update zstg_pid_dump set field3 = null where field3 = 'condition';
commit;

insert into zstg_pid_interactants select field1, field2, field3, field4 from zstg_pid_dump where identifier = 'pid_interactants';
commit;


insert into zstg_pid_interaction select field1, field2, field3 from zstg_pid_dump where identifier = 'pid_interaction';
commit;

insert into zstg_pid_interactionevidence select field1, field2 from zstg_pid_dump where identifier = 'pid_interaction_evidence';
commit;

insert into zstg_pid_intr_partcpant_actst select field1, field3, field4, field5, field2 from zstg_pid_dump where identifier = 'pid_interaction_participant_activity_state';
--insert into zstg_pid_intr_partcpant_actst select field1, field2, field3, field4, null from zstg_pid_dump where identifier = 'pid_interaction_participant_activity_state';
commit;

insert into zstg_pid_intr_partpant_loc select  field1, field3 , field4, field2 from zstg_pid_dump where identifier = 'pid_interaction_participant_location';
--insert into zstg_pid_intr_partpant_loc select  field1, field2 , field3, null from zstg_pid_dump where identifier = 'pid_interaction_participant_location';
commit;

insert into zstg_pid_intr_partcpant_ptm select  field1, field3, field4, field2 from zstg_pid_dump where identifier = 'pid_interaction_participant_ptm';
--insert into zstg_pid_intr_partcpant_ptm select  field1, field2, field3, null from zstg_pid_dump where identifier = 'pid_interaction_participant_ptm';
commit;

update zstg_pid_dump set field4 =field3 where identifier = 'pid_interactioncondition' and field4 is null;
commit;
update zstg_pid_dump set field3 = null where identifier = 'pid_interactioncondition' and field3 = field4;
commit;


insert into zstg_pid_interactionreference select field1, field2 from zstg_pid_dump where identifier = 'pid_interaction_reference';
commit;

--pathwayreference not there

--interactioncondition
insert into zstg_pid_interactioncondition(condition_id, conditionname, xref) select field1, field2, field3 from zstg_pid_dump where identifier = 'pid_interactioncondition';
commit;

insert into zstg_pid_macroprocess_type select field1, field2, field3 from zstg_pid_dump where identifier = 'pid_macroprocess';
commit;

insert into zstg_pid_pathway select field1, field2, field3, field4, null, field5, field6, null from zstg_pid_dump where identifier = 'pid_pathway';
commit;

insert into zstg_pid_pathway_interaction select field1, field2 from zstg_pid_dump where identifier = 'pid_pathway_interaction';
commit;

insert into zstg_pid_physicalentity(physicalentity_id, type) select field1, field2 from zstg_pid_dump where identifier = 'pid_physicalentity';
commit;

insert into zstg_pid_proteinsubunit select field1, field2, field3, field4 from zstg_pid_dump where identifier = 'pid_proteinsubunit';
commit;

insert into zstg_pid_fmly_prtpnt_actst select field1, field2, field3 from zstg_pid_dump where identifier = 'pid_family_participant_activity_state';
commit; 
 
insert into zstg_pid_fmly_prtpnt_ptm select field1, field2, field3 from zstg_pid_dump where identifier = 'pid_family_participant_ptm';
commit; 


--update zstg_pid_dump z set z.FIELD1 = z.identifier where z.IDENTIFIER like '%pid_geneentity%';
--update zstg_pid_dump z set z.FIELD1 = substr(z.field1,instr(z.field1,'y')+1) where z.field1 like '%pid_geneentity%';
commit;
--update zstg_pid_dump z set z.FIELD3 = substr(z.FIELD1, instr(z.FIELD1,'H')) where z.IDENTIFIER like '%pid_geneentity%';
commit;
--update zstg_pid_dump z set z.FIELD1 = substr(z.FIELD1, 0, instr(z.FIELD1,'H')-1) where z.IDENTIFIER like '%pid_geneentity%';
commit;
--update zstg_pid_dump z set z.FIELD2 = substr(z.FIELD1, instr(z.FIELD1,' ')+1) where z.IDENTIFIER like '%pid_geneentity%';
commit;
--update zstg_pid_dump z set z.FIELD2 = substr(z.FIELD1, instr(z.FIELD1,'   ')+1) where z.IDENTIFIER like '%pid_geneentity%';
commit;

--update zstg_pid_dump z set z.FIELD1 = substr(z.FIELD1, 0, instr(z.FIELD1,'   ')-1) where z.IDENTIFIER like '%pid_geneentity%';
commit;

--update zstg_pid_dump z set z.identifier='pid_geneentity' where z.IDENTIFIER like '%pid_geneentity%';
commit;


insert into zstg_pid_geneentity select 'pid_geneentity' as identifier, field1, field3, field2 from zstg_pid_dump where identifier = 'pid_geneentity';
commit;

insert into  zstg_pid_reference_pubmed(reference_id, pubmed_id) select field1, field2 from  zstg_pid_dump where identifier =  'pid_pubmed_reference';

commit;
exit;
