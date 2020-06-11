



"""
@api {get} /notes Request User's notes
@apiVersion 0.1.0
@apiName Notes List
@apiGroup Notes

@apiParam {String} q search query.

@apiSuccess (200) {Object[]} notes          notes list
@apiSuccess (200) {String}   notes.message  notes message
@apiSuccessExample {json} Success-Response:
     HTTP/1.1 200 OK
     [
       {
         "message": "Hello"
       },
       {
         "message": "Hello"
       }
     ]
"""
def get_notes():
    pass

"""
@api {put} /notes Update User's notes
@apiVersion 0.1.0
@apiName Update Notes
@apiGroup Notes

@apiParam {String} messsage  note message
@apiParamExample {json} Request-Example:
    {
        "message": "Hello"
    }

@apiSuccess (200) {Object} result          result message
@apiSuccess (200) {String} result.message  put result
@apiSuccessExample {json} Success-Response:
     HTTP/1.1 200 OK
     {
       "status": "updated"
     }
"""
def put_notes():
    pass

"""
@api {get} /users Request User's List
@apiVersion 0.1.0
@apiName Users List
@apiGroup Users

@apiParam {String} q search query.

@apiSuccess (200) {Object[]} users       users list
@apiSuccess (200) {String}   users.name  user's name
@apiSuccessExample {json} Success-Response:
     HTTP/1.1 200 OK
     [
       {
         "name": "tom"
       },
       {
         "name": "sam"
       }
     ]
"""
def get_users():
    pass
