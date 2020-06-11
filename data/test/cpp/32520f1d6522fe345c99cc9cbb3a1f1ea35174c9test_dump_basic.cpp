#include "DumpTest.hpp"

TEST_F(DumpTest, dump_null_basic) {
    EXPECT_STREQ(
        ""
        ,
        t_cfg_dump(NULL));
}

TEST_F(DumpTest, dump_struct_basic) {
    EXPECT_STREQ(
        "{ a=1\n"
        ", b=2\n"
        "}"
        ,
        dump(
            "a: 1\n"
            "b: 2\n"
            ));
}

TEST_F(DumpTest, dump_struct_item_empty) {
    EXPECT_STREQ(
        "{}"
        ,
        dump("{}"));
}

TEST_F(DumpTest, dump_struct_item_one) {
    EXPECT_STREQ(
        "{ a=1 }"
        ,
        dump(
            "a: 1\n"
            ));
}

TEST_F(DumpTest, dump_sequence_basic) {
    EXPECT_STREQ(
        "[ 1\n"
        ", 2\n"
        "]"
        ,
        dump(
            "- 1\n"
            "- 2\n"
            ));
}

TEST_F(DumpTest, dump_sequence_item_empty) {
    EXPECT_STREQ(
        "[]"
        ,
        dump("[]"));
}

TEST_F(DumpTest, dump_sequence_item_one) {
    EXPECT_STREQ(
        "[ 1 ]"
        ,
        dump(
            "[1]\n"
            ));
}

TEST_F(DumpTest, dump_complex_struct_struct) {
    EXPECT_STREQ(
        "{ a=1\n"
        ", b={ c=2\n"
        "    , d=3\n"
        "    }\n"
        ", e=4\n"
        "}"
        ,
        dump(
            "a: 1\n"
            "b:\n"
            "  c: 2\n"
            "  d: 3\n"
            "e: 4"
            ));
}

TEST_F(DumpTest, dump_complex_struct_seq) {
    EXPECT_STREQ(
        "{ a=1\n"
        ", b=[ 2\n"
        "    , 3\n"
        "    ]\n"
        ", e=4\n"
        "}"
        ,
        dump(
            "a: 1\n"
            "b:\n"
            "  - 2\n"
            "  - 3\n"
            "e: 4"
            ));
}

TEST_F(DumpTest, dump_inline_null_basic) {
    EXPECT_STREQ(
        ""
        ,
        t_cfg_dump_inline(NULL));
}

TEST_F(DumpTest, dump_inline_struct_basic) {
    EXPECT_STREQ(
        "{ a=1, b=2 }"
        ,
        dump_inline(
            "a: 1\n"
            "b: 2\n"
            ));
}

TEST_F(DumpTest, dump_inline_struct_item_empty) {
    EXPECT_STREQ(
        "{}"
        ,
        dump_inline("{}"));
}

TEST_F(DumpTest, dump_inline_struct_item_one) {
    EXPECT_STREQ(
        "{ a=1 }"
        ,
        dump_inline(
            "a: 1\n"
            ));
}

TEST_F(DumpTest, dump_inline_sequence_basic) {
    EXPECT_STREQ(
        "[ 1, 2 ]"
        ,
        dump_inline(
            "- 1\n"
            "- 2\n"
            ));
}

TEST_F(DumpTest, dump_inline_sequence_item_empty) {
    EXPECT_STREQ(
        "[]"
        ,
        dump_inline("[]"));
}

TEST_F(DumpTest, dump_inline_sequence_item_one) {
    EXPECT_STREQ(
        "[ 1 ]"
        ,
        dump_inline(
            "[1]\n"
            ));
}

TEST_F(DumpTest, dump_inline_complex_struct_struct) {
    EXPECT_STREQ(
        "{ a=1, b={ c=2, d=3 }, e=4 }"
        ,
        dump_inline(
            "a: 1\n"
            "b:\n"
            "  c: 2\n"
            "  d: 3\n"
            "e: 4"
            ));
}

TEST_F(DumpTest, dump_inline_complex_struct_seq) {
    EXPECT_STREQ(
        "{ a=1, b=[ 2, 3 ], e=4 }"
        ,
        dump_inline(
            "a: 1\n"
            "b:\n"
            "  - 2\n"
            "  - 3\n"
            "e: 4"
            ));
}
