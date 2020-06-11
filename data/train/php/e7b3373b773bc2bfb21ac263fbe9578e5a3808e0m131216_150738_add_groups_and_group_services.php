<?php

class m131216_150738_add_groups_and_group_services extends CDbMigration
{
	public function safeUp()
	{
        $this->insert(
             's_service_group',
                 array(
                      'id'   => 1,
                      'name' => 'Standard',
                 )
        );

        $this->insert(
             's_service_group',
                 array(
                      'id'   => 2,
                      'name' => 'Media',
                 )
        );

        $this->insert(
             's_service_group_service',
                 array(
                      'service_group_id'   => 1,
                      'service_id' => 1
                 )
        );

        $this->insert(
             's_service_group_service',
                 array(
                      'service_group_id'   => 1,
                      'service_id' => 2
                 )
        );

        $this->insert(
             's_service_group_service',
                 array(
                      'service_group_id'   => 1,
                      'service_id' => 3
                 )
        );

        $this->insert(
             's_service_group_service',
                 array(
                      'service_group_id'   => 1,
                      'service_id' => 4
                 )
        );

        $this->insert(
             's_service_group_service',
                 array(
                      'service_group_id'   => 2,
                      'service_id' => 5
                 )
        );

        $this->insert(
             's_service_group_service',
                 array(
                      'service_group_id'   => 2,
                      'service_id' => 6
                 )
        );

        $this->insert(
             's_service_group_service',
                 array(
                      'service_group_id'   => 2,
                      'service_id' => 7
                 )
        );

        $this->insert(
             's_service_group_service',
                 array(
                      'service_group_id'   => 2,
                      'service_id' => 8
                 )
        );
	}

	public function safeDown()
	{
        $this->execute('SET foreign_key_checks = 0');
        $this->truncateTable( 's_service_group' );
        $this->truncateTable( 's_service_group_service' );
        $this->execute('SET foreign_key_checks = 1');
	}
}