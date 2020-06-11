
    ALTER TABLE JIQuery
        ADD new_sql_query NCLOB;
    UPDATE JIQuery
        SET new_sql_query = sql_query;
    COMMIT;

    ALTER TABLE JIQuery
        MODIFY new_sql_query NOT NULL;

    ALTER TABLE JIQuery
        DROP COLUMN sql_query;
    ALTER TABLE JIQuery
        RENAME COLUMN new_sql_query TO sql_query;

--

    ALTER TABLE JIReportJobParameter
        ADD new_parameter_value BLOB;
    UPDATE JIReportJobParameter
        SET new_parameter_value = parameter_value;
    COMMIT;

    ALTER TABLE JIReportJobParameter
        DROP COLUMN parameter_value;
    ALTER TABLE JIReportJobParameter
        RENAME COLUMN new_parameter_value TO parameter_value;

--

    ALTER TABLE JIOlapUnit
        ADD new_mdx_query NCLOB;
    UPDATE JIOlapUnit
        SET new_mdx_query = mdx_query;
    COMMIT;

    ALTER TABLE JIOlapUnit
        MODIFY new_mdx_query NOT NULL;

    ALTER TABLE JIOlapUnit
        DROP COLUMN mdx_query;
    ALTER TABLE JIOlapUnit
        RENAME COLUMN new_mdx_query TO mdx_query;

--

    ALTER TABLE JIDataType
        RENAME COLUMN maxValue TO max_value;