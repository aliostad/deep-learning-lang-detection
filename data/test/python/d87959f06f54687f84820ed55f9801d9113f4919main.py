import sys
from database import *
from imposm.parser import OSMParser


def main():
    if len(sys.argv) != 5:
        print("Usage: dbconnection dbport dbname filename")
        print("example: osmimport-python '127.0.0.1' 28015 'geo' '.download/england-latest.osm.pbf'")

        return

    global dbhost, dbname, dbport
    dbhost = sys.argv[1]
    dbport = sys.argv[2]
    dbname = sys.argv[3]
    filename = sys.argv[4]

    init_db(dbhost, dbport, dbname)
    start_import(filename)


def nodes(nodes_list):
    nodes_to_save = []
    for node in nodes_list:
        node_to_save = {'osm_id': node[0], 'tags': node[1], 'latitude': node[2][0], 'longitude': node[2][1]}
        nodes_to_save.append(node_to_save)

    session = connect(dbhost, dbport)
    save_ways(nodes_to_save, dbname, session)
    close_session(session)


def ways(ways_list):
    ways_to_save = []
    for way in ways_list:
        way_to_save = {'osm_id': way[0], 'tags': way[1], 'refs': way[2]}
        ways_to_save.append(way_to_save)

    session = connect(dbhost, dbport)
    save_ways(ways_to_save, dbname, session)
    close_session(session)


def relations(relations_list):
    relations_to_save = []
    for relation in relations_list:
        relation_to_save = {'osm_id': relation[0], 'tags': relation[1]}
        mem_ids = []
        types = []
        roles = []

        for mem_id, type, role in relation[2]:
            mem_ids.append(mem_id)
            types.append(type)
            roles.append(role)

        relation_to_save['memids'] = mem_ids
        relation_to_save['roles'] = roles
        relation_to_save['types'] = types

        relations_to_save.append(relation_to_save)

    session = connect(dbhost, dbport)
    save_ways(relations_to_save, dbname, session)
    close_session(session)


def start_import(filename):
    parser = OSMParser(concurrency=4, nodes_callback=nodes, ways_callback=ways, relations_callback=relations)
    parser.parse(filename)


if __name__ == '__main__':
    main()
