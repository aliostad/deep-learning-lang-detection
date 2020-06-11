app = Router()
app.add_route('/', controller='controllers:index')
app.add_route('/{year:\d\d\d\d}/',
              controller='controllers:archive')
app.add_route('/{year:\d\d\d\d}/{month:\d\d}/',
              controller='controllers:archive')
app.add_route('/{year:\d\d\d\d}/{month:\d\d}/{slug}',
              controller='controllers:view')
app.add_route('/post', controller='controllers:post')


if __name__ == '__main__':
    from paste import httpserver
    httpserver.serve(app, host='127.0.0.1', port=8080)