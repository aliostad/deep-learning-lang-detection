

def cleandata(string1, number):
    from test1.models import edgedata,locationtopicdata,locationtimedata
    if str(string1)=="week":
        if number==0:
            for edge in edgedata.objects.all():
                edge.week1=0;
                edge.save();
            for edge in locationtopicdata.objects.all():
                edge.week1=0;
                edge.save();
            for edge in locationtimedata.objects.all():
                edge.week1=0;
                edge.save();
        if number==1:
            for edge in edgedata.objects.all():
                edge.week2=0;
                edge.save();
            for edge in locationtopicdata.objects.all():
                edge.week2=0;
                edge.save();
            for edge in locationtimedata.objects.all():
                edge.week2=0;
                edge.save();
        if number==2:
            for edge in edgedata.objects.all():
                edge.week3=0;
                edge.save();
            for edge in locationtopicdata.objects.all():
                edge.week3=0;
                edge.save();
            for edge in locationtimedata.objects.all():
                edge.week3=0;
                edge.save();
        if number==3:
            for edge in edgedata.objects.all():
                edge.week4=0;
                edge.save();
            for edge in locationtopicdata.objects.all():
                edge.week4=0;
                edge.save();
            for edge in locationtimedata.objects.all():
                edge.week4=0;
                edge.save();
    if str(string1)=="month":
        if number==0:
            for edge in edgedata.objects.all():
                edge.month1=0;
                edge.save();
            for edge in locationtopicdata.objects.all():
                edge.month1=0;
                edge.save();
            for edge in locationtimedata.objects.all():
                edge.month1=0;
                edge.save();
        if number==1:
            for edge in edgedata.objects.all():
                edge.month2=0;
                edge.save();
            for edge in locationtopicdata.objects.all():
                edge.month2=0;
                edge.save();
            for edge in locationtimedata.objects.all():
                edge.month2=0;
                edge.save();
        if number==2:
            for edge in edgedata.objects.all():
                edge.month3=0;
                edge.save();
            for edge in locationtopicdata.objects.all():
                edge.month3=0;
                edge.save();
            for edge in locationtimedata.objects.all():
                edge.month3=0;
                edge.save();
        if number==3:
            for edge in edgedata.objects.all():
                edge.month4=0;
                edge.save();
            for edge in locationtopicdata.objects.all():
                edge.month4=0;
                edge.save();
            for edge in locationtimedata.objects.all():
                edge.month4=0;
                edge.save();