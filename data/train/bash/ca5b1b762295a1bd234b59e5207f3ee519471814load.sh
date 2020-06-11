function load_ {
	if [[ $1 = settings ]]; then
		music=$(cat ./settings | grep music | awk '{print $2}')
		aSpeed=$(cat ./settings | grep speed | awk '{print $2}')
	elif [[ $1 = terrain ]]; then
		random15=($(cat ./save/terrain$saveSlot | sed -n '1p'))
		random14=($(cat ./save/terrain$saveSlot | sed -n '2p'))
		random13=($(cat ./save/terrain$saveSlot | sed -n '3p'))
		random12=($(cat ./save/terrain$saveSlot | sed -n '4p'))
		random11=($(cat ./save/terrain$saveSlot | sed -n '5p'))
		random10=($(cat ./save/terrain$saveSlot | sed -n '6p'))
		random9=($(cat ./save/terrain$saveSlot | sed -n '7p'))
		random8=($(cat ./save/terrain$saveSlot | sed -n '8p'))
		random7=($(cat ./save/terrain$saveSlot | sed -n '9p'))
		random6=($(cat ./save/terrain$saveSlot | sed -n '10p'))
		random5=($(cat ./save/terrain$saveSlot | sed -n '11p'))
		random4=($(cat ./save/terrain$saveSlot | sed -n '12p'))
		random3=($(cat ./save/terrain$saveSlot | sed -n '13p'))
		random2=($(cat ./save/terrain$saveSlot | sed -n '14p'))
		random1=($(cat ./save/terrain$saveSlot | sed -n '15p'))
		random0=($(cat ./save/terrain$saveSlot | sed -n '16p'))
		randomSpawnX=$(cat ./save/terrain$saveSlot | sed -n '17p' | awk '{print $1}')
		randomSpawnY=$(cat ./save/terrain$saveSlot | sed -n '17p' | awk '{print $2}')
		randomTownX=$(cat ./save/terrain$saveSlot | sed -n '18p' | awk '{print $1}')
		randomTownY=$(cat ./save/terrain$saveSlot | sed -n '18p' | awk '{print $2}')
		randomCastleX=$(cat ./save/terrain$saveSlot | sed -n '19p' | awk '{print $1}')
		randomCastleY=$(cat ./save/terrain$saveSlot | sed -n '19p' | awk '{print $2}')
		for ((a=0;a<16;a++)); do
			for ((b=0;b<30;b++)); do
				eval "aBlock=\${random$a[$b]}"
				if [[ $aBlock = "Å" ]]; then
					eval random$a[\$b]=\" \"
				fi
			done
		done
	elif [[ $1 = bank ]]; then
		bank=($(cat ./save/bank | grep bank | awk '{$1=""; print}'))
		bOwned=($(cat ./save/bank | grep bOwned | awk '{$1=""; print}'))
	else
		lvl=$(cat ./save/sav$saveSlot | grep lvl | awk '{print $2}')
		avatar=$(cat ./save/sav$saveSlot | grep avatar | awk '{print $2}')
		class=$(cat ./save/sav$saveSlot | grep class | awk '{print $2}')
		luck=$(cat ./save/sav$saveSlot | grep luck | awk '{print $2}')
		level=$(cat ./save/sav$saveSlot | grep level | awk '{print $2}')
		x=$(cat ./save/sav$saveSlot | grep cord | awk '{print $2}')
		y=$(cat ./save/sav$saveSlot | grep cord | awk '{print $3}')
		power=$(cat ./save/sav$saveSlot | grep power | awk '{print $2}')
		agility=$(cat ./save/sav$saveSlot | grep agility | awk '{print $2}')
		intelect=$(cat ./save/sav$saveSlot | grep intelect | awk '{print $2}')
		defense=$(cat ./save/sav$saveSlot | grep defense | awk '{print $2}')
		hp=$(cat ./save/sav$saveSlot | grep hp | awk '{print $2}')
		mp=$(cat ./save/sav$saveSlot | grep mp | awk '{print $2}')
		magicPoints=$(cat ./save/sav$saveSlot | grep magicPoints | awk '{print $2}')
		mmagicPoints=$(cat ./save/sav$saveSlot | grep maxgicPoints | awk '{print $2}')
		potions=$(cat ./save/sav$saveSlot | grep potions | awk '{print $2}')
		name=$(cat ./save/sav$saveSlot | grep name | awk '{print $2}')
		gold=$(cat ./save/sav$saveSlot | grep gold | awk '{print $2}')
		cheese=$(cat ./save/sav$saveSlot | grep cheese | awk '{print $2}')
		xp=$(cat ./save/sav$saveSlot | grep xp | awk '{print $2}')
		chest=($(cat ./save/sav$saveSlot | grep chest | awk '{$1=""; print}'))
		boss=$(cat ./save/sav$saveSlot | grep boss | awk '{print $2}')
		lives=$(cat ./save/sav$saveSlot | grep lives | awk '{print $2}')
		difficulty=$(cat ./save/sav$saveSlot | grep difficulty | awk '{print $2}')
		inv=($(cat ./save/sav$saveSlot | grep inv | awk '{$1=""; print}'))
		owned=($(cat ./save/sav$saveSlot | grep owned | awk '{$1=""; print}'))
		invMagic=($(cat ./save/sav$saveSlot | grep Magic | awk '{$1=""; print}'))
		effects=($(cat ./save/sav$saveSlot | grep effects | awk '{$1=""; print}'))
		effectd=($(cat ./save/sav$saveSlot | grep effectd | awk '{$1=""; print}'))
		cheese=($(cat ./save/sav$saveSlot | grep cheese | awk '{$1=""; print}'))
		berryEffect=($(cat ./save/sav$saveSlot | grep berryEffect | awk '{$1=""; print}'))
		drinksHad=$(cat ./save/sav$saveSlot | grep drinksHad | awk '{print $2}')
		spellUnlock=($(cat ./save/sav$saveSlot | grep spellUnlock | awk '{$1=""; print}'))
		events=($(cat ./save/sav$saveSlot | grep events | awk '{$1=""; print}'))
	fi
}