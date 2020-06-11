<?php
namespace Hat\Environment\Handler\Request;

use Hat\Environment\Handler\Handler;

use Hat\Environment\Handler\ProfileHandler;

class HandleProfileHandler extends Handler
{
    /**
     * @var \Hat\Environment\Handler\ProfileHandler
     */
    protected $handler;

    public function __construct(ProfileHandler $handler)
    {
        $this->handler = $handler;
    }

    public function supports($request)
    {
        return $request->has('profile');
    }

    protected function doHandle($request)
    {
        return $this->handler->handlePath($request->get('profile'));
    }

}
