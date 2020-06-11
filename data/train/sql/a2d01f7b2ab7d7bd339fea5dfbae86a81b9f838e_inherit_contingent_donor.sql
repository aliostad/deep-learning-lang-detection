---
name: _inherit_contingent_donor
description: |
 Returns all contingent donors for a given user with their priority.

returns: TABLE
returns_columns:
 -
  name: donor
  description: User from which contingents are inherited
  type: user.t_user
 -
  name: priority_list
  type: integer[]
  description:

parameters:
 -
  name: p_owner
  type: user.t_user
---

RETURN QUERY
WITH RECURSIVE contingent_donor(donor, priority_list, cycle_detector) AS
(
   -- cast to varchar, since arrays of t_user are not defined
   SELECT p_owner, ARRAY[]::integer[], ARRAY[CAST(p_owner AS varchar)]

   UNION

   SELECT
    curr.donor,
    prev.priority_list || curr.priority,
    cycle_detector || CAST(curr.donor AS varchar)
   FROM system.inherit_contingent AS curr
    JOIN contingent_donor AS prev
    ON
     prev.donor = curr.owner AND
     curr.donor <> ALL (prev.cycle_detector)
)
SELECT
 contingent_donor.donor,
 array_append(contingent_donor.priority_list, NULL)
FROM contingent_donor
-- Appending the NULL changes the ordering between arrays with different size
ORDER BY array_append(contingent_donor.priority_list, NULL) DESC;
