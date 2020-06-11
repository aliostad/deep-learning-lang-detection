# errors for the controller
CONTROLLER_ERROR_AUTH_FAIL = -1
CONTROLLER_ERROR_DISCONNECTED = -2
CONTROLLER_ERROR_IN_REMOTE_FUNCTION = -3
CONTROLLER_ERROR_NO_RSA_KEY = -4
CONTROLLER_ERROR_UNKNOWN = -5
CONTROLLER_ERROR_FUNCTION_NOT_FOUND = -6

CONTROLLER_ERROR_MESSAGES = {
            CONTROLLER_ERROR_AUTH_FAIL:'CONTROLLER_ERROR_AUTH_FAIL',
            CONTROLLER_ERROR_DISCONNECTED:'CONTROLLER_ERROR_DISCONNECTED',
            CONTROLLER_ERROR_IN_REMOTE_FUNCTION:'CONTROLLER_ERROR_IN_REMOTE_FUNCTION',
            CONTROLLER_ERROR_NO_RSA_KEY:'CONTROLLER_ERROR_NO_RSA_KEY',
            CONTROLLER_ERROR_UNKNOWN:'CONTROLLER_ERROR_UNKNOWN',
            CONTROLLER_ERROR_FUNCTION_NOT_FOUND:'CONTROLLER_ERROR_FUNCTION_NOT_FOUND'
}


class ControllerException(Exception):
    def __init__(self, code=CONTROLLER_ERROR_UNKNOWN):
        self.code = code
    
    def __repr__(self):
        print 'ControllerException (%s): %s' (self.code, \
                                        CONTROLLER_ERROR_MESSAGES[self.code])


class ControllerRemoteException(ControllerException):
    """
    ControllerException representing an exception in the remote function.  This
    class will output a stacktrace of what went wrong
    """
    def __init__(self, error):
        self.code = CONTROLLER_ERROR_IN_REMOTE_FUNCTION
        self.error = error['exception']
        self.traceback = error['traceback']

    def __repr__(self):
        return 'ControllerRemoteException (%s) :\n%s' % (self.code, \
                                                    ''.join(self.traceback))