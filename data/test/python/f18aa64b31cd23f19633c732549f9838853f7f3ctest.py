from models import *

r = Requirement(min=3)
r.save()

# rc = RequirementChild()

r2 = Requirement(min=1)
r2.save()

sr = SubRequirement(real=r2)
sr.save()

d = Dept(did=1,code='HONRS', long_name='Honors')
d.save()
c = Course(num='220R', cid=12390, long_name='something',
        description='a really fun class',
        honors=False, dept=d)
c.save()

sc = SubCourse(real=c)
sc.save()
sc2 = SubCourse()
r.children.add(sr)
r.children.add(sc)

print sr.is_satisfied(False)
print sc.is_satisfied(False)
print r.is_satisfied(False)

# vim: et sw=4 sts=4
