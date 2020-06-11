<?php
namespace Dynamo;

use Dynamo\Repository;
use Aws\DynamoDb\DynamoDbClient;

class RepositoryTest extends \PHPUnit_Framework_TestCase
{
    public function testShouldConstruct()
    {
        $repository = new Repository();
        $this->assertInstanceOf('Dynamo\Repository', $repository);
    }

    public function testShouldGetDynamoDbClient()
    {
        $repository = new Repository();
        $result     = $repository->getDynamoDbClient();
        $this->assertInstanceOf('Aws\DynamoDb\DynamoDbClient', $result);
    }
}
