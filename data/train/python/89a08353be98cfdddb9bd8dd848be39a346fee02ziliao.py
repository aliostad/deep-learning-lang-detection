    sql="SELECT priority,project,username,start_date,expect_launch_date,real_launch_date FROM manage_s_user,manage_s_project WHERE manage_s_project.leader_p_id=manage_s_user.id"
	cur = connection.cursor()
	cur.execute(sql)
	result = cur.fetchall()


	return render_to_response("funBlog.html", locals(),context_instance=RequestContext(request))

sql="SELECT username FROM manage_s_user,manage_s_project WHERE manage_s_project.leader_p_id=manage_s_user.id;"
	cur = connection.cursor()
	cur.execute(sql)


	for res2 in puser:
        for res2.project_id in result.id:
            for res2.username_id in res1.id:
                realname=username.realname
                rs=[]
                dic = {'realname':realname}
                rs.append(dic)
    rrs = {"username":rs}



     {% for i in pname %}
                    {% ifequal res.id i.project_id %}
                    {% for i.username_id in res2.id %}
                    <td>{{realname}}</td>
                    {% endfor %}
                    {% endifequal %}
                    {% endfor %}



     
                    {% for res2 in realname %}
                    {% ifequal res.id res2.project_id %}                                                        
                    <p>{{res2.realname}}</p>
                    {% endifequal %}
                    {% endfor %}



                    {% for res2 in realname %}
                    {% ifequal res.id res2.project_id %}                                                        
                    {{res2.realname}},
                    {% endifequal %}
                    {% endfor %}



                     realname=project_user.objects.extra(select={'choice_count': 'SELECT realname FROM manage_s_user,manage_s_project,manage_s_project_user WHERE manage_s_project.id=manage_s_project_user.project_id and manage_s_project_user.username_id=manage_s_user.id'})    
    print 'ok' 