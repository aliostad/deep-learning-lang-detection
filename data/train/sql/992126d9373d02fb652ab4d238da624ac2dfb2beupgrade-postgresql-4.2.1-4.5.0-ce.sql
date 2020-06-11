
    ALTER TABLE JIQuery
        ADD COLUMN new_sql_query TEXT;
    UPDATE JIQuery
        SET new_sql_query = sql_query;
    COMMIT;

    ALTER TABLE JIQuery
        ALTER COLUMN new_sql_query SET NOT NULL;

    ALTER TABLE JIQuery
        DROP COLUMN sql_query;
    ALTER TABLE JIQuery
        RENAME COLUMN new_sql_query TO sql_query;

--

    ALTER TABLE JIOlapUnit
        ADD COLUMN new_mdx_query TEXT;
    UPDATE JIOlapUnit
        SET new_mdx_query = mdx_query;
    COMMIT;

    ALTER TABLE JIOlapUnit
        ALTER COLUMN new_mdx_query SET NOT NULL;

    ALTER TABLE JIOlapUnit
        DROP COLUMN mdx_query;
    ALTER TABLE JIOlapUnit
        RENAME COLUMN new_mdx_query TO mdx_query;

--

    ALTER TABLE JIDataType
        RENAME COLUMN maxValue TO max_value;