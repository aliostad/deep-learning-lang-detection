# Setting up V prototype database in OrientDB

DROP DATABASE remote:localhost/ruby_driver_test root "8F6FB3168FAF265896A3532C83C5E33F8B6A47996229184582D1499D5B3E8C75";

CREATE DATABASE remote:localhost/ruby_driver_test root "8F6FB3168FAF265896A3532C83C5E33F8B6A47996229184582D1499D5B3E8C75" local;

CONNECT remote:localhost/ruby_driver_test admin admin;

CREATE CLUSTER ographvertex PHYSICAL APPEND;
CREATE CLUSTER ographedge PHYSICAL APPEND;

CREATE CLASS OGraphVertex CLUSTER ographvertex;
ALTER CLASS ographvertex SHORTNAME V;

CREATE CLASS OGraphEdge CLUSTER ographedge;
ALTER CLASS ographedge SHORTNAME E;

CREATE PROPERTY OGraphVertex.in LINKSET OGraphEdge;
CREATE PROPERTY OGraphVertex.out LINKSET OGraphEdge;

CREATE PROPERTY OGraphEdge.in LINK OGraphVertex;
CREATE PROPERTY OGraphEdge.out LINK OGraphVertex;

# ----------------------------------------------------------------------
# DATA
# ----------------------------------------------------------------------

INSERT INTO V (label, in, out) VALUES ('User 1', [], []);
INSERT INTO V (label, in, out) VALUES ('User 2', [], []);

INSERT INTO E (label, out, in) VALUES ('follows', #5:0, #5:1);
UPDATE #5:0 ADD out = #6:0;
UPDATE #5:1 ADD in = #6:0;
