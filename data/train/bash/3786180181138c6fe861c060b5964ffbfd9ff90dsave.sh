function save_ {
	if [[ $1 = settings ]]; then
		echo "music $music" > ./settings
		echo "speed $aSpeed" >> ./settings
	elif [[ $1 = terrain ]]; then
		for ((a=0;a<16;a++)); do
			for ((b=0;b<30;b++)); do
				eval "aBlock=\${random$a[$b]}"
				if [[ $aBlock = " " ]]; then
					eval random$a[\$b]=\"Å\"
				fi
			done
		done
		echo "${random15[@]}" > ./save/terrain$saveSlot
		echo "${random14[@]}" >> ./save/terrain$saveSlot
		echo "${random13[@]}" >> ./save/terrain$saveSlot
		echo "${random12[@]}" >> ./save/terrain$saveSlot
		echo "${random11[@]}" >> ./save/terrain$saveSlot
		echo "${random10[@]}" >> ./save/terrain$saveSlot
		echo "${random9[@]}" >> ./save/terrain$saveSlot
		echo "${random8[@]}" >> ./save/terrain$saveSlot
		echo "${random7[@]}" >> ./save/terrain$saveSlot
		echo "${random6[@]}" >> ./save/terrain$saveSlot
		echo "${random5[@]}" >> ./save/terrain$saveSlot
		echo "${random4[@]}" >> ./save/terrain$saveSlot
		echo "${random3[@]}" >> ./save/terrain$saveSlot
		echo "${random2[@]}" >> ./save/terrain$saveSlot
		echo "${random1[@]}" >> ./save/terrain$saveSlot
		echo "${random0[@]}" >> ./save/terrain$saveSlot
		echo "$randomSpawnX $randomSpawnY" >> ./save/terrain$saveSlot
		echo "$randomTownX $randomTownY" >> ./save/terrain$saveSlot
		echo "$randomCastleX $randomCastleY" >> ./save/terrain$saveSlot
		for ((a=0;a<16;a++)); do
			for ((b=0;b<30;b++)); do
				eval "aBlock=\${random$a[$b]}"
				if [[ $aBlock = "Å" ]]; then
					eval random$a[\$b]=\" \"
				fi
			done
		done
	elif [[ $1 = bank ]]; then
		echo "bank ${bank[@]}" > ./save/bank
		echo "bOwned ${bOwned[@]}" >> ./save/bank
	else
		echo "lvl $lvl" > ./save/sav$saveSlot
		echo "class $class" >> ./save/sav$saveSlot
		echo "luck $luck" >> ./save/sav$saveSlot
		echo "level $level" >> ./save/sav$saveSlot
		echo "cord $x $y" >> ./save/sav$saveSlot
		echo "agility $agility" >> ./save/sav$saveSlot
		echo "power $power" >> ./save/sav$saveSlot 
		echo "intelect $intelect" >> ./save/sav$saveSlot 
		echo "defense $defense" >> ./save/sav$saveSlot
		echo "hp $hp" >> ./save/sav$saveSlot
		echo "mp $mp" >> ./save/sav$saveSlot
		echo "magicPoints $magicPoints" >> ./save/sav$saveSlot
		echo "maxgicPoints $mmagicPoints" >> ./save/sav$saveSlot
		echo "potions $potions" >> ./save/sav$saveSlot
		echo "name $name" >> ./save/sav$saveSlot
		echo "avatar $avatar" >> ./save/sav$saveSlot
		echo "gold $gold" >> ./save/sav$saveSlot
		echo "xp $xp" >> ./save/sav$saveSlot
		echo "chest ${chest[@]}" >> ./save/sav$saveSlot
		echo "boss $boss" >> ./save/sav$saveSlot
		echo "lives $lives" >> ./save/sav$saveSlot
		echo "difficulty $difficulty" >> ./save/sav$saveSlot
		echo "inv ${inv[@]}" >> ./save/sav$saveSlot
		echo "owned ${owned[@]}" >> ./save/sav$saveSlot
		echo "Magic ${invMagic[@]}" >> ./save/sav$saveSlot
		echo "effects ${effects[@]}" >> ./save/sav$saveSlot
		echo "effectd ${effectd[@]}" >> ./save/sav$saveSlot
		echo "cheese ${cheese[@]}" >> ./save/sav$saveSlot
		echo "berryEffect ${berryEffect[@]}" >> ./save/sav$saveSlot
		echo "drinksHad $drinksHad" >> ./save/sav$saveSlot
		echo "spellUnlock ${spellUnlock[@]}" >> ./save/sav$saveSlot
		echo "events ${events[@]}" >> ./save/sav$saveSlot
		justSaved=true
	fi
}