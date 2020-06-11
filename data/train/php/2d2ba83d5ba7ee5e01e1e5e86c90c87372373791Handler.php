<?php
namespace Chobie\Net\IRC\Server;

use Chobie\Net\IRC\Server\Handler\HandlerCap;
use Chobie\Net\IRC\Server\Handler\HandlerError;
use Chobie\Net\IRC\Server\Handler\HandlerIson;
use Chobie\Net\IRC\Server\Handler\HandlerJoin;
use Chobie\Net\IRC\Server\Handler\HandlerMode;
use Chobie\Net\IRC\Server\Handler\HandlerNick;
use Chobie\Net\IRC\Server\Handler\HandlerPart;
use Chobie\Net\IRC\Server\Handler\HandlerPing;
use Chobie\Net\IRC\Server\Handler\HandlerPong;
use Chobie\Net\IRC\Server\Handler\HandlerPrivMsg;
use Chobie\Net\IRC\Server\Handler\HandlerQuit;
use Chobie\Net\IRC\Server\Handler\HandlerUser;
use Chobie\Net\IRC\Server\Handler\HandlerWho;

class Handler
{
    use HandlerPrivMsg;
    use HandlerNick;
    use HandlerUser;
    use HandlerJoin;
    use HandlerPart;
    use HandlerQuit;
    use HandlerError;
    use HandlerMode;
    use HandlerWho;
    use HandlerPing;
    use HandlerPong;
    use HandlerCap;
    use HandlerIson;
}