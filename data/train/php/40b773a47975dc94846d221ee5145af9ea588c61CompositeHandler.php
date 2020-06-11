<?php
namespace Hat\Environment\Handler;

class CompositeHandler extends Handler
{

    /**
     * @var Handler[]
     */
    protected $handlers = array();

    public function addHandler(Handler $handler)
    {
        $this->handlers[] = $handler;
    }

    protected function doHandle($data)
    {

        foreach ($this->handlers as $handler) {
            if ($handler->supports($data)) {
                return $handler->handle($data);
            }
        }

        throw new HandlerException('Can not find handler');

    }

}
