<?php
namespace Icecave\Lace\Database;

interface DatabaseVisitorInterface
{
    /**
     * Visit the given handler.
     *
     * @param MySqlHandler $handler
     *
     * @return mixed
     */
    public function visitMySqlHandler(MySqlHandler $handler);

    /**
     * Visit the given handler.
     *
     * @param PostgresHandler $handler
     *
     * @return mixed
     */
    public function visitPostgresHandler(PostgresHandler $handler);

    /**
     * Visit the given handler.
     *
     * @param SqliteHandler $handler
     *
     * @return mixed
     */
    public function visitSqliteHandler(SqliteHandler $handler);
}
