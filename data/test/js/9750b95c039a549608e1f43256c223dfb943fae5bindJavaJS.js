
var myclass = Java.type("nashorn.bindJavaJS")
   ,bjj = new myclass()
   ,obj ={};

print("show init");
bjj.show();
bjj.add(10);
bjj.show();
print("show bjj private : ",bjj.count);

print("show bjj memory : ", bjj);
print("show obj memory : ", obj);

print("bjj binding obj");
Object.bindProperties(obj, bjj);

print("show bjj memory : ", bjj);
print("show obj memory : ", obj);

print("before obj add");
obj.show();
bjj.show();

obj.add(10);
print("after obj add");
obj.show();
bjj.show();


print("before bjj add");
obj.show();
bjj.show();

obj.add(10);
print("after bjj add");
obj.show();
bjj.show();


print("show obj private : ", obj.count);
