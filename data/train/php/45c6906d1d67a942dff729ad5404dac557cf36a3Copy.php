<?php
    Class Copy
    {
        private $numberof;
        private $id;

        function __construct($numberof, $id = null)
        {
            $this->numberof = $numberof;
            $this->id = $id;
        }

        function setNumberof($new_numberof)
        {
            $this->numberof = (int) $new_numberof;
        }

        function setId($new_id)
        {
            $this->id = (int) $new_id;
        }

        function getNumberof()
        {
            return $this->numberof;
        }

        function getId()
        {
            return $this->id;
        }

        function save()
        {
            $statement = $GLOBALS['DB']->query("INSERT INTO copies (numberof)
                VALUES ({$this->getNumberof()}) RETURNING id;");
            $result = $statement->fetch(PDO::FETCH_ASSOC);
            $this->setId($result['id']);
        }

        static function getAll()
        {
            $returned_copies = $GLOBALS['DB']->query("SELECT * FROM copies;");
            $copies = array();
            foreach($returned_copies as $copy) {
                $numberof = $copy['numberof'];
                $id = $copy['id'];
                $new_copy = new Copy($numberof, $id);
                array_push($copies, $new_copy);
            }
            return $copies;
        }

        static function find($search_id)
        {
            $found_copy = null;
            $copies = Copy::getAll();
            foreach($copies as $copy) {
                $copy_id = $copy->getId();
                if ($copy_id == $search_id) {
                    $found_copy = $copy;
                }
            }
            return $found_copy;
        }

        

    }
?>
