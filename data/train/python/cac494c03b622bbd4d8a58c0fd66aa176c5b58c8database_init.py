from base.models import Sublocation, Tag, User, Issue, Solution, Sector

    # - Create model City
    # - Create model Issue
    # - Create model Sector
    # - Create model Skill
    # - Create model Solution
    # - Create model Sublocation
    # - Create model Tag
    # - Create model Timeline
    # - Create model User


s1 = Sector(sector_name='Healthcare');
s2 = Sector(sector_name='Education');
s3 = Sector(sector_name='Civic Technology');
s4 = Tag(tag_name='Disaster Response');
s1.save();
s2.save();
s3.save();
s4.save();

c1 = City(city_name='Delhi');
c2 = City(city_name='Gurgaon');
c3 = City(city_name='Noida');

c1.save();
c2.save();
c3.save();


sb1 = Sublocation(sublocation_name='Saket');
sb2 = Sublocation(sublocation_name='Connaught Place');
sb3 = Sublocation(sublocation_name='Haus Khas Village');
sb1.save();
sb2.save();
sb3.save();

t1 = Tag(tag_name='government schools');
t2 = Tag(tag_name='advertising');
t3 = Tag(tag_name='legal');
t4 = Tag(tag_name='community project');

t1.save();
t2.save();
t3.save();
t4.save();

u1 = User(user_email='arushij@stanford.edu');
u1.save();
u2 = User(user_email='arushijain1993@gmail.com');
u2.save();

sk1 = Skill(skill_name='Information Architecture');
sk2 = Skill(skill_name='Web Development');
sk3 = Skill(skill_name='Photography&Filmography');
sk4 = Skill(skill_name='Brand Management');
sk5 = Skill(skill_name='Content Generation');
sk6 = Skill(skill_name='Stratergy Consulting');

sk1.save();
sk2.save();
sk3.save();
sk4.save();
sk5.save();
sk6.save();

i1 = Issue(issue_text='sample issue', sublocation=Sublocation, tags=[1,2], user='1');;


p2 = Publisher(name="O'Reilly", address='10 Fawcett St.',
    city='Cambridge', state_province='MA', country='U.S.A.',
    website='http://www.oreilly.com/')
    p2.save()
	publisher_list = Publisher.objects.all()
	publisher_list