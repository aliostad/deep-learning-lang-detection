#ask user their name, print it to screen and save it to file

def clrList():
    save_file = open("userNames.txt",'w')
    save_file.write("")
    save_file.close()
    print "Saved File has been erased."

def saveNames():
    save_file = open("userNames.txt",'a')
    save_file.write(user_name + '\n')
    save_file.close()
    print "Name Saved"

def openNames():
    save_file = open("userNames.txt",'r')
    saved_names = save_file.readlines()
    for name in saved_names:
        print name.strip()
    save_file.close()


running = True
while running:
    user_name = raw_input("What is your name?")
    if user_name == 'clr':
        clrList()
    
    else:
        print "Hello " + user_name
        saveNames()
        openNames()
    if raw_input("Exit? (y/n)") == 'y':
        running = False

        




