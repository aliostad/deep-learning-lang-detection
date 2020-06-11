<?php

namespace Album\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * TblShowArt
 *
 * @ORM\Table(name="tbl_show_art")
 * @ORM\Entity
 */
class TblShowArt
{
    /**
     * @var integer
     *
     * @ORM\Column(name="show_id", type="integer", nullable=false)
     * @ORM\Id
     * @ORM\GeneratedValue(strategy="IDENTITY")
     */
    private $showId;

    /**
     * @var string
     *
     * @ORM\Column(name="show_name", type="string", length=200, nullable=false)
     */
    private $showName;

    /**
     * @var string
     *
     * @ORM\Column(name="show_category", type="string", length=200, nullable=false)
     */
    private $showCategory;

    /**
     * @var \DateTime
     *
     * @ORM\Column(name="show_startdate", type="date", nullable=true)
     */
    private $showStartdate;

    /**
     * @var \DateTime
     *
     * @ORM\Column(name="show_enddate", type="date", nullable=true)
     */
    private $showEnddate;

    /**
     * @var \DateTime
     *
     * @ORM\Column(name="show_createdate", type="date", nullable=true)
     */
    private $showCreatedate;

    /**
     * @var \DateTime
     *
     * @ORM\Column(name="show_modifiydate", type="date", nullable=true)
     */
    private $showModifiydate;

    /**
     * @var \Album\Entity\TblGalleries
     *
     * @ORM\ManyToOne(targetEntity="Album\Entity\TblGalleries")
     * @ORM\JoinColumns({
     *   @ORM\JoinColumn(name="gal_id", referencedColumnName="gal_id")
     * })
     */
    private $gal;

    /**
     * @var \Album\Entity\TblScreenUsers
     *
     * @ORM\ManyToOne(targetEntity="Album\Entity\TblScreenUsers")
     * @ORM\JoinColumns({
     *   @ORM\JoinColumn(name="sur_id", referencedColumnName="sur_id")
     * })
     */
    private $sur;



    /**
     * Get showId
     *
     * @return integer 
     */
    public function getShowId()
    {
        return $this->showId;
    }

    /**
     * Set showName
     *
     * @param string $showName
     * @return TblShowArt
     */
    public function setShowName($showName)
    {
        $this->showName = $showName;
    
        return $this;
    }

    /**
     * Get showName
     *
     * @return string 
     */
    public function getShowName()
    {
        return $this->showName;
    }

    /**
     * Set showCategory
     *
     * @param string $showCategory
     * @return TblShowArt
     */
    public function setShowCategory($showCategory)
    {
        $this->showCategory = $showCategory;
    
        return $this;
    }

    /**
     * Get showCategory
     *
     * @return string 
     */
    public function getShowCategory()
    {
        return $this->showCategory;
    }

    /**
     * Set showStartdate
     *
     * @param \DateTime $showStartdate
     * @return TblShowArt
     */
    public function setShowStartdate($showStartdate)
    {
        $this->showStartdate = $showStartdate;
    
        return $this;
    }

    /**
     * Get showStartdate
     *
     * @return \DateTime 
     */
    public function getShowStartdate()
    {
        return $this->showStartdate;
    }

    /**
     * Set showEnddate
     *
     * @param \DateTime $showEnddate
     * @return TblShowArt
     */
    public function setShowEnddate($showEnddate)
    {
        $this->showEnddate = $showEnddate;
    
        return $this;
    }

    /**
     * Get showEnddate
     *
     * @return \DateTime 
     */
    public function getShowEnddate()
    {
        return $this->showEnddate;
    }

    /**
     * Set showCreatedate
     *
     * @param \DateTime $showCreatedate
     * @return TblShowArt
     */
    public function setShowCreatedate($showCreatedate)
    {
        $this->showCreatedate = $showCreatedate;
    
        return $this;
    }

    /**
     * Get showCreatedate
     *
     * @return \DateTime 
     */
    public function getShowCreatedate()
    {
        return $this->showCreatedate;
    }

    /**
     * Set showModifiydate
     *
     * @param \DateTime $showModifiydate
     * @return TblShowArt
     */
    public function setShowModifiydate($showModifiydate)
    {
        $this->showModifiydate = $showModifiydate;
    
        return $this;
    }

    /**
     * Get showModifiydate
     *
     * @return \DateTime 
     */
    public function getShowModifiydate()
    {
        return $this->showModifiydate;
    }

    /**
     * Set gal
     *
     * @param \Album\Entity\TblGalleries $gal
     * @return TblShowArt
     */
    public function setGal(\Album\Entity\TblGalleries $gal = null)
    {
        $this->gal = $gal;
    
        return $this;
    }

    /**
     * Get gal
     *
     * @return \Album\Entity\TblGalleries 
     */
    public function getGal()
    {
        return $this->gal;
    }

    /**
     * Set sur
     *
     * @param \Album\Entity\TblScreenUsers $sur
     * @return TblShowArt
     */
    public function setSur(\Album\Entity\TblScreenUsers $sur = null)
    {
        $this->sur = $sur;
    
        return $this;
    }

    /**
     * Get sur
     *
     * @return \Album\Entity\TblScreenUsers 
     */
    public function getSur()
    {
        return $this->sur;
    }
}
