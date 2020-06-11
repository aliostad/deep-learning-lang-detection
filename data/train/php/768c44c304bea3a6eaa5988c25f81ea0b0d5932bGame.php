<?php
	include('../page/normalsession.php'); 
	if (!$_SESSION['valid']) {
			header('Location: /account/Login');
	} else {
		include('../page/log.php');
		c_Log($_SESSION['id'],'Page Load');
	}
?>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, user-scalable=no" />
<meta name="HandheldFriendly" content="true">
<title>Tower Quest</title>
<!-- BrowserIcon -->
<link rel="icon" type="image/ico" href="/images/Galaxy.jpg" />
<!-- Computer -->
<link type="text/css" rel="stylesheet" href="/CSS/Style.css" media="only screen and (min-width:769px)" />
<link type="text/css" rel="stylesheet" href="/CSS/Social.css" />
<!-- Phone -->
<link href="/CSS/Phone.css" rel="stylesheet" type="text/css" media="only screen and (max-width:480px)" />
<!-- Tablet -->
<link href="/CSS/Tablet.css" rel="stylesheet" type="text/css" media="only screen and (min-width:481px) and (max-width:768px)" />
<!-- Apple Icons -->
<link rel="apple-touch-icon" href="/apple-icons/touch-icon-iphone.png" /> 
<link rel="apple-touch-icon" sizes="76x76" href="/apple-icons/touch-icon-ipad.png" /> 
<link rel="apple-touch-icon" sizes="120x120" href="/apple-icons/touch-icon-iphone-retina.png" />
<link rel="apple-touch-icon" sizes="152x152" href="/apple-icons/touch-icon-ipad-retina.png" />
<link rel="canonical" href="http://ChrisSiena.com/game/Game" />
<!-- Jquery files -->
<script src="/javascript/lib/jquery.min.js"></script>
<!-- Complete Game -->
<script src="/javascript/min/CompleteGame.min.js" language="JavaScript" type="text/javascript"></script>
<!-- CSS changer -->
<script>startUp();</script>
</head>
<body class="body">
    <?php include_once("../page/analyticstracking.php") ?>
	<?php include_once("../page/top.php") ?>
    <div class="page">
        <div class="placeHolder"></div>
        <div class="container">
            <div class="leftCol">
                <h2>Table of Contents</h2>
                <div class="links">
                    <a target="_top" href="/">Home</a>
                    <a target="_top" href="/images/Images">Images</a>
                    <a target="_top" href="/clans/Clans">Clans</a>
                    <a target="_top" href="/minecraft/Minecraft">Minecraft</a>
                    <a target="_top" href="/about/About">About</a>
                    <a target="_top" href="/support/Support">Support</a>
                    <a target="_top" href="/Files/Pages">Pages</a>
                    <a target="_top" href="/design/Site">Web Design</a>
                </div>
            </div>
            <div class="rightCol">
                <h2>Side Info<br /></h2>
                <span id="rightColButton">
                </span>
                <span id="null_output" class="null">
                </span>
                <span id="right_output" style="color: #CC66FF">
                </span>
                <span id="save_output" style="color: #CC66FF">
                </span>
            </div>
            <div class="contextArea">
                <h2>Tower Quest</h2>
                <div class="text">
                    <span>
                        <center>
                            <input type="text" placeholder="Enter a Command..." onchange="Engine.run()" style="display: none;"/>
                        </center>
                    </span>
                    <span id="output">
                    <?php
                        session_start();
                        include('../page/db.php');
                        include('../page/protection.php');
                        
                        $id = $_SESSION['id'];
                        
                        $sql = "SELECT RowID FROM GameSave WHERE UserID='$id'";
                        $data = mysqli_query($conn, $sql);
                        $data = mysqli_fetch_assoc($data);
                        $date = date("Y-m-d H:i:s");
                        if ($data['RowID']) {
                            $sql = "SELECT * FROM GameSave WHERE UserID='$id'";
                            $save = mysqli_query($conn, $sql);
                            $save = mysqli_fetch_assoc($save);
                            /*
                            if ($save['Cheat'] === '1') {
                                $save['Cheat'] = 'true';
                            } else {
                                $save['Cheat'] = 'false';
                            }
                            
                            if ($save['Start'] === '1') {
                                $save['Start'] = 'true';
                            } else {
                                $save['Start'] = 'false';
                            }
                            */
                            $loadedSave = ($save['Attack'] . ', ' . $save['AttackXP'] . ', ' . $save['Defense'] . ', ' . $save['DefenseXP'] . ', ' . $save['Health'] . ', ' . $save['HealthStatic'] . ', ' . $save['HealthStaticCheat'] . ', ' . $save['Mining'] . ', ' . $save['MiningXP'] . ', ' . $save['Fish'] . ', ' . $save['Fishing'] . ', ' . $save['FishingXP'] . ', ' . $save['Net'] . ', ' . $save['WoodCutting'] . ', ' . $save['WoodCuttingXP'] . ', ' . $save['Iron'] . ', ' . $save['Gold'] . ', ' . $save['Coal'] . ', ' . $save['Wood'] . ', ' . $save['Sword'] . ', ' . $save['Armour'] . ', ' . $save['SwordCheat'] . ', ' . $save['ArmourCheat'] . ', ' . $save['Silver'] . ', ' . $save['Game_Key'] . ', ' . $save['Kills'] . ', ' . $save['Deaths'] . ', ' . $save['WoodIncome'] . ', ' . $save['IronIncome'] . ', ' . $save['GoldIncome'] . ', ' . $save['CoalIncome'] . ', ' . $save['Location'] . ', ' . $save['GlobalLocation'] . ', ' . $save['TowerLocation'] . ', ' . $save['ShopLocation'] . ', ' . $save['Cheat'] . ', ' . $save['Start'] . ', ' . decrypt($save['SwordName']) . ', ' . decrypt($save['ArmourName']) . ', ' . decrypt($save['Name']) . ', ' . $save['EverCheated']);
                            echo("<center>The game is loading...</center>");
                            echo ('
                                <script type="text/javascript">
                                    function convertstring(){Engine.convertString("' . $loadedSave . '")};
                                </script>
                            ');
                            echo ('
                                <script type="text/javascript">
                                    setTimeout(function () {
                                        convertstring();
                                    }, 0500);
                                </script>
                            ');
                        } else {
                            echo ('
                                <script type="text/javascript">
                                    Game.help();
                                </script>
                            ');
                        }
                        
                        
                        mysqli_close($conn);
                    ?>
                    </span>
                </div>
            </div>
        </div>
    </div>
    <div class="footer">
        <?php include_once("../page/footer.php") ?>
    </div>
</body>
</html>