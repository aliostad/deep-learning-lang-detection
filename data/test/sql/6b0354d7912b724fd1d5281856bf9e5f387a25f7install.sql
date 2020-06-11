INSERT INTO users(
userId ,
activated ,
creation_date ,
last_login_stamp,
username ,
userpassword ,
usertype ,
email 
) VALUES (
1 ,
1 ,
1420070400 ,
1420070400 ,
'admin' ,
'changeme' ,
'ADMIN' ,
'NULL') ;

--##


INSERT INTO usergroup (userGroupId, userrole, username) VALUES (1, 'ADMIN' , 'admin');


--##

INSERT INTO templates ( templateId , active , templateName, headTagContent, headerContent, footerContent, scriptContent  )
VALUES ( 
1 , 
1 ,
'starter',  
' 
  <meta charset="utf-8"> 
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="description" content="">
  <meta name="author" content="">
  <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" />
',  
'  
   <!-- Navigation -->
    <nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
        <div class="container">
            <!-- Brand and toggle get grouped for better mobile display -->
            <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="#">Start Bootstrap</a>
            </div>
            <!-- Collect the nav links, forms, and other content for toggling -->
            <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                <ul class="nav navbar-nav">
                    <li>
                        <a href="#">About</a>
                    </li>
                    <li>
                        <a href="#">Services</a>
                    </li>
                    <li>
                        <a href="#">Contact</a>
                    </li>
                </ul>
            </div>
            <!-- /.navbar-collapse -->
        </div>
        <!-- /.container -->
    </nav>
	<!-- Page Content -->
    <div class="container"> 
',
' </div>
  <!-- /.container -->',
'
  <script type=\"text/javascript\" src=\"//ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js\"></script>\r\n 
  <script type=\"text/javascript\" src=\"//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js\"></script>\r\n
');

--##

INSERT INTO webpages( pageId , pageContent, pageName, pageURL )
VALUES(
1 ,
' <div class="row">
     <div class="col-lg-12 text-center">
         <h1>A Bootstrap Starter Template</h1>
         <p class="lead">Complete with pre-defined file paths that you wont have to change!</p>
         <ul class="list-unstyled">
             <li>Bootstrap v3.3.1</li>
             <li>jQuery v1.11.1</li>
         </ul>
     </div>
  </div>
  <!-- /.row -->',
'home',
'NULL');

--##

INSERT INTO settings (settingId, settingName, settingValue)
VALUES (1, 'installComplete', 'true') ;