<?php

namespace app\modules\login\action {
    use org\akaPHP\core;
    use \app\lib;

    /**
    * Description of LoginAction
    *
    * @author vgar
    */
    class LoginAction extends core\Controller {
        protected $errMsg;

        /**
         * akaPHP implementation. Handle the request.
         *
         * @param core\Request   $request the request object
         * @param core\AppFacade $facade  the facade object
         *
         * @return void
         */
        protected function handleRequest(core\Request $request, core\AppFacade $facade) {
            if (! $request->isPostBack()) {
                $this->setTemplate('LoginForm');
            } else {
                $email = $request->getParam('email');
                $password = $request->getParam('password');

                $this->user->setEmail($email);

                $this->_checkAuthentification($this->user, $password, $facade);
            }
        }

        protected function handleRequestLogoff(core\Request $request, core\AppFacade $facade) {
            $user = $facade->getUser();
            $user->logOff();
            $facade->redirect('login');
        }

        protected function handleRequestCreate(core\Request $request, core\AppFacade $facade) {
            if (! $request->isPostBack()) {
                $this->setTemplate('LoginCreate');
            } else {
                $user = new lib\User();
                $user->setEmail($request->getParam('email'));
                $success = $user->save($request->getParam('password'));
                if ($success) {
                     $facade->redirect();
                } else {
                    echo 'oups';
                    die();
                }
            }
        }

        /**
         * Helper method to check user authentification.
         *
         * @param lib\User $user the user
         * @param type $password the provided password
         * @param type $facade   the facade object
         *
         * @return void
         */
        private function _checkAuthentification(lib\User $user, $password, $facade) {
            $this->errMsg = '';
            if ($user->authenticate($password)) {
                $facade->redirect('Welcome');
            } else {
                $this->errMsg = 'Login fail. Please try again';
                $this->setTemplate('LoginForm');
            }
        }
    }
}

?>
