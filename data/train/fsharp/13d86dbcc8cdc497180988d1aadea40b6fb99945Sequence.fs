module import_to_discourse.Test.Sequence

open Discourse.DumpSql.Parse
open NUnit.Framework
open System.Linq
open System.Text.RegularExpressions

[<Test>]
let ``sequence name from table name``() =
    [
        ("ALTER TABLE ONLY posts ALTER COLUMN id SET DEFAULT nextval('posts_id_seq'::regclass);", "posts_id_seq")
        ("ALTER   TABLE   ONLY   posts   ALTER   COLUMN   id   SET   DEFAULT   nextval ( 'posts_id_seq' ::regclass);", "posts_id_seq")
        ("ALTER TABLE ONLY other_posts ALTER COLUMN id SET DEFAULT nextval('posts_id_seq'::regclass);", null)
    ].ToList().ForEach(fun testCase ->
        Assert.AreEqual(
            snd testCase,
            sequenceIdNameFromTableName "posts" [fst testCase]))

[<Test>]
let ``id sequence updated``() =
    let sqlDumpWithSequenceUpdated =
        Discourse.DumpSql.UpdateSequence.withSequenceIdUpdatedForTableName
            "table_name"
            [
                "ALTER TABLE ONLY table_name ALTER COLUMN id SET DEFAULT nextval('table_name_id_seq'::regclass);"

                "COPY table_name (id, optional_column_A, optional_column_B) FROM stdin;"
                "11	-1  f"
                "16	3  t"
                "\."
                "COPY other_table_name (id, optional_column_C) FROM stdin;"
                "111 textcontent"
                "\."
                "COPY table_name (id, optional_column_C) FROM stdin;"
                "33	textcontent"
                "43	textcontent"
                "\."
                "SELECT pg_catalog.setval('table_name_id_seq', 7, true);"
            ]

    let idFromUpdatedDump =
        sqlDumpWithSequenceUpdated
        |> List.pick (fun line ->
            match Regex.Match(line, "pg_catalog.setval\('table_name_id_seq',\s*(?<id>\d+)\s*,") with
            | null -> None
            | rmatch when rmatch.Success -> Some rmatch.Groups.["id"].Value
            | _ -> None)
        
    Assert.AreEqual("44", idFromUpdatedDump)

