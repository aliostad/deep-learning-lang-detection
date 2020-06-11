<?php
namespace FifteenPuzzle\MainBundle\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * @ORM\Entity
 * @ORM\Table(name="user")
 */
class User 
{
    /**
     * @ORM\Column(type="string", length=16)
     * @ORM\Id
     */
    protected $id;

    /**
     * @ORM\Column(type="text")
     */
    protected $save;

    /**
     * Get id
     *
     * @return string 
     */
    public function getId()
    {
        return $this->id;
    }

    /**
     * Set save
     *
     * @param string $save
     * @return User
     */
    public function setSave($save)
    {
        $this->save = $save;

        return $this;
    }

    /**
     * Get save
     *
     * @return string (JSON)
     */
    public function getSave()
    {
        return $this->save;
    }

    /**
     * Set id
     *
     * @param string $id
     * @return User
     */
    public function setId($id)
    {
        $this->id = $id;

        return $this;
    }
}
