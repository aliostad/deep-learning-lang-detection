--name: read-api-json-schema
-- reads in top level json schema api
select data from current_json_schema

--name: fuzzy-search-by-name-for-usc-id
-- reads in all usc_id and lname, fname of faculty from faculty
-- entity.
select usc_id "value", usc_pvid, directory_name || ' <' || usc_id || '>' as "name" from faculty_identities
where directory_name % :q or usc_id like :q ||'%' or employee_id like :q ||'%';

--name: create-gold-file<!
-- creates a gold-file document in the gold_files entity. Returning records.
insert into gold_files (data)
values (:data)

--name: read-gold-files
-- reads all gold-files from gold_files
select * from gold_files

--name: read-gold-files-pending-save-to-laserfiche
-- reads all gold-files that have is-in-laserfiche as nil or false.
--select * from gold_files where is_in_laserfiche is not true

select * from documents() where (repo_data ->> 'saved') = 'false'
or (repo_data->>'saved') is null;

--name: document_update_callback
-- Update gold-file attribute is-in-laserfiche to true
--update gold_files set is_in_laserfiche = true
--where uuid = :uuid
select document_update_callback(:uuid, :data)

--name: create-form-schema
-- creates a form schema that should fit jsonSchema format.
select save_document_schema(:schema, :schema_name)

--name: read-form-schema
-- Read a schema to describe a form or other structured data
select * from form_schemas where table_name = :tablename order by created_at desc

--name: read-form-schema-by-uuid
-- Read a schema to describe a form or other structured data
select * from form_schemas where uuid = :uuid

--name: read-form-schemas
-- read in all form schemas
select * from form_schemas order by created_at desc

--name: save-document
-- saves a json document in tablename
select save_document(:tablename, :data)

--name: read-form-document-by-uuid
-- retrieves json document from :tablename and :uuid if provided.
select * from find_document(:tablename,:uuid::uuid);

--name: read-form-document
-- retrieves json document from :tablename and :uuid if provided.
select * from filter_documents(:tablename)
