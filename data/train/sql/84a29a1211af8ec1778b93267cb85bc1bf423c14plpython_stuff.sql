CREATE OR REPLACE FUNCTION ordered_set(the_list text[])
  RETURNS text[] AS
$BODY$
    ordered_set = []
    for x in the_list:
        if x not in ordered_set:
            ordered_set.append(x)
    return ordered_set
$BODY$
  LANGUAGE plpython2u;

CREATE OR REPLACE FUNCTION array_min(an_array integer[])
  RETURNS integer AS
$BODY$
    if an_array is None:
        return None
    return min(an_array)
$BODY$
  LANGUAGE plpython2u;

CREATE OR REPLACE FUNCTION array_max(an_array integer[])
  RETURNS integer AS
$BODY$
    if an_array is None:
        return None
    return max(an_array)
$BODY$
  LANGUAGE plpython2u;

CREATE OR REPLACE FUNCTION ordered_set(the_list integer[])
  RETURNS integer[] AS
$BODY$
    ordered_set = []
    for x in the_list:
        if x not in ordered_set:
            ordered_set.append(x)
    return ordered_set
$BODY$
  LANGUAGE plpython2u;