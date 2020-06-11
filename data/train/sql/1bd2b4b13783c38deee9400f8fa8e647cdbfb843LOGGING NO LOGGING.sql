òàáëèöà ñ àñêòîìà

Table Mode    Insert Mode     ArchiveLog mode      result
-----------   -------------   -----------------    ----------
LOGGING       APPEND          ARCHIVE LOG          redo generated
NOLOGGING     APPEND          ARCHIVE LOG          no redo
LOGGING       no append       ""                   redo generated
NOLOGGING     no append       ""                   redo generated
LOGGING       APPEND          noarchive log mode   no redo
NOLOGGING     APPEND          noarchive log mode   no redo
LOGGING       no append       noarchive log mode   redo generated
NOLOGGING     no append       noarchive log mode   redo generated
