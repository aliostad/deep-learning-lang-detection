import socket 
message = """GET / HTTP/1.1
Host: 127.0.0.1:7777
User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:27.0) Gecko/20100101 Firefox/27.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Cookie: username-127-0-0-1-9999=NjE5MzFmODItZTRkNC00YmUwLTk3MzgtMjFkYTYxNzcwNTA4|1410204760|2a1e9a50122fd3d705a1bc4fde0fa89ebcd8f179; username-127-0-0-1-7777=ODM4OTE1NjYtYzYzZS00M2Y4LThmODItODkzMTI0MWVjNjNh|1410216599|ea41d60e6b2948580126c048de45b6f64fc18495; username-127-0-0-1-777=ZjA4M2RmMTYtOTAxMC00MTI0LWJiN2MtYzQ5MGUzNTVjZDZm|1410217504|a60b8bfe097be705ed38053b4a04aecfe71a677f
Connection: Close
Cache-Control: max-age=0

""".replace("\n","\r\n")
# Connect to the server
webserver_socket = socket.socket()
#webserver_socket.connect(('127.0.0.1', port))
webserver_socket.connect(('google.com', 80))
#webserver_socket.setblocking(1)
print("connected, sending message:")
print(message)
# Send an HTTP request
webserver_socket.send(message)
print("message sent, receiving")

# Get the response (in several parts, if necessary)
response = ""
chunk_size = 1
chunk = webserver_socket.recv(chunk_size)
while chunk:
    response += chunk
    chunk = webserver_socket.recv(chunk_size)
print(response)

