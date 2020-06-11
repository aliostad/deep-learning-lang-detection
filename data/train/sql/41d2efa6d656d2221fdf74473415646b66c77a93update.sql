SET search_path TO xml;

-- Write functions using the descendant axe...

create table a (i int, data doc, targ_path xml.path, new_node node, add_mode add_mode);

insert into a values
(1, '<root><x><b><test1/><x><b><test2/></b></x></b><a><b><test3/></b><d/></a></x></root>', '/root//x/b', '<new/>', 'r'),
(2, '<root><x><c><test1/><x><b><test2/></b></x></c><a><b><test3/></b><d/></a></x></root>', '/root//x/b', '<new/>', 'b'),
(3, '<root><x><b><test1/><x><b><test2/></b></x></b><a><b><test3/></b><d/></a></x></root>', '/root//x/b', '<new/>', 'a'),
(4, '<root><x><b><test1/><x><b><test2/></b></x></b><a><b><test3/></b><d/></a></x></root>', '/root//x//b', '<new/>', 'r'),
(5, '<root><x><b><test1/><x><b><test2/></b></x></b><a><b><test3/></b><d/></a></x></root>', '/root//x//b', '<new/>', 'a'),
(6, '<root><x><b><test1/><x><b><test2/></b></x></b><a><b><test3/></b><d/></a></x></root>', '//x//b', '<new/>', 'r'),
(7, '<root><x><b><test1/><x><b><test2/></b></x></b><a><b><test3/></b><d/></a></x></root>', '//x//b', '<new/>', 'a'),
(8, '<root><x><c><test1/><x><b><test2/></b></x></c><a><b><test3/></b><d/></a></x></root>', '/root//x/b', '<new/>', 'i');

-- Specifically, addition must not take place multiple times for the same node. 
insert into a values
(9, '<root><x><c><test1/><x><b><test2/></b></x></c><a><b><test3/></b><d/></a></x></root>', '/root//x//b', '<new/>', 'b'),
(8, '<root><x><b><test1/><x><b><test2/></b></x></b><a><b><test3/></b><d/></a></x></root>', '/root//x//b', '<new/>', 'i'),
(10, '<root><x><c><test1/><x><b><test2/></b></x></c><a><b><test3/></b><d/></a></x></root>', '//x//b', '<new/>', 'b'),
(11, '<root><x><b><test1/><x><b><test2/></b></x></b><a><b><test3/></b><d/></a></x></root>', '//x//b', '<new/>', 'i'),
(12, '<root><x><a/><b/><b><c/></b><x><b i="1"/></x><b/></x></root>', '/root//x//b', '<n/>', 'i');

select node_debug_print(data), targ_path, add_mode, new_node, node_debug_print(xml.add(data, targ_path, new_node, add_mode))
from a
order by a.i;


-- Add a node that matches the xpath.

update a set new_node='<b/>';

select node_debug_print(data), targ_path, add_mode, new_node, node_debug_print(xml.add(data, targ_path, new_node, add_mode))
from a
order by a.i;

-- Add a subtree that contains matching nodes (i.e.  infinite recursion could take place).

update a set new_node='<x><b><x/></b></x>';

select node_debug_print(data), targ_path, add_mode, new_node, node_debug_print(xml.add(data, targ_path, new_node, add_mode))
from a
order by a.i;

-- Similar to the previous one, just a document fragment is added instead of a single (though compound) node.

update a set new_node='<x><b><x/></b></x><b><x><b/></x></b>';

select node_debug_print(data), targ_path, add_mode, new_node, node_debug_print(xml.add(data, targ_path, new_node, add_mode))
from a
order by a.i;

-- And finally test node removal

drop table a;
create table a (i int, data doc, targ_path xml.path);

insert into a values 
(1, '<root><x><b><test1/><x><b><test2/></b></x></b><a><b><test3/></b><d/></a></x></root>', '/root/x/b'),
(2, '<root><x><b><test1/><x><b><test2/></b></x></b><a><b><test3/></b><d/></a></x></root>', '/root//x/b'),
(3, '<root><x><c><test1/><x><b><test2/></b></x></c><a><b><test3/></b><d/></a></x></root>', '/root//x/b'),
(4, '<root><x><c><test1/><b><test2/></b></c><a><b><test3/></b><d/></a><b/></x></root>', '/root//x//b'), 
(5, '<root><x><c><test1/><b><test2/></b></c><a><b><test3/></b><d/></a><b/><b/></x></root>', '/root//x//b'),
(6, '<root><x><c><test1/><b><test2/></b></c><a><b><test3/></b><d/></a><b i="1"/><b/></x></root>', '/root//x//b'),
(7, '<root><x><c><test1/><b><test2/></b></c><a><b><test3/></b><d/></a><b i="1"/><b i="2"/></x></root>', '/root//x//b'),
(8, '<root><x><c><test1/><b><test2/></b></c><a><b><test3/></b><d/></a><b><c/></b><b><c/></b></x></root>', '/root//x//b'),
(9, '<a><b d="1" id="1" /><b d="2" id="2"/></a>', '/a/b//@id'),
(10, '<a><b d="1" id="1" /><b d="2" id="2"/></a>', '//@id'),
(11, '<a><b d="1" id="1" /><b d="2" id="2"/></a>', '//@*');

select node_debug_print(data), targ_path, node_debug_print(xml.remove(data, targ_path))
from a
order by a.i;

drop table a;

select xml.remove('<a><b><c/><c/></b><b><c/><c/></b></a>', '/a/b/c');


select xml.add(
'<a><!--Special case to test addition of a new node to first position. The target nodes subtree must not be ignored when 
estimating the maxium child offset (and thus the byte width). --></a>',
'/a',
'<!--xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-->',
'b'
);

-- Namespaces need to be checked here:
select xml.add('<a xmlns:x="nmsp_1"/>', '/a', '<x:b/>', 'i');

