#!/bin/bash
# $Id: init_model.sh 1594 2007-09-06 16:23:27Z alex $
# This script generates some of the model files used when creating a new "document" module.

if [ $# -ne 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
then
    echo "Usage: $0 <base model name>"
else
    MODEL=$1
    MODEL_MIN=$(echo $1 | tr 'A-Z' 'a-z')
    
    cd ../lib/model/doctrine
   
    # generation of <Model>Archive.class.php 
    cat > ${MODEL}Archive.class.php << EOF
<?php
/**
 * \$Id\$
 */
class ${MODEL}Archive extends Base${MODEL}Archive
{
    public static function find(\$id)
    {
        return sfDoctrine::getTable('${MODEL}Archive')->find(\$id);
    }
}
EOF

    # generation of <Model>ArchiveTable.class.php
    cat > ${MODEL}ArchiveTable.class.php << EOF
<?php
/**
 * \$Id\$
 */
class ${MODEL}ArchiveTable extends Doctrine_Table
{ 
}
EOF

    # generation of <Model>.class.php
    cat > ${MODEL}.class.php << EOF
<?php
/**
 * \$Id\$
 */
class ${MODEL} extends Base${MODEL}
{
}
EOF

    # generation of <Model>I18nArchive.class.php
    cat > ${MODEL}I18nArchive.class.php << EOF
<?php
/**
 * \$Id\$
 */
class ${MODEL}I18nArchive extends Base${MODEL}I18nArchive
{
    public static function find(\$id)
    {
        return sfDoctrine::getTable('${MODEL}I18nArchive')->find(\$id);
    }
}
EOF

    # generation of <Model>I18nArchiveTable.class.php
    cat > ${MODEL}I18nArchiveTable.class.php << EOF
<?php
/**
 * \$Id\$
 */
class ${MODEL}I18nArchiveTable extends Doctrine_Table
{
}
EOF

    # generation of <Model>I18n.class.php
    cat > ${MODEL}I18n.class.php << EOF
<?php
/**
 * \$Id\$
 */
class ${MODEL}I18n extends Base${MODEL}I18n
{
}
EOF

    # generation of <Model>I18nTable.class.php
    cat > ${MODEL}I18nTable.class.php << EOF
<?php
/**
 * \$Id\$
 */
class ${MODEL}I18nTable extends Doctrine_Table
{
}
EOF

    # generation of <Model>Table.class.php
    cat > ${MODEL}Table.class.php << EOF
<?php
/**
 * \$Id\$
 */
class ${MODEL}Table extends Doctrine_Table
{
}
EOF

    echo "Generated model files for model $MODEL"

    # generation of Base<Model>.class.php
    cat > generated/Base${MODEL}.class.php << EOF
<?php
/**
 * \$Id\$
 */

class Base${MODEL} extends BaseDocument
{
    public function setTableDefinition()
    {
        parent::setTableDefinition();

        \$this->setTableName('${MODEL_MIN}s');
    }

    public function setUp()
    {
        \$this->hasMany('${MODEL}I18n as ${MODEL}I18n', array('local' => 'id', 'foreign' => 'id'));
        \$this->hasI18nTable('${MODEL}I18n', 'culture');
    }
}
EOF

    # generation of Base<Model>Archive.class.php
    cat > generated/Base${MODEL}Archive.class.php << EOF
<?php
/**
 * \$Id\$
 */

class Base${MODEL}Archive extends BaseDocumentArchive
{
    public function setTableDefinition()
    {
        parent::setTableDefinition();

        \$this->setTableName('app_${MODEL_MIN}s_archives');

        \$this->hasColumn('${MODEL_MIN}_archive_id', 'integer', 11);
    }

    public function setUp()
    {
        \$this->hasOne('DocumentVersion as document_version', 'DocumentVersion.document_archive_id');
    }
}
EOF

    # generation of Base<Model>I18n.class.php
    cat > generated/Base${MODEL}I18n.class.php << EOF
<?php
/**
 * \$Id\$
 */

class Base${MODEL}I18n extends BaseDocumentI18n
{
    public function setTableDefinition()
    {
        parent::setTableDefinition();

        \$this->setTableName('${MODEL_MIN}s_i18n');
    }

    public function setUp()
    {
        \$this->ownsOne('${MODEL} as ${MODEL}', '${MODEL}I18n.id');
    }
}
EOF

    # generation of Base<Model>I18nArchive.class.php
    cat > generated/Base${MODEL}I18nArchive.class.php << EOF
<?php
/**
 * \$Id\$
 */

class Base${MODEL}I18nArchive extends BaseDocumentI18nArchive
{
    public function setTableDefinition()
    {
        parent::setTableDefinition();

        \$this->setTableName('app_${MODEL_MIN}s_i18n_archives');

        \$this->hasColumn('${MODEL_MIN}_i18n_${MODEL_MIN}_id', 'integer', 11);
    }

    public function setUp()
    {
        \$this->hasOne('User as userI18n', '${MODEL}I18nArchive.user_id_i18n');
    }
}
EOF

    echo "Generated base files for model $MODEL"

fi
