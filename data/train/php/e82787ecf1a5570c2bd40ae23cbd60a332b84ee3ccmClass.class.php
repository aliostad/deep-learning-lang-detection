<?php
class ccmClass
{
  const
    SAVE_FORTITUDE  = 'fortitude',
    SAVE_REFLEX     = 'reflex',
    SAVE_WILL       = 'will'
  ;

  protected
    $classname  = null,
    $level      = 1,
    $params     = null
  ;

  public function __construct($classname, $params)
  {
    $this->classname = $classname;
    $this->params    = $params;
  }

  public function getBAB()
  {
    return $this->params['BAB'][$this->level];
  }

  public function getSave($save)
  {
    return $this->params['save'][$save][$this->level];
  }

  public function levelUp()
  {
    $this->level++;
  }
}
