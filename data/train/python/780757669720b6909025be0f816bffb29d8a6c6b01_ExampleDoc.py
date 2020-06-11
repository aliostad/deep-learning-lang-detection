
#ImportModules
import ShareYourSystem as SYS

#Definition 
MyController=SYS.ControllerClass(
		**{
			'FolderingPathStr':SYS.Tabler.LocalFolderPathStr,
			'ControllingModelClassVariable':SYS.TabularerClass
		}
	).get(
		'/-Models/|Things'
	)


#Build a structure with a database
SYS.set(
		MyController['/-Models/|Things'].ModeledMongoCollection,
		[
			('remove',{}),
			('insert',{'MyStr':"hello"})
		]
)

#print
print('mongo db is : \n'+SYS._str(MyController.pymongoview()))

#print
print('MyController is ')
SYS._print(MyController)

#kill
MyController.process(_ActionStr='kill')

