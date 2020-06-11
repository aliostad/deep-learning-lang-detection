<?php

class Admin
{        
    public static function IsLogin()
    {
        global $_SESSION;
        if (isset($_SESSION['login']) && $_SESSION['admin'] == 'ok')
            return true;
        else
            return false;
    }

    public static function checkSesion()
    {
        include 'checkSesion.php';
    }

    public static function ShowLoginFomrm()
    {
        Show::LoginForm();
    }

    public static function ShowAdminPanel()
    {
        Show::DiplayHeader($_SESSION['login']);
		if(isset($_GET['admin']))
		{
			switch ($_GET['admin'])
			{				
				case 'gallery':
					if(isset($_GET['action']))
						Show::Galeria($_GET['action']);
					else
						Show::Galeria('');
					break;
						
				case 'films':
					if(isset($_GET['action']))
						Show::Films($_GET['action']);
					else
						Show::Films('');
					break;
						
				case 'events':
					if(isset($_GET['action']))
						Show::Events($_GET['action']);
					else
						Show::Events('');
					break;
						
				case 'news':
					if(isset($_GET['action']))
						Show::News($_GET['action']);
					else
						Show::News('');
					break;
				
				case 'start':
					if(isset($_GET['action']))
						Show::Start($_GET['action']);
					else
						Show::Start('');
				break;
				
				case 'teams':
					if(isset($_GET['action']))
						Show::Teams($_GET['action']);
					else
						Show::Teams('');
				break;
				
				case 'players':
					if(isset($_GET['action']))
						Show::Players($_GET['action']);
					else
						Show::Players('');
				break;
				
				case 'matches':
					if(isset($_GET['action']))
						Show::Matches($_GET['action']);
					else
						Show::Matches('');
				break;
				
				case 'arbiters':
					if(isset($_GET['action']))
						Show::Arbiters($_GET['action']);
					else
						Show::Arbiters('');
				break;
				
				case 'pitches':
					if(isset($_GET['action']))
						Show::Matches($_GET['action']);
					else
						Show::Matches('');
				break;
					
				default:
					Show::ShowMessage("404 - Strona nie istnieje...", false);
					break;
			}	
		}
		else
		{
			Show::Dashboard();
		}
        Show::DiplayFooter();
    }
}

?>
