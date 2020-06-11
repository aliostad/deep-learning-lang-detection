from review.models import *

def run():
 n1= node_user(fb_id="34",user_name="joe")
 n1.save()
 n2= node_user(fb_id="35",user_name="sam")
 n2.save()
 n3= node_user(fb_id="36",user_name="john")
 n3.save()
 n4= node_user(fb_id="37",user_name="jeff")
 n4.save()
 n5= node_user(fb_id="38",user_name="tom")
 n5.save()
 n6= node_user(fb_id="39",user_name="ravi")
 n6.save()
 n7= node_user(fb_id="40",user_name="lucky")
 n7.save()
 


 edge_friend(node_user_1=n1,node_user_2= n2).save()
 edge_friend(node_user_1=n2,node_user_2= n1).save()
 edge_friend(node_user_1=n1,node_user_2=n3).save()
 edge_friend(node_user_1=n3,node_user_2=n1).save()
 edge_friend(node_user_1=n4,node_user_2=n1).save()
 edge_friend(node_user_1=n1,node_user_2=n4).save()
 edge_friend(node_user_1=n2,node_user_2=n5).save()
 edge_friend(node_user_1=n5,node_user_2=n2).save()
 
 reviews(product_id=1234,user_id=n2,comment="ABC",rating=2).save()
 reviews(product_id=1234,user_id=n3,comment="DEF",rating=3).save()
 reviews(product_id=1234,user_id=n4,comment="GHI",rating=4).save()
 reviews(product_id=1234,user_id=n5,comment="JKL",rating=8).save()
 reviews(product_id=1234,user_id=n6,comment="MNO",rating=6).save()
 reviews(product_id=1234,user_id=n7,comment="PQR",rating=9).save()
