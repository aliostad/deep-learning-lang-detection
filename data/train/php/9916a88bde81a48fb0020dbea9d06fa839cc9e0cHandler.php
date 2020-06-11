<?php
namespace system\utils;

class Handler implements \Serializable {
  private $handler;
  private $_handler;
  
  public function __construct($handler) {
    $this->handler = $handler;
    if (\is_array($handler)) {
      if (\is_callable($handler)) {
        $this->_handler = $handler;
      } else {
        throw new \system\exceptions\InternalError('Method @class::@method does not exist.', array(
          '@method' => $handler[1], 
          '@class' => $handler[0]
        ));
      }
    }
    elseif (empty($handler)) {
      throw new \system\exceptions\InternalError('Empty handler');
    }
    elseif (is_string($handler)) {
      eval('$this->_handler = ' . $handler . ';');
    }
  }
  
  public function run() {
    return \call_user_func_array($this->_handler, func_get_args());
  }
  
  public function getHandler() {
    return $this->_handler;
  }

  public function serialize() {
    return \serialize($this->handler);
  }

  public function unserialize($serialized) {
    return new self(\unserialize($serialized), $serialized);
  }
}