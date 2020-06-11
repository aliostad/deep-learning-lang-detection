package census

func CountyAndStateCodes(county string, state string) (string, string) {

	stateCode := ""
	countyCode := ""
	switch state {
	case "Alaska":
		stateCode = "02"
		switch county {
		case "Aleutians East":
			countyCode = "013"
		case "Aleutians West Census Area":
			countyCode = "016"
		case "Anchorage Municipality":
			countyCode = "020"
		case "Bethel Census Area":
			countyCode = "050"
		case "Bristol Bay":
			countyCode = "060"
		case "Denali":
			countyCode = "068"
		case "Dillingham Census Area":
			countyCode = "070"
		case "Fairbanks North Star":
			countyCode = "090"
		case "Haines":
			countyCode = "100"
		case "Hoonah-Angoon Census Area":
			countyCode = "105"
		case "Juneau":
			countyCode = "110"
		case "Kenai Peninsula":
			countyCode = "122"
		case "Ketchikan Gateway":
			countyCode = "130"
		case "Kodiak Island":
			countyCode = "150"
		case "Lake and Peninsula":
			countyCode = "164"
		case "Matanuska-Susitna":
			countyCode = "170"
		case "Nome Census Area":
			countyCode = "180"
		case "North Slope":
			countyCode = "185"
		case "Northwest Arctic":
			countyCode = "188"
		case "Petersburg Census Area":
			countyCode = "195"
		case "Prince of Wales-Hyder Census Area":
			countyCode = "198"
		case "Sitka":
			countyCode = "220"
		case "Skagway Municipality":
			countyCode = "230"
		case "Southeast Fairbanks Census Area":
			countyCode = "240"
		case "Valdez-Cordova Census Area":
			countyCode = "261"
		case "Wade Hampton Census Area":
			countyCode = "270"
		case "Wrangell":
			countyCode = "275"
		case "Yakutat":
			countyCode = "282"
		case "Yukon-Koyukuk Census Area":
			countyCode = "290"
		}
	case "Alabama":
		stateCode = "01"
		switch county {
		case "Autauga":
			countyCode = "001"
		case "Baldwin":
			countyCode = "003"
		case "Barbour":
			countyCode = "005"
		case "Bibb":
			countyCode = "007"
		case "Blount":
			countyCode = "009"
		case "Bullock":
			countyCode = "011"
		case "Butler":
			countyCode = "013"
		case "Calhoun":
			countyCode = "015"
		case "Chambers":
			countyCode = "017"
		case "Cherokee":
			countyCode = "019"
		case "Chilton":
			countyCode = "021"
		case "Choctaw":
			countyCode = "023"
		case "Clarke":
			countyCode = "025"
		case "Clay":
			countyCode = "027"
		case "Cleburne":
			countyCode = "029"
		case "Coffee":
			countyCode = "031"
		case "Colbert":
			countyCode = "033"
		case "Conecuh":
			countyCode = "035"
		case "Coosa":
			countyCode = "037"
		case "Covington":
			countyCode = "039"
		case "Crenshaw":
			countyCode = "041"
		case "Cullman":
			countyCode = "043"
		case "Dale":
			countyCode = "045"
		case "Dallas":
			countyCode = "047"
		case "DeKalb":
			countyCode = "049"
		case "Elmore":
			countyCode = "051"
		case "Escambia":
			countyCode = "053"
		case "Etowah":
			countyCode = "055"
		case "Fayette":
			countyCode = "057"
		case "Franklin":
			countyCode = "059"
		case "Geneva":
			countyCode = "061"
		case "Greene":
			countyCode = "063"
		case "Hale":
			countyCode = "065"
		case "Henry":
			countyCode = "067"
		case "Houston":
			countyCode = "069"
		case "Jackson":
			countyCode = "071"
		case "Jefferson":
			countyCode = "073"
		case "Lamar":
			countyCode = "075"
		case "Lauderdale":
			countyCode = "077"
		case "Lawrence":
			countyCode = "079"
		case "Lee":
			countyCode = "081"
		case "Limestone":
			countyCode = "083"
		case "Lowndes":
			countyCode = "085"
		case "Macon":
			countyCode = "087"
		case "Madison":
			countyCode = "089"
		case "Marengo":
			countyCode = "091"
		case "Marion":
			countyCode = "093"
		case "Marshall":
			countyCode = "095"
		case "Mobile":
			countyCode = "097"
		case "Monroe":
			countyCode = "099"
		case "Montgomery":
			countyCode = "101"
		case "Morgan":
			countyCode = "103"
		case "Perry":
			countyCode = "105"
		case "Pickens":
			countyCode = "107"
		case "Pike":
			countyCode = "109"
		case "Randolph":
			countyCode = "111"
		case "Russell":
			countyCode = "113"
		case "St. Clair":
			countyCode = "115"
		case "Shelby":
			countyCode = "117"
		case "Sumter":
			countyCode = "119"
		case "Talladega":
			countyCode = "121"
		case "Tallapoosa":
			countyCode = "123"
		case "Tuscaloosa":
			countyCode = "125"
		case "Walker":
			countyCode = "127"
		case "Washington":
			countyCode = "129"
		case "Wilcox":
			countyCode = "131"
		case "Winston":
			countyCode = "133"
		}
	case "Arkansas":
		stateCode = "05"
		switch county {
		case "Arkansas":
			countyCode = "001"
		case "Ashley":
			countyCode = "003"
		case "Baxter":
			countyCode = "005"
		case "Benton":
			countyCode = "007"
		case "Boone":
			countyCode = "009"
		case "Bradley":
			countyCode = "011"
		case "Calhoun":
			countyCode = "013"
		case "Carroll":
			countyCode = "015"
		case "Chicot":
			countyCode = "017"
		case "Clark":
			countyCode = "019"
		case "Clay":
			countyCode = "021"
		case "Cleburne":
			countyCode = "023"
		case "Cleveland":
			countyCode = "025"
		case "Columbia":
			countyCode = "027"
		case "Conway":
			countyCode = "029"
		case "Craighead":
			countyCode = "031"
		case "Crawford":
			countyCode = "033"
		case "Crittenden":
			countyCode = "035"
		case "Cross":
			countyCode = "037"
		case "Dallas":
			countyCode = "039"
		case "Desha":
			countyCode = "041"
		case "Drew":
			countyCode = "043"
		case "Faulkner":
			countyCode = "045"
		case "Franklin":
			countyCode = "047"
		case "Fulton":
			countyCode = "049"
		case "Garland":
			countyCode = "051"
		case "Grant":
			countyCode = "053"
		case "Greene":
			countyCode = "055"
		case "Hempstead":
			countyCode = "057"
		case "Hot Spring":
			countyCode = "059"
		case "Howard":
			countyCode = "061"
		case "Independence":
			countyCode = "063"
		case "Izard":
			countyCode = "065"
		case "Jackson":
			countyCode = "067"
		case "Jefferson":
			countyCode = "069"
		case "Johnson":
			countyCode = "071"
		case "Lafayette":
			countyCode = "073"
		case "Lawrence":
			countyCode = "075"
		case "Lee":
			countyCode = "077"
		case "Lincoln":
			countyCode = "079"
		case "Little River":
			countyCode = "081"
		case "Logan":
			countyCode = "083"
		case "Lonoke":
			countyCode = "085"
		case "Madison":
			countyCode = "087"
		case "Marion":
			countyCode = "089"
		case "Miller":
			countyCode = "091"
		case "Mississippi":
			countyCode = "093"
		case "Monroe":
			countyCode = "095"
		case "Montgomery":
			countyCode = "097"
		case "Nevada":
			countyCode = "099"
		case "Newton":
			countyCode = "101"
		case "Ouachita":
			countyCode = "103"
		case "Perry":
			countyCode = "105"
		case "Phillips":
			countyCode = "107"
		case "Pike":
			countyCode = "109"
		case "Poinsett":
			countyCode = "111"
		case "Polk":
			countyCode = "113"
		case "Pope":
			countyCode = "115"
		case "Prairie":
			countyCode = "117"
		case "Pulaski":
			countyCode = "119"
		case "Randolph":
			countyCode = "121"
		case "St. Francis":
			countyCode = "123"
		case "Saline":
			countyCode = "125"
		case "Scott":
			countyCode = "127"
		case "Searcy":
			countyCode = "129"
		case "Sebastian":
			countyCode = "131"
		case "Sevier":
			countyCode = "133"
		case "Sharp":
			countyCode = "135"
		case "Stone":
			countyCode = "137"
		case "Union":
			countyCode = "139"
		case "Van Buren":
			countyCode = "141"
		case "Washington":
			countyCode = "143"
		case "White":
			countyCode = "145"
		case "Woodruff":
			countyCode = "147"
		case "Yell":
			countyCode = "149"
		}
	case "Arizona":
		stateCode = "04"
		switch county {
		case "Apache":
			countyCode = "001"
		case "Cochise":
			countyCode = "003"
		case "Coconino":
			countyCode = "005"
		case "Gila":
			countyCode = "007"
		case "Graham":
			countyCode = "009"
		case "Greenlee":
			countyCode = "011"
		case "La Paz":
			countyCode = "012"
		case "Maricopa":
			countyCode = "013"
		case "Mohave":
			countyCode = "015"
		case "Navajo":
			countyCode = "017"
		case "Pima":
			countyCode = "019"
		case "Pinal":
			countyCode = "021"
		case "Santa Cruz":
			countyCode = "023"
		case "Yavapai":
			countyCode = "025"
		case "Yuma":
			countyCode = "027"
		}
	case "California":
		stateCode = "06"
		switch county {
		case "Alameda":
			countyCode = "001"
		case "Alpine":
			countyCode = "003"
		case "Amador":
			countyCode = "005"
		case "Butte":
			countyCode = "007"
		case "Calaveras":
			countyCode = "009"
		case "Colusa":
			countyCode = "011"
		case "Contra Costa":
			countyCode = "013"
		case "Del Norte":
			countyCode = "015"
		case "El Dorado":
			countyCode = "017"
		case "Fresno":
			countyCode = "019"
		case "Glenn":
			countyCode = "021"
		case "Humboldt":
			countyCode = "023"
		case "Imperial":
			countyCode = "025"
		case "Inyo":
			countyCode = "027"
		case "Kern":
			countyCode = "029"
		case "Kings":
			countyCode = "031"
		case "Lake":
			countyCode = "033"
		case "Lassen":
			countyCode = "035"
		case "Los Angeles":
			countyCode = "037"
		case "Madera":
			countyCode = "039"
		case "Marin":
			countyCode = "041"
		case "Mariposa":
			countyCode = "043"
		case "Mendocino":
			countyCode = "045"
		case "Merced":
			countyCode = "047"
		case "Modoc":
			countyCode = "049"
		case "Mono":
			countyCode = "051"
		case "Monterey":
			countyCode = "053"
		case "Napa":
			countyCode = "055"
		case "Nevada":
			countyCode = "057"
		case "Orange":
			countyCode = "059"
		case "Placer":
			countyCode = "061"
		case "Plumas":
			countyCode = "063"
		case "Riverside":
			countyCode = "065"
		case "Sacramento":
			countyCode = "067"
		case "San Benito":
			countyCode = "069"
		case "San Bernardino":
			countyCode = "071"
		case "San Diego":
			countyCode = "073"
		case "San Francisco":
			countyCode = "075"
		case "San Joaquin":
			countyCode = "077"
		case "San Luis Obispo":
			countyCode = "079"
		case "San Mateo":
			countyCode = "081"
		case "Santa Barbara":
			countyCode = "083"
		case "Santa Clara":
			countyCode = "085"
		case "Santa Cruz":
			countyCode = "087"
		case "Shasta":
			countyCode = "089"
		case "Sierra":
			countyCode = "091"
		case "Siskiyou":
			countyCode = "093"
		case "Solano":
			countyCode = "095"
		case "Sonoma":
			countyCode = "097"
		case "Stanislaus":
			countyCode = "099"
		case "Sutter":
			countyCode = "101"
		case "Tehama":
			countyCode = "103"
		case "Trinity":
			countyCode = "105"
		case "Tulare":
			countyCode = "107"
		case "Tuolumne":
			countyCode = "109"
		case "Ventura":
			countyCode = "111"
		case "Yolo":
			countyCode = "113"
		case "Yuba":
			countyCode = "115"
		}
	case "Colorado":
		stateCode = "08"
		switch county {
		case "Adams":
			countyCode = "001"
		case "Alamosa":
			countyCode = "003"
		case "Arapahoe":
			countyCode = "005"
		case "Archuleta":
			countyCode = "007"
		case "Baca":
			countyCode = "009"
		case "Bent":
			countyCode = "011"
		case "Boulder":
			countyCode = "013"
		case "Broomfield":
			countyCode = "014"
		case "Chaffee":
			countyCode = "015"
		case "Cheyenne":
			countyCode = "017"
		case "Clear Creek":
			countyCode = "019"
		case "Conejos":
			countyCode = "021"
		case "Costilla":
			countyCode = "023"
		case "Crowley":
			countyCode = "025"
		case "Custer":
			countyCode = "027"
		case "Delta":
			countyCode = "029"
		case "Denver":
			countyCode = "031"
		case "Dolores":
			countyCode = "033"
		case "Douglas":
			countyCode = "035"
		case "Eagle":
			countyCode = "037"
		case "Elbert":
			countyCode = "039"
		case "El Paso":
			countyCode = "041"
		case "Fremont":
			countyCode = "043"
		case "Garfield":
			countyCode = "045"
		case "Gilpin":
			countyCode = "047"
		case "Grand":
			countyCode = "049"
		case "Gunnison":
			countyCode = "051"
		case "Hinsdale":
			countyCode = "053"
		case "Huerfano":
			countyCode = "055"
		case "Jackson":
			countyCode = "057"
		case "Jefferson":
			countyCode = "059"
		case "Kiowa":
			countyCode = "061"
		case "Kit Carson":
			countyCode = "063"
		case "Lake":
			countyCode = "065"
		case "La Plata":
			countyCode = "067"
		case "Larimer":
			countyCode = "069"
		case "Las Animas":
			countyCode = "071"
		case "Lincoln":
			countyCode = "073"
		case "Logan":
			countyCode = "075"
		case "Mesa":
			countyCode = "077"
		case "Mineral":
			countyCode = "079"
		case "Moffat":
			countyCode = "081"
		case "Montezuma":
			countyCode = "083"
		case "Montrose":
			countyCode = "085"
		case "Morgan":
			countyCode = "087"
		case "Otero":
			countyCode = "089"
		case "Ouray":
			countyCode = "091"
		case "Park":
			countyCode = "093"
		case "Phillips":
			countyCode = "095"
		case "Pitkin":
			countyCode = "097"
		case "Prowers":
			countyCode = "099"
		case "Pueblo":
			countyCode = "101"
		case "Rio Blanco":
			countyCode = "103"
		case "Rio Grande":
			countyCode = "105"
		case "Routt":
			countyCode = "107"
		case "Saguache":
			countyCode = "109"
		case "San Juan":
			countyCode = "111"
		case "San Miguel":
			countyCode = "113"
		case "Sedgwick":
			countyCode = "115"
		case "Summit":
			countyCode = "117"
		case "Teller":
			countyCode = "119"
		case "Washington":
			countyCode = "121"
		case "Weld":
			countyCode = "123"
		case "Yuma":
			countyCode = "125"
		}
	case "Connecticut":
		stateCode = "09"
		switch county {
		case "Fairfield":
			countyCode = "001"
		case "Hartford":
			countyCode = "003"
		case "Litchfield":
			countyCode = "005"
		case "Middlesex":
			countyCode = "007"
		case "New Haven":
			countyCode = "009"
		case "New London":
			countyCode = "011"
		case "Tolland":
			countyCode = "013"
		case "Windham":
			countyCode = "015"
		}
	case "District of Columbia":
		stateCode = "11"
		switch county {
		case "District of Columbia":
			countyCode = "001"
		}
	case "Delaware":
		stateCode = "10"
		switch county {
		case "Kent":
			countyCode = "001"
		case "New Castle":
			countyCode = "003"
		case "Sussex":
			countyCode = "005"
		}
	case "Florida":
		stateCode = "12"
		switch county {
		case "Alachua":
			countyCode = "001"
		case "Baker":
			countyCode = "003"
		case "Bay":
			countyCode = "005"
		case "Bradford":
			countyCode = "007"
		case "Brevard":
			countyCode = "009"
		case "Broward":
			countyCode = "011"
		case "Calhoun":
			countyCode = "013"
		case "Charlotte":
			countyCode = "015"
		case "Citrus":
			countyCode = "017"
		case "Clay":
			countyCode = "019"
		case "Collier":
			countyCode = "021"
		case "Columbia":
			countyCode = "023"
		case "DeSoto":
			countyCode = "027"
		case "Dixie":
			countyCode = "029"
		case "Duval":
			countyCode = "031"
		case "Escambia":
			countyCode = "033"
		case "Flagler":
			countyCode = "035"
		case "Franklin":
			countyCode = "037"
		case "Gadsden":
			countyCode = "039"
		case "Gilchrist":
			countyCode = "041"
		case "Glades":
			countyCode = "043"
		case "Gulf":
			countyCode = "045"
		case "Hamilton":
			countyCode = "047"
		case "Hardee":
			countyCode = "049"
		case "Hendry":
			countyCode = "051"
		case "Hernando":
			countyCode = "053"
		case "Highlands":
			countyCode = "055"
		case "Hillsborough":
			countyCode = "057"
		case "Holmes":
			countyCode = "059"
		case "Indian River":
			countyCode = "061"
		case "Jackson":
			countyCode = "063"
		case "Jefferson":
			countyCode = "065"
		case "Lafayette":
			countyCode = "067"
		case "Lake":
			countyCode = "069"
		case "Lee":
			countyCode = "071"
		case "Leon":
			countyCode = "073"
		case "Levy":
			countyCode = "075"
		case "Liberty":
			countyCode = "077"
		case "Madison":
			countyCode = "079"
		case "Manatee":
			countyCode = "081"
		case "Marion":
			countyCode = "083"
		case "Martin":
			countyCode = "085"
		case "Miami-Dade":
			countyCode = "086"
		case "Monroe":
			countyCode = "087"
		case "Nassau":
			countyCode = "089"
		case "Okaloosa":
			countyCode = "091"
		case "Okeechobee":
			countyCode = "093"
		case "Orange":
			countyCode = "095"
		case "Osceola":
			countyCode = "097"
		case "Palm Beach":
			countyCode = "099"
		case "Pasco":
			countyCode = "101"
		case "Pinellas":
			countyCode = "103"
		case "Polk":
			countyCode = "105"
		case "Putnam":
			countyCode = "107"
		case "St. Johns":
			countyCode = "109"
		case "St. Lucie":
			countyCode = "111"
		case "Santa Rosa":
			countyCode = "113"
		case "Sarasota":
			countyCode = "115"
		case "Seminole":
			countyCode = "117"
		case "Sumter":
			countyCode = "119"
		case "Suwannee":
			countyCode = "121"
		case "Taylor":
			countyCode = "123"
		case "Union":
			countyCode = "125"
		case "Volusia":
			countyCode = "127"
		case "Wakulla":
			countyCode = "129"
		case "Walton":
			countyCode = "131"
		case "Washington":
			countyCode = "133"
		}
	case "Georgia":
		stateCode = "13"
		switch county {
		case "Appling":
			countyCode = "001"
		case "Atkinson":
			countyCode = "003"
		case "Bacon":
			countyCode = "005"
		case "Baker":
			countyCode = "007"
		case "Baldwin":
			countyCode = "009"
		case "Banks":
			countyCode = "011"
		case "Barrow":
			countyCode = "013"
		case "Bartow":
			countyCode = "015"
		case "Ben Hill":
			countyCode = "017"
		case "Berrien":
			countyCode = "019"
		case "Bibb":
			countyCode = "021"
		case "Bleckley":
			countyCode = "023"
		case "Brantley":
			countyCode = "025"
		case "Brooks":
			countyCode = "027"
		case "Bryan":
			countyCode = "029"
		case "Bulloch":
			countyCode = "031"
		case "Burke":
			countyCode = "033"
		case "Butts":
			countyCode = "035"
		case "Calhoun":
			countyCode = "037"
		case "Camden":
			countyCode = "039"
		case "Candler":
			countyCode = "043"
		case "Carroll":
			countyCode = "045"
		case "Catoosa":
			countyCode = "047"
		case "Charlton":
			countyCode = "049"
		case "Chatham":
			countyCode = "051"
		case "Chattahoochee":
			countyCode = "053"
		case "Chattooga":
			countyCode = "055"
		case "Cherokee":
			countyCode = "057"
		case "Clarke":
			countyCode = "059"
		case "Clay":
			countyCode = "061"
		case "Clayton":
			countyCode = "063"
		case "Clinch":
			countyCode = "065"
		case "Cobb":
			countyCode = "067"
		case "Coffee":
			countyCode = "069"
		case "Colquitt":
			countyCode = "071"
		case "Columbia":
			countyCode = "073"
		case "Cook":
			countyCode = "075"
		case "Coweta":
			countyCode = "077"
		case "Crawford":
			countyCode = "079"
		case "Crisp":
			countyCode = "081"
		case "Dade":
			countyCode = "083"
		case "Dawson":
			countyCode = "085"
		case "Decatur":
			countyCode = "087"
		case "DeKalb":
			countyCode = "089"
		case "Dodge":
			countyCode = "091"
		case "Dooly":
			countyCode = "093"
		case "Dougherty":
			countyCode = "095"
		case "Douglas":
			countyCode = "097"
		case "Early":
			countyCode = "099"
		case "Echols":
			countyCode = "101"
		case "Effingham":
			countyCode = "103"
		case "Elbert":
			countyCode = "105"
		case "Emanuel":
			countyCode = "107"
		case "Evans":
			countyCode = "109"
		case "Fannin":
			countyCode = "111"
		case "Fayette":
			countyCode = "113"
		case "Floyd":
			countyCode = "115"
		case "Forsyth":
			countyCode = "117"
		case "Franklin":
			countyCode = "119"
		case "Fulton":
			countyCode = "121"
		case "Gilmer":
			countyCode = "123"
		case "Glascock":
			countyCode = "125"
		case "Glynn":
			countyCode = "127"
		case "Gordon":
			countyCode = "129"
		case "Grady":
			countyCode = "131"
		case "Greene":
			countyCode = "133"
		case "Gwinnett":
			countyCode = "135"
		case "Habersham":
			countyCode = "137"
		case "Hall":
			countyCode = "139"
		case "Hancock":
			countyCode = "141"
		case "Haralson":
			countyCode = "143"
		case "Harris":
			countyCode = "145"
		case "Hart":
			countyCode = "147"
		case "Heard":
			countyCode = "149"
		case "Henry":
			countyCode = "151"
		case "Houston":
			countyCode = "153"
		case "Irwin":
			countyCode = "155"
		case "Jackson":
			countyCode = "157"
		case "Jasper":
			countyCode = "159"
		case "Jeff Davis":
			countyCode = "161"
		case "Jefferson":
			countyCode = "163"
		case "Jenkins":
			countyCode = "165"
		case "Johnson":
			countyCode = "167"
		case "Jones":
			countyCode = "169"
		case "Lamar":
			countyCode = "171"
		case "Lanier":
			countyCode = "173"
		case "Laurens":
			countyCode = "175"
		case "Lee":
			countyCode = "177"
		case "Liberty":
			countyCode = "179"
		case "Lincoln":
			countyCode = "181"
		case "Long":
			countyCode = "183"
		case "Lowndes":
			countyCode = "185"
		case "Lumpkin":
			countyCode = "187"
		case "McDuffie":
			countyCode = "189"
		case "McIntosh":
			countyCode = "191"
		case "Macon":
			countyCode = "193"
		case "Madison":
			countyCode = "195"
		case "Marion":
			countyCode = "197"
		case "Meriwether":
			countyCode = "199"
		case "Miller":
			countyCode = "201"
		case "Mitchell":
			countyCode = "205"
		case "Monroe":
			countyCode = "207"
		case "Montgomery":
			countyCode = "209"
		case "Morgan":
			countyCode = "211"
		case "Murray":
			countyCode = "213"
		case "Muscogee":
			countyCode = "215"
		case "Newton":
			countyCode = "217"
		case "Oconee":
			countyCode = "219"
		case "Oglethorpe":
			countyCode = "221"
		case "Paulding":
			countyCode = "223"
		case "Peach":
			countyCode = "225"
		case "Pickens":
			countyCode = "227"
		case "Pierce":
			countyCode = "229"
		case "Pike":
			countyCode = "231"
		case "Polk":
			countyCode = "233"
		case "Pulaski":
			countyCode = "235"
		case "Putnam":
			countyCode = "237"
		case "Quitman":
			countyCode = "239"
		case "Rabun":
			countyCode = "241"
		case "Randolph":
			countyCode = "243"
		case "Richmond":
			countyCode = "245"
		case "Rockdale":
			countyCode = "247"
		case "Schley":
			countyCode = "249"
		case "Screven":
			countyCode = "251"
		case "Seminole":
			countyCode = "253"
		case "Spalding":
			countyCode = "255"
		case "Stephens":
			countyCode = "257"
		case "Stewart":
			countyCode = "259"
		case "Sumter":
			countyCode = "261"
		case "Talbot":
			countyCode = "263"
		case "Taliaferro":
			countyCode = "265"
		case "Tattnall":
			countyCode = "267"
		case "Taylor":
			countyCode = "269"
		case "Telfair":
			countyCode = "271"
		case "Terrell":
			countyCode = "273"
		case "Thomas":
			countyCode = "275"
		case "Tift":
			countyCode = "277"
		case "Toombs":
			countyCode = "279"
		case "Towns":
			countyCode = "281"
		case "Treutlen":
			countyCode = "283"
		case "Troup":
			countyCode = "285"
		case "Turner":
			countyCode = "287"
		case "Twiggs":
			countyCode = "289"
		case "Union":
			countyCode = "291"
		case "Upson":
			countyCode = "293"
		case "Walker":
			countyCode = "295"
		case "Walton":
			countyCode = "297"
		case "Ware":
			countyCode = "299"
		case "Warren":
			countyCode = "301"
		case "Washington":
			countyCode = "303"
		case "Wayne":
			countyCode = "305"
		case "Webster":
			countyCode = "307"
		case "Wheeler":
			countyCode = "309"
		case "White":
			countyCode = "311"
		case "Whitfield":
			countyCode = "313"
		case "Wilcox":
			countyCode = "315"
		case "Wilkes":
			countyCode = "317"
		case "Wilkinson":
			countyCode = "319"
		case "Worth":
			countyCode = "321"
		}
	case "Hawaii":
		stateCode = "15"
		switch county {
		case "Hawaii":
			countyCode = "001"
		case "Honolulu":
			countyCode = "003"
		case "Kalawao":
			countyCode = "005"
		case "Kauai":
			countyCode = "007"
		case "Maui":
			countyCode = "009"
		}
	case "Iowa":
		stateCode = "19"
		switch county {
		case "Adair":
			countyCode = "001"
		case "Adams":
			countyCode = "003"
		case "Allamakee":
			countyCode = "005"
		case "Appanoose":
			countyCode = "007"
		case "Audubon":
			countyCode = "009"
		case "Benton":
			countyCode = "011"
		case "Black Hawk":
			countyCode = "013"
		case "Boone":
			countyCode = "015"
		case "Bremer":
			countyCode = "017"
		case "Buchanan":
			countyCode = "019"
		case "Buena Vista":
			countyCode = "021"
		case "Butler":
			countyCode = "023"
		case "Calhoun":
			countyCode = "025"
		case "Carroll":
			countyCode = "027"
		case "Cass":
			countyCode = "029"
		case "Cedar":
			countyCode = "031"
		case "Cerro Gordo":
			countyCode = "033"
		case "Cherokee":
			countyCode = "035"
		case "Chickasaw":
			countyCode = "037"
		case "Clarke":
			countyCode = "039"
		case "Clay":
			countyCode = "041"
		case "Clayton":
			countyCode = "043"
		case "Clinton":
			countyCode = "045"
		case "Crawford":
			countyCode = "047"
		case "Dallas":
			countyCode = "049"
		case "Davis":
			countyCode = "051"
		case "Decatur":
			countyCode = "053"
		case "Delaware":
			countyCode = "055"
		case "Des Moines":
			countyCode = "057"
		case "Dickinson":
			countyCode = "059"
		case "Dubuque":
			countyCode = "061"
		case "Emmet":
			countyCode = "063"
		case "Fayette":
			countyCode = "065"
		case "Floyd":
			countyCode = "067"
		case "Franklin":
			countyCode = "069"
		case "Fremont":
			countyCode = "071"
		case "Greene":
			countyCode = "073"
		case "Grundy":
			countyCode = "075"
		case "Guthrie":
			countyCode = "077"
		case "Hamilton":
			countyCode = "079"
		case "Hancock":
			countyCode = "081"
		case "Hardin":
			countyCode = "083"
		case "Harrison":
			countyCode = "085"
		case "Henry":
			countyCode = "087"
		case "Howard":
			countyCode = "089"
		case "Humboldt":
			countyCode = "091"
		case "Ida":
			countyCode = "093"
		case "Iowa":
			countyCode = "095"
		case "Jackson":
			countyCode = "097"
		case "Jasper":
			countyCode = "099"
		case "Jefferson":
			countyCode = "101"
		case "Johnson":
			countyCode = "103"
		case "Jones":
			countyCode = "105"
		case "Keokuk":
			countyCode = "107"
		case "Kossuth":
			countyCode = "109"
		case "Lee":
			countyCode = "111"
		case "Linn":
			countyCode = "113"
		case "Louisa":
			countyCode = "115"
		case "Lucas":
			countyCode = "117"
		case "Lyon":
			countyCode = "119"
		case "Madison":
			countyCode = "121"
		case "Mahaska":
			countyCode = "123"
		case "Marion":
			countyCode = "125"
		case "Marshall":
			countyCode = "127"
		case "Mills":
			countyCode = "129"
		case "Mitchell":
			countyCode = "131"
		case "Monona":
			countyCode = "133"
		case "Monroe":
			countyCode = "135"
		case "Montgomery":
			countyCode = "137"
		case "Muscatine":
			countyCode = "139"
		case "O'Brien":
			countyCode = "141"
		case "Osceola":
			countyCode = "143"
		case "Page":
			countyCode = "145"
		case "Palo Alto":
			countyCode = "147"
		case "Plymouth":
			countyCode = "149"
		case "Pocahontas":
			countyCode = "151"
		case "Polk":
			countyCode = "153"
		case "Pottawattamie":
			countyCode = "155"
		case "Poweshiek":
			countyCode = "157"
		case "Ringgold":
			countyCode = "159"
		case "Sac":
			countyCode = "161"
		case "Scott":
			countyCode = "163"
		case "Shelby":
			countyCode = "165"
		case "Sioux":
			countyCode = "167"
		case "Story":
			countyCode = "169"
		case "Tama":
			countyCode = "171"
		case "Taylor":
			countyCode = "173"
		case "Union":
			countyCode = "175"
		case "Van Buren":
			countyCode = "177"
		case "Wapello":
			countyCode = "179"
		case "Warren":
			countyCode = "181"
		case "Washington":
			countyCode = "183"
		case "Wayne":
			countyCode = "185"
		case "Webster":
			countyCode = "187"
		case "Winnebago":
			countyCode = "189"
		case "Winneshiek":
			countyCode = "191"
		case "Woodbury":
			countyCode = "193"
		case "Worth":
			countyCode = "195"
		case "Wright":
			countyCode = "197"
		}
	case "Idaho":
		stateCode = "16"
		switch county {
		case "Ada":
			countyCode = "001"
		case "Adams":
			countyCode = "003"
		case "Bannock":
			countyCode = "005"
		case "Bear Lake":
			countyCode = "007"
		case "Benewah":
			countyCode = "009"
		case "Bingham":
			countyCode = "011"
		case "Blaine":
			countyCode = "013"
		case "Boise":
			countyCode = "015"
		case "Bonner":
			countyCode = "017"
		case "Bonneville":
			countyCode = "019"
		case "Boundary":
			countyCode = "021"
		case "Butte":
			countyCode = "023"
		case "Camas":
			countyCode = "025"
		case "Canyon":
			countyCode = "027"
		case "Caribou":
			countyCode = "029"
		case "Cassia":
			countyCode = "031"
		case "Clark":
			countyCode = "033"
		case "Clearwater":
			countyCode = "035"
		case "Custer":
			countyCode = "037"
		case "Elmore":
			countyCode = "039"
		case "Franklin":
			countyCode = "041"
		case "Fremont":
			countyCode = "043"
		case "Gem":
			countyCode = "045"
		case "Gooding":
			countyCode = "047"
		case "Idaho":
			countyCode = "049"
		case "Jefferson":
			countyCode = "051"
		case "Jerome":
			countyCode = "053"
		case "Kootenai":
			countyCode = "055"
		case "Latah":
			countyCode = "057"
		case "Lemhi":
			countyCode = "059"
		case "Lewis":
			countyCode = "061"
		case "Lincoln":
			countyCode = "063"
		case "Madison":
			countyCode = "065"
		case "Minidoka":
			countyCode = "067"
		case "Nez Perce":
			countyCode = "069"
		case "Oneida":
			countyCode = "071"
		case "Owyhee":
			countyCode = "073"
		case "Payette":
			countyCode = "075"
		case "Power":
			countyCode = "077"
		case "Shoshone":
			countyCode = "079"
		case "Teton":
			countyCode = "081"
		case "Twin Falls":
			countyCode = "083"
		case "Valley":
			countyCode = "085"
		case "Washington":
			countyCode = "087"
		}
	case "Illinois":
		stateCode = "17"
		switch county {
		case "Adams":
			countyCode = "001"
		case "Alexander":
			countyCode = "003"
		case "Bond":
			countyCode = "005"
		case "Boone":
			countyCode = "007"
		case "Brown":
			countyCode = "009"
		case "Bureau":
			countyCode = "011"
		case "Calhoun":
			countyCode = "013"
		case "Carroll":
			countyCode = "015"
		case "Cass":
			countyCode = "017"
		case "Champaign":
			countyCode = "019"
		case "Christian":
			countyCode = "021"
		case "Clark":
			countyCode = "023"
		case "Clay":
			countyCode = "025"
		case "Clinton":
			countyCode = "027"
		case "Coles":
			countyCode = "029"
		case "Cook":
			countyCode = "031"
		case "Crawford":
			countyCode = "033"
		case "Cumberland":
			countyCode = "035"
		case "DeKalb":
			countyCode = "037"
		case "De Witt":
			countyCode = "039"
		case "Douglas":
			countyCode = "041"
		case "DuPage":
			countyCode = "043"
		case "Edgar":
			countyCode = "045"
		case "Edwards":
			countyCode = "047"
		case "Effingham":
			countyCode = "049"
		case "Fayette":
			countyCode = "051"
		case "Ford":
			countyCode = "053"
		case "Franklin":
			countyCode = "055"
		case "Fulton":
			countyCode = "057"
		case "Gallatin":
			countyCode = "059"
		case "Greene":
			countyCode = "061"
		case "Grundy":
			countyCode = "063"
		case "Hamilton":
			countyCode = "065"
		case "Hancock":
			countyCode = "067"
		case "Hardin":
			countyCode = "069"
		case "Henderson":
			countyCode = "071"
		case "Henry":
			countyCode = "073"
		case "Iroquois":
			countyCode = "075"
		case "Jackson":
			countyCode = "077"
		case "Jasper":
			countyCode = "079"
		case "Jefferson":
			countyCode = "081"
		case "Jersey":
			countyCode = "083"
		case "Jo Daviess":
			countyCode = "085"
		case "Johnson":
			countyCode = "087"
		case "Kane":
			countyCode = "089"
		case "Kankakee":
			countyCode = "091"
		case "Kendall":
			countyCode = "093"
		case "Knox":
			countyCode = "095"
		case "Lake":
			countyCode = "097"
		case "LaSalle":
			countyCode = "099"
		case "Lawrence":
			countyCode = "101"
		case "Lee":
			countyCode = "103"
		case "Livingston":
			countyCode = "105"
		case "Logan":
			countyCode = "107"
		case "McDonough":
			countyCode = "109"
		case "McHenry":
			countyCode = "111"
		case "McLean":
			countyCode = "113"
		case "Macon":
			countyCode = "115"
		case "Macoupin":
			countyCode = "117"
		case "Madison":
			countyCode = "119"
		case "Marion":
			countyCode = "121"
		case "Marshall":
			countyCode = "123"
		case "Mason":
			countyCode = "125"
		case "Massac":
			countyCode = "127"
		case "Menard":
			countyCode = "129"
		case "Mercer":
			countyCode = "131"
		case "Monroe":
			countyCode = "133"
		case "Montgomery":
			countyCode = "135"
		case "Morgan":
			countyCode = "137"
		case "Moultrie":
			countyCode = "139"
		case "Ogle":
			countyCode = "141"
		case "Peoria":
			countyCode = "143"
		case "Perry":
			countyCode = "145"
		case "Piatt":
			countyCode = "147"
		case "Pike":
			countyCode = "149"
		case "Pope":
			countyCode = "151"
		case "Pulaski":
			countyCode = "153"
		case "Putnam":
			countyCode = "155"
		case "Randolph":
			countyCode = "157"
		case "Richland":
			countyCode = "159"
		case "Rock Island":
			countyCode = "161"
		case "St. Clair":
			countyCode = "163"
		case "Saline":
			countyCode = "165"
		case "Sangamon":
			countyCode = "167"
		case "Schuyler":
			countyCode = "169"
		case "Scott":
			countyCode = "171"
		case "Shelby":
			countyCode = "173"
		case "Stark":
			countyCode = "175"
		case "Stephenson":
			countyCode = "177"
		case "Tazewell":
			countyCode = "179"
		case "Union":
			countyCode = "181"
		case "Vermilion":
			countyCode = "183"
		case "Wabash":
			countyCode = "185"
		case "Warren":
			countyCode = "187"
		case "Washington":
			countyCode = "189"
		case "Wayne":
			countyCode = "191"
		case "White":
			countyCode = "193"
		case "Whiteside":
			countyCode = "195"
		case "Will":
			countyCode = "197"
		case "Williamson":
			countyCode = "199"
		case "Winnebago":
			countyCode = "201"
		case "Woodford":
			countyCode = "203"
		}
	case "Indiana":
		stateCode = "18"
		switch county {
		case "Adams":
			countyCode = "001"
		case "Allen":
			countyCode = "003"
		case "Bartholomew":
			countyCode = "005"
		case "Benton":
			countyCode = "007"
		case "Blackford":
			countyCode = "009"
		case "Boone":
			countyCode = "011"
		case "Brown":
			countyCode = "013"
		case "Carroll":
			countyCode = "015"
		case "Cass":
			countyCode = "017"
		case "Clark":
			countyCode = "019"
		case "Clay":
			countyCode = "021"
		case "Clinton":
			countyCode = "023"
		case "Crawford":
			countyCode = "025"
		case "Daviess":
			countyCode = "027"
		case "Dearborn":
			countyCode = "029"
		case "Decatur":
			countyCode = "031"
		case "DeKalb":
			countyCode = "033"
		case "Delaware":
			countyCode = "035"
		case "Dubois":
			countyCode = "037"
		case "Elkhart":
			countyCode = "039"
		case "Fayette":
			countyCode = "041"
		case "Floyd":
			countyCode = "043"
		case "Fountain":
			countyCode = "045"
		case "Franklin":
			countyCode = "047"
		case "Fulton":
			countyCode = "049"
		case "Gibson":
			countyCode = "051"
		case "Grant":
			countyCode = "053"
		case "Greene":
			countyCode = "055"
		case "Hamilton":
			countyCode = "057"
		case "Hancock":
			countyCode = "059"
		case "Harrison":
			countyCode = "061"
		case "Hendricks":
			countyCode = "063"
		case "Henry":
			countyCode = "065"
		case "Howard":
			countyCode = "067"
		case "Huntington":
			countyCode = "069"
		case "Jackson":
			countyCode = "071"
		case "Jasper":
			countyCode = "073"
		case "Jay":
			countyCode = "075"
		case "Jefferson":
			countyCode = "077"
		case "Jennings":
			countyCode = "079"
		case "Johnson":
			countyCode = "081"
		case "Knox":
			countyCode = "083"
		case "Kosciusko":
			countyCode = "085"
		case "LaGrange":
			countyCode = "087"
		case "Lake":
			countyCode = "089"
		case "LaPorte":
			countyCode = "091"
		case "Lawrence":
			countyCode = "093"
		case "Madison":
			countyCode = "095"
		case "Marion":
			countyCode = "097"
		case "Marshall":
			countyCode = "099"
		case "Martin":
			countyCode = "101"
		case "Miami":
			countyCode = "103"
		case "Monroe":
			countyCode = "105"
		case "Montgomery":
			countyCode = "107"
		case "Morgan":
			countyCode = "109"
		case "Newton":
			countyCode = "111"
		case "Noble":
			countyCode = "113"
		case "Ohio":
			countyCode = "115"
		case "Orange":
			countyCode = "117"
		case "Owen":
			countyCode = "119"
		case "Parke":
			countyCode = "121"
		case "Perry":
			countyCode = "123"
		case "Pike":
			countyCode = "125"
		case "Porter":
			countyCode = "127"
		case "Posey":
			countyCode = "129"
		case "Pulaski":
			countyCode = "131"
		case "Putnam":
			countyCode = "133"
		case "Randolph":
			countyCode = "135"
		case "Ripley":
			countyCode = "137"
		case "Rush":
			countyCode = "139"
		case "St. Joseph":
			countyCode = "141"
		case "Scott":
			countyCode = "143"
		case "Shelby":
			countyCode = "145"
		case "Spencer":
			countyCode = "147"
		case "Starke":
			countyCode = "149"
		case "Steuben":
			countyCode = "151"
		case "Sullivan":
			countyCode = "153"
		case "Switzerland":
			countyCode = "155"
		case "Tippecanoe":
			countyCode = "157"
		case "Tipton":
			countyCode = "159"
		case "Union":
			countyCode = "161"
		case "Vanderburgh":
			countyCode = "163"
		case "Vermillion":
			countyCode = "165"
		case "Vigo":
			countyCode = "167"
		case "Wabash":
			countyCode = "169"
		case "Warren":
			countyCode = "171"
		case "Warrick":
			countyCode = "173"
		case "Washington":
			countyCode = "175"
		case "Wayne":
			countyCode = "177"
		case "Wells":
			countyCode = "179"
		case "White":
			countyCode = "181"
		case "Whitley":
			countyCode = "183"
		}
	case "Kansas":
		stateCode = "20"
		switch county {
		case "Allen":
			countyCode = "001"
		case "Anderson":
			countyCode = "003"
		case "Atchison":
			countyCode = "005"
		case "Barber":
			countyCode = "007"
		case "Barton":
			countyCode = "009"
		case "Bourbon":
			countyCode = "011"
		case "Brown":
			countyCode = "013"
		case "Butler":
			countyCode = "015"
		case "Chase":
			countyCode = "017"
		case "Chautauqua":
			countyCode = "019"
		case "Cherokee":
			countyCode = "021"
		case "Cheyenne":
			countyCode = "023"
		case "Clark":
			countyCode = "025"
		case "Clay":
			countyCode = "027"
		case "Cloud":
			countyCode = "029"
		case "Coffey":
			countyCode = "031"
		case "Comanche":
			countyCode = "033"
		case "Cowley":
			countyCode = "035"
		case "Crawford":
			countyCode = "037"
		case "Decatur":
			countyCode = "039"
		case "Dickinson":
			countyCode = "041"
		case "Doniphan":
			countyCode = "043"
		case "Douglas":
			countyCode = "045"
		case "Edwards":
			countyCode = "047"
		case "Elk":
			countyCode = "049"
		case "Ellis":
			countyCode = "051"
		case "Ellsworth":
			countyCode = "053"
		case "Finney":
			countyCode = "055"
		case "Ford":
			countyCode = "057"
		case "Franklin":
			countyCode = "059"
		case "Geary":
			countyCode = "061"
		case "Gove":
			countyCode = "063"
		case "Graham":
			countyCode = "065"
		case "Grant":
			countyCode = "067"
		case "Gray":
			countyCode = "069"
		case "Greeley":
			countyCode = "071"
		case "Greenwood":
			countyCode = "073"
		case "Hamilton":
			countyCode = "075"
		case "Harper":
			countyCode = "077"
		case "Harvey":
			countyCode = "079"
		case "Haskell":
			countyCode = "081"
		case "Hodgeman":
			countyCode = "083"
		case "Jackson":
			countyCode = "085"
		case "Jefferson":
			countyCode = "087"
		case "Jewell":
			countyCode = "089"
		case "Johnson":
			countyCode = "091"
		case "Kearny":
			countyCode = "093"
		case "Kingman":
			countyCode = "095"
		case "Kiowa":
			countyCode = "097"
		case "Labette":
			countyCode = "099"
		case "Lane":
			countyCode = "101"
		case "Leavenworth":
			countyCode = "103"
		case "Lincoln":
			countyCode = "105"
		case "Linn":
			countyCode = "107"
		case "Logan":
			countyCode = "109"
		case "Lyon":
			countyCode = "111"
		case "McPherson":
			countyCode = "113"
		case "Marion":
			countyCode = "115"
		case "Marshall":
			countyCode = "117"
		case "Meade":
			countyCode = "119"
		case "Miami":
			countyCode = "121"
		case "Mitchell":
			countyCode = "123"
		case "Montgomery":
			countyCode = "125"
		case "Morris":
			countyCode = "127"
		case "Morton":
			countyCode = "129"
		case "Nemaha":
			countyCode = "131"
		case "Neosho":
			countyCode = "133"
		case "Ness":
			countyCode = "135"
		case "Norton":
			countyCode = "137"
		case "Osage":
			countyCode = "139"
		case "Osborne":
			countyCode = "141"
		case "Ottawa":
			countyCode = "143"
		case "Pawnee":
			countyCode = "145"
		case "Phillips":
			countyCode = "147"
		case "Pottawatomie":
			countyCode = "149"
		case "Pratt":
			countyCode = "151"
		case "Rawlins":
			countyCode = "153"
		case "Reno":
			countyCode = "155"
		case "Republic":
			countyCode = "157"
		case "Rice":
			countyCode = "159"
		case "Riley":
			countyCode = "161"
		case "Rooks":
			countyCode = "163"
		case "Rush":
			countyCode = "165"
		case "Russell":
			countyCode = "167"
		case "Saline":
			countyCode = "169"
		case "Scott":
			countyCode = "171"
		case "Sedgwick":
			countyCode = "173"
		case "Seward":
			countyCode = "175"
		case "Shawnee":
			countyCode = "177"
		case "Sheridan":
			countyCode = "179"
		case "Sherman":
			countyCode = "181"
		case "Smith":
			countyCode = "183"
		case "Stafford":
			countyCode = "185"
		case "Stanton":
			countyCode = "187"
		case "Stevens":
			countyCode = "189"
		case "Sumner":
			countyCode = "191"
		case "Thomas":
			countyCode = "193"
		case "Trego":
			countyCode = "195"
		case "Wabaunsee":
			countyCode = "197"
		case "Wallace":
			countyCode = "199"
		case "Washington":
			countyCode = "201"
		case "Wichita":
			countyCode = "203"
		case "Wilson":
			countyCode = "205"
		case "Woodson":
			countyCode = "207"
		case "Wyandotte":
			countyCode = "209"
		}
	case "Kentucky":
		stateCode = "21"
		switch county {
		case "Adair":
			countyCode = "001"
		case "Allen":
			countyCode = "003"
		case "Anderson":
			countyCode = "005"
		case "Ballard":
			countyCode = "007"
		case "Barren":
			countyCode = "009"
		case "Bath":
			countyCode = "011"
		case "Bell":
			countyCode = "013"
		case "Boone":
			countyCode = "015"
		case "Bourbon":
			countyCode = "017"
		case "Boyd":
			countyCode = "019"
		case "Boyle":
			countyCode = "021"
		case "Bracken":
			countyCode = "023"
		case "Breathitt":
			countyCode = "025"
		case "Breckinridge":
			countyCode = "027"
		case "Bullitt":
			countyCode = "029"
		case "Butler":
			countyCode = "031"
		case "Caldwell":
			countyCode = "033"
		case "Calloway":
			countyCode = "035"
		case "Campbell":
			countyCode = "037"
		case "Carlisle":
			countyCode = "039"
		case "Carroll":
			countyCode = "041"
		case "Carter":
			countyCode = "043"
		case "Casey":
			countyCode = "045"
		case "Christian":
			countyCode = "047"
		case "Clark":
			countyCode = "049"
		case "Clay":
			countyCode = "051"
		case "Clinton":
			countyCode = "053"
		case "Crittenden":
			countyCode = "055"
		case "Cumberland":
			countyCode = "057"
		case "Daviess":
			countyCode = "059"
		case "Edmonson":
			countyCode = "061"
		case "Elliott":
			countyCode = "063"
		case "Estill":
			countyCode = "065"
		case "Fayette":
			countyCode = "067"
		case "Fleming":
			countyCode = "069"
		case "Floyd":
			countyCode = "071"
		case "Franklin":
			countyCode = "073"
		case "Fulton":
			countyCode = "075"
		case "Gallatin":
			countyCode = "077"
		case "Garrard":
			countyCode = "079"
		case "Grant":
			countyCode = "081"
		case "Graves":
			countyCode = "083"
		case "Grayson":
			countyCode = "085"
		case "Green":
			countyCode = "087"
		case "Greenup":
			countyCode = "089"
		case "Hancock":
			countyCode = "091"
		case "Hardin":
			countyCode = "093"
		case "Harlan":
			countyCode = "095"
		case "Harrison":
			countyCode = "097"
		case "Hart":
			countyCode = "099"
		case "Henderson":
			countyCode = "101"
		case "Henry":
			countyCode = "103"
		case "Hickman":
			countyCode = "105"
		case "Hopkins":
			countyCode = "107"
		case "Jackson":
			countyCode = "109"
		case "Jefferson":
			countyCode = "111"
		case "Jessamine":
			countyCode = "113"
		case "Johnson":
			countyCode = "115"
		case "Kenton":
			countyCode = "117"
		case "Knott":
			countyCode = "119"
		case "Knox":
			countyCode = "121"
		case "Larue":
			countyCode = "123"
		case "Laurel":
			countyCode = "125"
		case "Lawrence":
			countyCode = "127"
		case "Lee":
			countyCode = "129"
		case "Leslie":
			countyCode = "131"
		case "Letcher":
			countyCode = "133"
		case "Lewis":
			countyCode = "135"
		case "Lincoln":
			countyCode = "137"
		case "Livingston":
			countyCode = "139"
		case "Logan":
			countyCode = "141"
		case "Lyon":
			countyCode = "143"
		case "McCracken":
			countyCode = "145"
		case "McCreary":
			countyCode = "147"
		case "McLean":
			countyCode = "149"
		case "Madison":
			countyCode = "151"
		case "Magoffin":
			countyCode = "153"
		case "Marion":
			countyCode = "155"
		case "Marshall":
			countyCode = "157"
		case "Martin":
			countyCode = "159"
		case "Mason":
			countyCode = "161"
		case "Meade":
			countyCode = "163"
		case "Menifee":
			countyCode = "165"
		case "Mercer":
			countyCode = "167"
		case "Metcalfe":
			countyCode = "169"
		case "Monroe":
			countyCode = "171"
		case "Montgomery":
			countyCode = "173"
		case "Morgan":
			countyCode = "175"
		case "Muhlenberg":
			countyCode = "177"
		case "Nelson":
			countyCode = "179"
		case "Nicholas":
			countyCode = "181"
		case "Ohio":
			countyCode = "183"
		case "Oldham":
			countyCode = "185"
		case "Owen":
			countyCode = "187"
		case "Owsley":
			countyCode = "189"
		case "Pendleton":
			countyCode = "191"
		case "Perry":
			countyCode = "193"
		case "Pike":
			countyCode = "195"
		case "Powell":
			countyCode = "197"
		case "Pulaski":
			countyCode = "199"
		case "Robertson":
			countyCode = "201"
		case "Rockcastle":
			countyCode = "203"
		case "Rowan":
			countyCode = "205"
		case "Russell":
			countyCode = "207"
		case "Scott":
			countyCode = "209"
		case "Shelby":
			countyCode = "211"
		case "Simpson":
			countyCode = "213"
		case "Spencer":
			countyCode = "215"
		case "Taylor":
			countyCode = "217"
		case "Todd":
			countyCode = "219"
		case "Trigg":
			countyCode = "221"
		case "Trimble":
			countyCode = "223"
		case "Union":
			countyCode = "225"
		case "Warren":
			countyCode = "227"
		case "Washington":
			countyCode = "229"
		case "Wayne":
			countyCode = "231"
		case "Webster":
			countyCode = "233"
		case "Whitley":
			countyCode = "235"
		case "Wolfe":
			countyCode = "237"
		case "Woodford":
			countyCode = "239"
		}
	case "Louisiana":
		stateCode = "22"
		switch county {
		case "Acadia":
			countyCode = "001"
		case "Allen":
			countyCode = "003"
		case "Ascension":
			countyCode = "005"
		case "Assumption":
			countyCode = "007"
		case "Avoyelles":
			countyCode = "009"
		case "Beauregard":
			countyCode = "011"
		case "Bienville":
			countyCode = "013"
		case "Bossier":
			countyCode = "015"
		case "Caddo":
			countyCode = "017"
		case "Calcasieu":
			countyCode = "019"
		case "Caldwell":
			countyCode = "021"
		case "Cameron":
			countyCode = "023"
		case "Catahoula":
			countyCode = "025"
		case "Claiborne":
			countyCode = "027"
		case "Concordia":
			countyCode = "029"
		case "De Soto":
			countyCode = "031"
		case "East Baton Rouge":
			countyCode = "033"
		case "East Carroll":
			countyCode = "035"
		case "East Feliciana":
			countyCode = "037"
		case "Evangeline":
			countyCode = "039"
		case "Franklin":
			countyCode = "041"
		case "Grant":
			countyCode = "043"
		case "Iberia":
			countyCode = "045"
		case "Iberville":
			countyCode = "047"
		case "Jackson":
			countyCode = "049"
		case "Jefferson":
			countyCode = "051"
		case "Jefferson Davis":
			countyCode = "053"
		case "Lafayette":
			countyCode = "055"
		case "Lafourche":
			countyCode = "057"
		case "La Salle":
			countyCode = "059"
		case "Lincoln":
			countyCode = "061"
		case "Livingston":
			countyCode = "063"
		case "Madison":
			countyCode = "065"
		case "Morehouse":
			countyCode = "067"
		case "Natchitoches":
			countyCode = "069"
		case "Orleans":
			countyCode = "071"
		case "Ouachita":
			countyCode = "073"
		case "Plaquemines":
			countyCode = "075"
		case "Pointe Coupee":
			countyCode = "077"
		case "Rapides":
			countyCode = "079"
		case "Red River":
			countyCode = "081"
		case "Richland":
			countyCode = "083"
		case "Sabine":
			countyCode = "085"
		case "St. Bernard":
			countyCode = "087"
		case "St. Charles":
			countyCode = "089"
		case "St. Helena":
			countyCode = "091"
		case "St. James":
			countyCode = "093"
		case "St. John the Baptist":
			countyCode = "095"
		case "St. Landry":
			countyCode = "097"
		case "St. Martin":
			countyCode = "099"
		case "St. Mary":
			countyCode = "101"
		case "St. Tammany":
			countyCode = "103"
		case "Tangipahoa":
			countyCode = "105"
		case "Tensas":
			countyCode = "107"
		case "Terrebonne":
			countyCode = "109"
		case "Union":
			countyCode = "111"
		case "Vermilion":
			countyCode = "113"
		case "Vernon":
			countyCode = "115"
		case "Washington":
			countyCode = "117"
		case "Webster":
			countyCode = "119"
		case "West Baton Rouge":
			countyCode = "121"
		case "West Carroll":
			countyCode = "123"
		case "West Feliciana":
			countyCode = "125"
		case "Winn":
			countyCode = "127"
		}
	case "Massachusetts":
		stateCode = "25"
		switch county {
		case "Barnstable":
			countyCode = "001"
		case "Berkshire":
			countyCode = "003"
		case "Bristol":
			countyCode = "005"
		case "Dukes":
			countyCode = "007"
		case "Essex":
			countyCode = "009"
		case "Franklin":
			countyCode = "011"
		case "Hampden":
			countyCode = "013"
		case "Hampshire":
			countyCode = "015"
		case "Middlesex":
			countyCode = "017"
		case "Nantucket":
			countyCode = "019"
		case "Norfolk":
			countyCode = "021"
		case "Plymouth":
			countyCode = "023"
		case "Suffolk":
			countyCode = "025"
		case "Worcester":
			countyCode = "027"
		}
	case "Maryland":
		stateCode = "24"
		switch county {
		case "Allegany":
			countyCode = "001"
		case "Anne Arundel":
			countyCode = "003"
		case "Baltimore":
			countyCode = "005"
		case "Calvert":
			countyCode = "009"
		case "Caroline":
			countyCode = "011"
		case "Carroll":
			countyCode = "013"
		case "Cecil":
			countyCode = "015"
		case "Charles":
			countyCode = "017"
		case "Dorchester":
			countyCode = "019"
		case "Frederick":
			countyCode = "021"
		case "Garrett":
			countyCode = "023"
		case "Harford":
			countyCode = "025"
		case "Howard":
			countyCode = "027"
		case "Kent":
			countyCode = "029"
		case "Montgomery":
			countyCode = "031"
		case "Prince George's":
			countyCode = "033"
		case "Queen Anne's":
			countyCode = "035"
		case "St. Mary's":
			countyCode = "037"
		case "Somerset":
			countyCode = "039"
		case "Talbot":
			countyCode = "041"
		case "Washington":
			countyCode = "043"
		case "Wicomico":
			countyCode = "045"
		case "Worcester":
			countyCode = "047"
		case "Baltimore city":
			countyCode = "510"
		}
	case "Maine":
		stateCode = "23"
		switch county {
		case "Androscoggin":
			countyCode = "001"
		case "Aroostook":
			countyCode = "003"
		case "Cumberland":
			countyCode = "005"
		case "Franklin":
			countyCode = "007"
		case "Hancock":
			countyCode = "009"
		case "Kennebec":
			countyCode = "011"
		case "Knox":
			countyCode = "013"
		case "Lincoln":
			countyCode = "015"
		case "Oxford":
			countyCode = "017"
		case "Penobscot":
			countyCode = "019"
		case "Piscataquis":
			countyCode = "021"
		case "Sagadahoc":
			countyCode = "023"
		case "Somerset":
			countyCode = "025"
		case "Waldo":
			countyCode = "027"
		case "Washington":
			countyCode = "029"
		case "York":
			countyCode = "031"
		}
	case "Michigan":
		stateCode = "26"
		switch county {
		case "Alcona":
			countyCode = "001"
		case "Alger":
			countyCode = "003"
		case "Allegan":
			countyCode = "005"
		case "Alpena":
			countyCode = "007"
		case "Antrim":
			countyCode = "009"
		case "Arenac":
			countyCode = "011"
		case "Baraga":
			countyCode = "013"
		case "Barry":
			countyCode = "015"
		case "Bay":
			countyCode = "017"
		case "Benzie":
			countyCode = "019"
		case "Berrien":
			countyCode = "021"
		case "Branch":
			countyCode = "023"
		case "Calhoun":
			countyCode = "025"
		case "Cass":
			countyCode = "027"
		case "Charlevoix":
			countyCode = "029"
		case "Cheboygan":
			countyCode = "031"
		case "Chippewa":
			countyCode = "033"
		case "Clare":
			countyCode = "035"
		case "Clinton":
			countyCode = "037"
		case "Crawford":
			countyCode = "039"
		case "Delta":
			countyCode = "041"
		case "Dickinson":
			countyCode = "043"
		case "Eaton":
			countyCode = "045"
		case "Emmet":
			countyCode = "047"
		case "Genesee":
			countyCode = "049"
		case "Gladwin":
			countyCode = "051"
		case "Gogebic":
			countyCode = "053"
		case "Grand Traverse":
			countyCode = "055"
		case "Gratiot":
			countyCode = "057"
		case "Hillsdale":
			countyCode = "059"
		case "Houghton":
			countyCode = "061"
		case "Huron":
			countyCode = "063"
		case "Ingham":
			countyCode = "065"
		case "Ionia":
			countyCode = "067"
		case "Iosco":
			countyCode = "069"
		case "Iron":
			countyCode = "071"
		case "Isabella":
			countyCode = "073"
		case "Jackson":
			countyCode = "075"
		case "Kalamazoo":
			countyCode = "077"
		case "Kalkaska":
			countyCode = "079"
		case "Kent":
			countyCode = "081"
		case "Keweenaw":
			countyCode = "083"
		case "Lake":
			countyCode = "085"
		case "Lapeer":
			countyCode = "087"
		case "Leelanau":
			countyCode = "089"
		case "Lenawee":
			countyCode = "091"
		case "Livingston":
			countyCode = "093"
		case "Luce":
			countyCode = "095"
		case "Mackinac":
			countyCode = "097"
		case "Macomb":
			countyCode = "099"
		case "Manistee":
			countyCode = "101"
		case "Marquette":
			countyCode = "103"
		case "Mason":
			countyCode = "105"
		case "Mecosta":
			countyCode = "107"
		case "Menominee":
			countyCode = "109"
		case "Midland":
			countyCode = "111"
		case "Missaukee":
			countyCode = "113"
		case "Monroe":
			countyCode = "115"
		case "Montcalm":
			countyCode = "117"
		case "Montmorency":
			countyCode = "119"
		case "Muskegon":
			countyCode = "121"
		case "Newaygo":
			countyCode = "123"
		case "Oakland":
			countyCode = "125"
		case "Oceana":
			countyCode = "127"
		case "Ogemaw":
			countyCode = "129"
		case "Ontonagon":
			countyCode = "131"
		case "Osceola":
			countyCode = "133"
		case "Oscoda":
			countyCode = "135"
		case "Otsego":
			countyCode = "137"
		case "Ottawa":
			countyCode = "139"
		case "Presque Isle":
			countyCode = "141"
		case "Roscommon":
			countyCode = "143"
		case "Saginaw":
			countyCode = "145"
		case "St. Clair":
			countyCode = "147"
		case "St. Joseph":
			countyCode = "149"
		case "Sanilac":
			countyCode = "151"
		case "Schoolcraft":
			countyCode = "153"
		case "Shiawassee":
			countyCode = "155"
		case "Tuscola":
			countyCode = "157"
		case "Van Buren":
			countyCode = "159"
		case "Washtenaw":
			countyCode = "161"
		case "Wayne":
			countyCode = "163"
		case "Wexford":
			countyCode = "165"
		}
	case "Minnesota":
		stateCode = "27"
		switch county {
		case "Aitkin":
			countyCode = "001"
		case "Anoka":
			countyCode = "003"
		case "Becker":
			countyCode = "005"
		case "Beltrami":
			countyCode = "007"
		case "Benton":
			countyCode = "009"
		case "Big Stone":
			countyCode = "011"
		case "Blue Earth":
			countyCode = "013"
		case "Brown":
			countyCode = "015"
		case "Carlton":
			countyCode = "017"
		case "Carver":
			countyCode = "019"
		case "Cass":
			countyCode = "021"
		case "Chippewa":
			countyCode = "023"
		case "Chisago":
			countyCode = "025"
		case "Clay":
			countyCode = "027"
		case "Clearwater":
			countyCode = "029"
		case "Cook":
			countyCode = "031"
		case "Cottonwood":
			countyCode = "033"
		case "Crow Wing":
			countyCode = "035"
		case "Dakota":
			countyCode = "037"
		case "Dodge":
			countyCode = "039"
		case "Douglas":
			countyCode = "041"
		case "Faribault":
			countyCode = "043"
		case "Fillmore":
			countyCode = "045"
		case "Freeborn":
			countyCode = "047"
		case "Goodhue":
			countyCode = "049"
		case "Grant":
			countyCode = "051"
		case "Hennepin":
			countyCode = "053"
		case "Houston":
			countyCode = "055"
		case "Hubbard":
			countyCode = "057"
		case "Isanti":
			countyCode = "059"
		case "Itasca":
			countyCode = "061"
		case "Jackson":
			countyCode = "063"
		case "Kanabec":
			countyCode = "065"
		case "Kandiyohi":
			countyCode = "067"
		case "Kittson":
			countyCode = "069"
		case "Koochiching":
			countyCode = "071"
		case "Lac qui Parle":
			countyCode = "073"
		case "Lake":
			countyCode = "075"
		case "Lake of the Woods":
			countyCode = "077"
		case "Le Sueur":
			countyCode = "079"
		case "Lincoln":
			countyCode = "081"
		case "Lyon":
			countyCode = "083"
		case "McLeod":
			countyCode = "085"
		case "Mahnomen":
			countyCode = "087"
		case "Marshall":
			countyCode = "089"
		case "Martin":
			countyCode = "091"
		case "Meeker":
			countyCode = "093"
		case "Mille Lacs":
			countyCode = "095"
		case "Morrison":
			countyCode = "097"
		case "Mower":
			countyCode = "099"
		case "Murray":
			countyCode = "101"
		case "Nicollet":
			countyCode = "103"
		case "Nobles":
			countyCode = "105"
		case "Norman":
			countyCode = "107"
		case "Olmsted":
			countyCode = "109"
		case "Otter Tail":
			countyCode = "111"
		case "Pennington":
			countyCode = "113"
		case "Pine":
			countyCode = "115"
		case "Pipestone":
			countyCode = "117"
		case "Polk":
			countyCode = "119"
		case "Pope":
			countyCode = "121"
		case "Ramsey":
			countyCode = "123"
		case "Red Lake":
			countyCode = "125"
		case "Redwood":
			countyCode = "127"
		case "Renville":
			countyCode = "129"
		case "Rice":
			countyCode = "131"
		case "Rock":
			countyCode = "133"
		case "Roseau":
			countyCode = "135"
		case "St. Louis":
			countyCode = "137"
		case "Scott":
			countyCode = "139"
		case "Sherburne":
			countyCode = "141"
		case "Sibley":
			countyCode = "143"
		case "Stearns":
			countyCode = "145"
		case "Steele":
			countyCode = "147"
		case "Stevens":
			countyCode = "149"
		case "Swift":
			countyCode = "151"
		case "Todd":
			countyCode = "153"
		case "Traverse":
			countyCode = "155"
		case "Wabasha":
			countyCode = "157"
		case "Wadena":
			countyCode = "159"
		case "Waseca":
			countyCode = "161"
		case "Washington":
			countyCode = "163"
		case "Watonwan":
			countyCode = "165"
		case "Wilkin":
			countyCode = "167"
		case "Winona":
			countyCode = "169"
		case "Wright":
			countyCode = "171"
		}
	case "Missouri":
		stateCode = "29"
		switch county {
		case "Adair":
			countyCode = "001"
		case "Andrew":
			countyCode = "003"
		case "Atchison":
			countyCode = "005"
		case "Audrain":
			countyCode = "007"
		case "Barry":
			countyCode = "009"
		case "Barton":
			countyCode = "011"
		case "Bates":
			countyCode = "013"
		case "Benton":
			countyCode = "015"
		case "Bollinger":
			countyCode = "017"
		case "Boone":
			countyCode = "019"
		case "Buchanan":
			countyCode = "021"
		case "Butler":
			countyCode = "023"
		case "Caldwell":
			countyCode = "025"
		case "Callaway":
			countyCode = "027"
		case "Camden":
			countyCode = "029"
		case "Cape Girardeau":
			countyCode = "031"
		case "Carroll":
			countyCode = "033"
		case "Carter":
			countyCode = "035"
		case "Cass":
			countyCode = "037"
		case "Cedar":
			countyCode = "039"
		case "Chariton":
			countyCode = "041"
		case "Christian":
			countyCode = "043"
		case "Clark":
			countyCode = "045"
		case "Clay":
			countyCode = "047"
		case "Clinton":
			countyCode = "049"
		case "Cole":
			countyCode = "051"
		case "Cooper":
			countyCode = "053"
		case "Crawford":
			countyCode = "055"
		case "Dade":
			countyCode = "057"
		case "Dallas":
			countyCode = "059"
		case "Daviess":
			countyCode = "061"
		case "DeKalb":
			countyCode = "063"
		case "Dent":
			countyCode = "065"
		case "Douglas":
			countyCode = "067"
		case "Dunklin":
			countyCode = "069"
		case "Franklin":
			countyCode = "071"
		case "Gasconade":
			countyCode = "073"
		case "Gentry":
			countyCode = "075"
		case "Greene":
			countyCode = "077"
		case "Grundy":
			countyCode = "079"
		case "Harrison":
			countyCode = "081"
		case "Henry":
			countyCode = "083"
		case "Hickory":
			countyCode = "085"
		case "Holt":
			countyCode = "087"
		case "Howard":
			countyCode = "089"
		case "Howell":
			countyCode = "091"
		case "Iron":
			countyCode = "093"
		case "Jackson":
			countyCode = "095"
		case "Jasper":
			countyCode = "097"
		case "Jefferson":
			countyCode = "099"
		case "Johnson":
			countyCode = "101"
		case "Knox":
			countyCode = "103"
		case "Laclede":
			countyCode = "105"
		case "Lafayette":
			countyCode = "107"
		case "Lawrence":
			countyCode = "109"
		case "Lewis":
			countyCode = "111"
		case "Lincoln":
			countyCode = "113"
		case "Linn":
			countyCode = "115"
		case "Livingston":
			countyCode = "117"
		case "McDonald":
			countyCode = "119"
		case "Macon":
			countyCode = "121"
		case "Madison":
			countyCode = "123"
		case "Maries":
			countyCode = "125"
		case "Marion":
			countyCode = "127"
		case "Mercer":
			countyCode = "129"
		case "Miller":
			countyCode = "131"
		case "Mississippi":
			countyCode = "133"
		case "Moniteau":
			countyCode = "135"
		case "Monroe":
			countyCode = "137"
		case "Montgomery":
			countyCode = "139"
		case "Morgan":
			countyCode = "141"
		case "New Madrid":
			countyCode = "143"
		case "Newton":
			countyCode = "145"
		case "Nodaway":
			countyCode = "147"
		case "Oregon":
			countyCode = "149"
		case "Osage":
			countyCode = "151"
		case "Ozark":
			countyCode = "153"
		case "Pemiscot":
			countyCode = "155"
		case "Perry":
			countyCode = "157"
		case "Pettis":
			countyCode = "159"
		case "Phelps":
			countyCode = "161"
		case "Pike":
			countyCode = "163"
		case "Platte":
			countyCode = "165"
		case "Polk":
			countyCode = "167"
		case "Pulaski":
			countyCode = "169"
		case "Putnam":
			countyCode = "171"
		case "Ralls":
			countyCode = "173"
		case "Randolph":
			countyCode = "175"
		case "Ray":
			countyCode = "177"
		case "Reynolds":
			countyCode = "179"
		case "Ripley":
			countyCode = "181"
		case "St. Charles":
			countyCode = "183"
		case "St. Clair":
			countyCode = "185"
		case "Ste. Genevieve":
			countyCode = "186"
		case "St. Francois":
			countyCode = "187"
		case "St. Louis":
			countyCode = "189"
		case "Saline":
			countyCode = "195"
		case "Schuyler":
			countyCode = "197"
		case "Scotland":
			countyCode = "199"
		case "Scott":
			countyCode = "201"
		case "Shannon":
			countyCode = "203"
		case "Shelby":
			countyCode = "205"
		case "Stoddard":
			countyCode = "207"
		case "Stone":
			countyCode = "209"
		case "Sullivan":
			countyCode = "211"
		case "Taney":
			countyCode = "213"
		case "Texas":
			countyCode = "215"
		case "Vernon":
			countyCode = "217"
		case "Warren":
			countyCode = "219"
		case "Washington":
			countyCode = "221"
		case "Wayne":
			countyCode = "223"
		case "Webster":
			countyCode = "225"
		case "Worth":
			countyCode = "227"
		case "Wright":
			countyCode = "229"
		case "St. Louis city":
			countyCode = "510"
		}
	case "Mississippi":
		stateCode = "28"
		switch county {
		case "Adams":
			countyCode = "001"
		case "Alcorn":
			countyCode = "003"
		case "Amite":
			countyCode = "005"
		case "Attala":
			countyCode = "007"
		case "Benton":
			countyCode = "009"
		case "Bolivar":
			countyCode = "011"
		case "Calhoun":
			countyCode = "013"
		case "Carroll":
			countyCode = "015"
		case "Chickasaw":
			countyCode = "017"
		case "Choctaw":
			countyCode = "019"
		case "Claiborne":
			countyCode = "021"
		case "Clarke":
			countyCode = "023"
		case "Clay":
			countyCode = "025"
		case "Coahoma":
			countyCode = "027"
		case "Copiah":
			countyCode = "029"
		case "Covington":
			countyCode = "031"
		case "DeSoto":
			countyCode = "033"
		case "Forrest":
			countyCode = "035"
		case "Franklin":
			countyCode = "037"
		case "George":
			countyCode = "039"
		case "Greene":
			countyCode = "041"
		case "Grenada":
			countyCode = "043"
		case "Hancock":
			countyCode = "045"
		case "Harrison":
			countyCode = "047"
		case "Hinds":
			countyCode = "049"
		case "Holmes":
			countyCode = "051"
		case "Humphreys":
			countyCode = "053"
		case "Issaquena":
			countyCode = "055"
		case "Itawamba":
			countyCode = "057"
		case "Jackson":
			countyCode = "059"
		case "Jasper":
			countyCode = "061"
		case "Jefferson":
			countyCode = "063"
		case "Jefferson Davis":
			countyCode = "065"
		case "Jones":
			countyCode = "067"
		case "Kemper":
			countyCode = "069"
		case "Lafayette":
			countyCode = "071"
		case "Lamar":
			countyCode = "073"
		case "Lauderdale":
			countyCode = "075"
		case "Lawrence":
			countyCode = "077"
		case "Leake":
			countyCode = "079"
		case "Lee":
			countyCode = "081"
		case "Leflore":
			countyCode = "083"
		case "Lincoln":
			countyCode = "085"
		case "Lowndes":
			countyCode = "087"
		case "Madison":
			countyCode = "089"
		case "Marion":
			countyCode = "091"
		case "Marshall":
			countyCode = "093"
		case "Monroe":
			countyCode = "095"
		case "Montgomery":
			countyCode = "097"
		case "Neshoba":
			countyCode = "099"
		case "Newton":
			countyCode = "101"
		case "Noxubee":
			countyCode = "103"
		case "Oktibbeha":
			countyCode = "105"
		case "Panola":
			countyCode = "107"
		case "Pearl River":
			countyCode = "109"
		case "Perry":
			countyCode = "111"
		case "Pike":
			countyCode = "113"
		case "Pontotoc":
			countyCode = "115"
		case "Prentiss":
			countyCode = "117"
		case "Quitman":
			countyCode = "119"
		case "Rankin":
			countyCode = "121"
		case "Scott":
			countyCode = "123"
		case "Sharkey":
			countyCode = "125"
		case "Simpson":
			countyCode = "127"
		case "Smith":
			countyCode = "129"
		case "Stone":
			countyCode = "131"
		case "Sunflower":
			countyCode = "133"
		case "Tallahatchie":
			countyCode = "135"
		case "Tate":
			countyCode = "137"
		case "Tippah":
			countyCode = "139"
		case "Tishomingo":
			countyCode = "141"
		case "Tunica":
			countyCode = "143"
		case "Union":
			countyCode = "145"
		case "Walthall":
			countyCode = "147"
		case "Warren":
			countyCode = "149"
		case "Washington":
			countyCode = "151"
		case "Wayne":
			countyCode = "153"
		case "Webster":
			countyCode = "155"
		case "Wilkinson":
			countyCode = "157"
		case "Winston":
			countyCode = "159"
		case "Yalobusha":
			countyCode = "161"
		case "Yazoo":
			countyCode = "163"
		}
	case "Montana":
		stateCode = "30"
		switch county {
		case "Beaverhead":
			countyCode = "001"
		case "Big Horn":
			countyCode = "003"
		case "Blaine":
			countyCode = "005"
		case "Broadwater":
			countyCode = "007"
		case "Carbon":
			countyCode = "009"
		case "Carter":
			countyCode = "011"
		case "Cascade":
			countyCode = "013"
		case "Chouteau":
			countyCode = "015"
		case "Custer":
			countyCode = "017"
		case "Daniels":
			countyCode = "019"
		case "Dawson":
			countyCode = "021"
		case "Deer Lodge":
			countyCode = "023"
		case "Fallon":
			countyCode = "025"
		case "Fergus":
			countyCode = "027"
		case "Flathead":
			countyCode = "029"
		case "Gallatin":
			countyCode = "031"
		case "Garfield":
			countyCode = "033"
		case "Glacier":
			countyCode = "035"
		case "Golden Valley":
			countyCode = "037"
		case "Granite":
			countyCode = "039"
		case "Hill":
			countyCode = "041"
		case "Jefferson":
			countyCode = "043"
		case "Judith Basin":
			countyCode = "045"
		case "Lake":
			countyCode = "047"
		case "Lewis and Clark":
			countyCode = "049"
		case "Liberty":
			countyCode = "051"
		case "Lincoln":
			countyCode = "053"
		case "McCone":
			countyCode = "055"
		case "Madison":
			countyCode = "057"
		case "Meagher":
			countyCode = "059"
		case "Mineral":
			countyCode = "061"
		case "Missoula":
			countyCode = "063"
		case "Musselshell":
			countyCode = "065"
		case "Park":
			countyCode = "067"
		case "Petroleum":
			countyCode = "069"
		case "Phillips":
			countyCode = "071"
		case "Pondera":
			countyCode = "073"
		case "Powder River":
			countyCode = "075"
		case "Powell":
			countyCode = "077"
		case "Prairie":
			countyCode = "079"
		case "Ravalli":
			countyCode = "081"
		case "Richland":
			countyCode = "083"
		case "Roosevelt":
			countyCode = "085"
		case "Rosebud":
			countyCode = "087"
		case "Sanders":
			countyCode = "089"
		case "Sheridan":
			countyCode = "091"
		case "Silver Bow":
			countyCode = "093"
		case "Stillwater":
			countyCode = "095"
		case "Sweet Grass":
			countyCode = "097"
		case "Teton":
			countyCode = "099"
		case "Toole":
			countyCode = "101"
		case "Treasure":
			countyCode = "103"
		case "Valley":
			countyCode = "105"
		case "Wheatland":
			countyCode = "107"
		case "Wibaux":
			countyCode = "109"
		case "Yellowstone":
			countyCode = "111"
		}
	case "North Carolina":
		stateCode = "37"
		switch county {
		case "Alamance":
			countyCode = "001"
		case "Alexander":
			countyCode = "003"
		case "Alleghany":
			countyCode = "005"
		case "Anson":
			countyCode = "007"
		case "Ashe":
			countyCode = "009"
		case "Avery":
			countyCode = "011"
		case "Beaufort":
			countyCode = "013"
		case "Bertie":
			countyCode = "015"
		case "Bladen":
			countyCode = "017"
		case "Brunswick":
			countyCode = "019"
		case "Buncombe":
			countyCode = "021"
		case "Burke":
			countyCode = "023"
		case "Cabarrus":
			countyCode = "025"
		case "Caldwell":
			countyCode = "027"
		case "Camden":
			countyCode = "029"
		case "Carteret":
			countyCode = "031"
		case "Caswell":
			countyCode = "033"
		case "Catawba":
			countyCode = "035"
		case "Chatham":
			countyCode = "037"
		case "Cherokee":
			countyCode = "039"
		case "Chowan":
			countyCode = "041"
		case "Clay":
			countyCode = "043"
		case "Cleveland":
			countyCode = "045"
		case "Columbus":
			countyCode = "047"
		case "Craven":
			countyCode = "049"
		case "Cumberland":
			countyCode = "051"
		case "Currituck":
			countyCode = "053"
		case "Dare":
			countyCode = "055"
		case "Davidson":
			countyCode = "057"
		case "Davie":
			countyCode = "059"
		case "Duplin":
			countyCode = "061"
		case "Durham":
			countyCode = "063"
		case "Edgecombe":
			countyCode = "065"
		case "Forsyth":
			countyCode = "067"
		case "Franklin":
			countyCode = "069"
		case "Gaston":
			countyCode = "071"
		case "Gates":
			countyCode = "073"
		case "Graham":
			countyCode = "075"
		case "Granville":
			countyCode = "077"
		case "Greene":
			countyCode = "079"
		case "Guilford":
			countyCode = "081"
		case "Halifax":
			countyCode = "083"
		case "Harnett":
			countyCode = "085"
		case "Haywood":
			countyCode = "087"
		case "Henderson":
			countyCode = "089"
		case "Hertford":
			countyCode = "091"
		case "Hoke":
			countyCode = "093"
		case "Hyde":
			countyCode = "095"
		case "Iredell":
			countyCode = "097"
		case "Jackson":
			countyCode = "099"
		case "Johnston":
			countyCode = "101"
		case "Jones":
			countyCode = "103"
		case "Lee":
			countyCode = "105"
		case "Lenoir":
			countyCode = "107"
		case "Lincoln":
			countyCode = "109"
		case "McDowell":
			countyCode = "111"
		case "Macon":
			countyCode = "113"
		case "Madison":
			countyCode = "115"
		case "Martin":
			countyCode = "117"
		case "Mecklenburg":
			countyCode = "119"
		case "Mitchell":
			countyCode = "121"
		case "Montgomery":
			countyCode = "123"
		case "Moore":
			countyCode = "125"
		case "Nash":
			countyCode = "127"
		case "New Hanover":
			countyCode = "129"
		case "Northampton":
			countyCode = "131"
		case "Onslow":
			countyCode = "133"
		case "Orange":
			countyCode = "135"
		case "Pamlico":
			countyCode = "137"
		case "Pasquotank":
			countyCode = "139"
		case "Pender":
			countyCode = "141"
		case "Perquimans":
			countyCode = "143"
		case "Person":
			countyCode = "145"
		case "Pitt":
			countyCode = "147"
		case "Polk":
			countyCode = "149"
		case "Randolph":
			countyCode = "151"
		case "Richmond":
			countyCode = "153"
		case "Robeson":
			countyCode = "155"
		case "Rockingham":
			countyCode = "157"
		case "Rowan":
			countyCode = "159"
		case "Rutherford":
			countyCode = "161"
		case "Sampson":
			countyCode = "163"
		case "Scotland":
			countyCode = "165"
		case "Stanly":
			countyCode = "167"
		case "Stokes":
			countyCode = "169"
		case "Surry":
			countyCode = "171"
		case "Swain":
			countyCode = "173"
		case "Transylvania":
			countyCode = "175"
		case "Tyrrell":
			countyCode = "177"
		case "Union":
			countyCode = "179"
		case "Vance":
			countyCode = "181"
		case "Wake":
			countyCode = "183"
		case "Warren":
			countyCode = "185"
		case "Washington":
			countyCode = "187"
		case "Watauga":
			countyCode = "189"
		case "Wayne":
			countyCode = "191"
		case "Wilkes":
			countyCode = "193"
		case "Wilson":
			countyCode = "195"
		case "Yadkin":
			countyCode = "197"
		case "Yancey":
			countyCode = "199"
		}
	case "North Dakota":
		stateCode = "38"
		switch county {
		case "Adams":
			countyCode = "001"
		case "Barnes":
			countyCode = "003"
		case "Benson":
			countyCode = "005"
		case "Billings":
			countyCode = "007"
		case "Bottineau":
			countyCode = "009"
		case "Bowman":
			countyCode = "011"
		case "Burke":
			countyCode = "013"
		case "Burleigh":
			countyCode = "015"
		case "Cass":
			countyCode = "017"
		case "Cavalier":
			countyCode = "019"
		case "Dickey":
			countyCode = "021"
		case "Divide":
			countyCode = "023"
		case "Dunn":
			countyCode = "025"
		case "Eddy":
			countyCode = "027"
		case "Emmons":
			countyCode = "029"
		case "Foster":
			countyCode = "031"
		case "Golden Valley":
			countyCode = "033"
		case "Grand Forks":
			countyCode = "035"
		case "Grant":
			countyCode = "037"
		case "Griggs":
			countyCode = "039"
		case "Hettinger":
			countyCode = "041"
		case "Kidder":
			countyCode = "043"
		case "LaMoure":
			countyCode = "045"
		case "Logan":
			countyCode = "047"
		case "McHenry":
			countyCode = "049"
		case "McIntosh":
			countyCode = "051"
		case "McKenzie":
			countyCode = "053"
		case "McLean":
			countyCode = "055"
		case "Mercer":
			countyCode = "057"
		case "Morton":
			countyCode = "059"
		case "Mountrail":
			countyCode = "061"
		case "Nelson":
			countyCode = "063"
		case "Oliver":
			countyCode = "065"
		case "Pembina":
			countyCode = "067"
		case "Pierce":
			countyCode = "069"
		case "Ramsey":
			countyCode = "071"
		case "Ransom":
			countyCode = "073"
		case "Renville":
			countyCode = "075"
		case "Richland":
			countyCode = "077"
		case "Rolette":
			countyCode = "079"
		case "Sargent":
			countyCode = "081"
		case "Sheridan":
			countyCode = "083"
		case "Sioux":
			countyCode = "085"
		case "Slope":
			countyCode = "087"
		case "Stark":
			countyCode = "089"
		case "Steele":
			countyCode = "091"
		case "Stutsman":
			countyCode = "093"
		case "Towner":
			countyCode = "095"
		case "Traill":
			countyCode = "097"
		case "Walsh":
			countyCode = "099"
		case "Ward":
			countyCode = "101"
		case "Wells":
			countyCode = "103"
		case "Williams":
			countyCode = "105"
		}
	case "Nebraska":
		stateCode = "31"
		switch county {
		case "Adams":
			countyCode = "001"
		case "Antelope":
			countyCode = "003"
		case "Arthur":
			countyCode = "005"
		case "Banner":
			countyCode = "007"
		case "Blaine":
			countyCode = "009"
		case "Boone":
			countyCode = "011"
		case "Box Butte":
			countyCode = "013"
		case "Boyd":
			countyCode = "015"
		case "Brown":
			countyCode = "017"
		case "Buffalo":
			countyCode = "019"
		case "Burt":
			countyCode = "021"
		case "Butler":
			countyCode = "023"
		case "Cass":
			countyCode = "025"
		case "Cedar":
			countyCode = "027"
		case "Chase":
			countyCode = "029"
		case "Cherry":
			countyCode = "031"
		case "Cheyenne":
			countyCode = "033"
		case "Clay":
			countyCode = "035"
		case "Colfax":
			countyCode = "037"
		case "Cuming":
			countyCode = "039"
		case "Custer":
			countyCode = "041"
		case "Dakota":
			countyCode = "043"
		case "Dawes":
			countyCode = "045"
		case "Dawson":
			countyCode = "047"
		case "Deuel":
			countyCode = "049"
		case "Dixon":
			countyCode = "051"
		case "Dodge":
			countyCode = "053"
		case "Douglas":
			countyCode = "055"
		case "Dundy":
			countyCode = "057"
		case "Fillmore":
			countyCode = "059"
		case "Franklin":
			countyCode = "061"
		case "Frontier":
			countyCode = "063"
		case "Furnas":
			countyCode = "065"
		case "Gage":
			countyCode = "067"
		case "Garden":
			countyCode = "069"
		case "Garfield":
			countyCode = "071"
		case "Gosper":
			countyCode = "073"
		case "Grant":
			countyCode = "075"
		case "Greeley":
			countyCode = "077"
		case "Hall":
			countyCode = "079"
		case "Hamilton":
			countyCode = "081"
		case "Harlan":
			countyCode = "083"
		case "Hayes":
			countyCode = "085"
		case "Hitchcock":
			countyCode = "087"
		case "Holt":
			countyCode = "089"
		case "Hooker":
			countyCode = "091"
		case "Howard":
			countyCode = "093"
		case "Jefferson":
			countyCode = "095"
		case "Johnson":
			countyCode = "097"
		case "Kearney":
			countyCode = "099"
		case "Keith":
			countyCode = "101"
		case "Keya Paha":
			countyCode = "103"
		case "Kimball":
			countyCode = "105"
		case "Knox":
			countyCode = "107"
		case "Lancaster":
			countyCode = "109"
		case "Lincoln":
			countyCode = "111"
		case "Logan":
			countyCode = "113"
		case "Loup":
			countyCode = "115"
		case "McPherson":
			countyCode = "117"
		case "Madison":
			countyCode = "119"
		case "Merrick":
			countyCode = "121"
		case "Morrill":
			countyCode = "123"
		case "Nance":
			countyCode = "125"
		case "Nemaha":
			countyCode = "127"
		case "Nuckolls":
			countyCode = "129"
		case "Otoe":
			countyCode = "131"
		case "Pawnee":
			countyCode = "133"
		case "Perkins":
			countyCode = "135"
		case "Phelps":
			countyCode = "137"
		case "Pierce":
			countyCode = "139"
		case "Platte":
			countyCode = "141"
		case "Polk":
			countyCode = "143"
		case "Red Willow":
			countyCode = "145"
		case "Richardson":
			countyCode = "147"
		case "Rock":
			countyCode = "149"
		case "Saline":
			countyCode = "151"
		case "Sarpy":
			countyCode = "153"
		case "Saunders":
			countyCode = "155"
		case "Scotts Bluff":
			countyCode = "157"
		case "Seward":
			countyCode = "159"
		case "Sheridan":
			countyCode = "161"
		case "Sherman":
			countyCode = "163"
		case "Sioux":
			countyCode = "165"
		case "Stanton":
			countyCode = "167"
		case "Thayer":
			countyCode = "169"
		case "Thomas":
			countyCode = "171"
		case "Thurston":
			countyCode = "173"
		case "Valley":
			countyCode = "175"
		case "Washington":
			countyCode = "177"
		case "Wayne":
			countyCode = "179"
		case "Webster":
			countyCode = "181"
		case "Wheeler":
			countyCode = "183"
		case "York":
			countyCode = "185"
		}
	case "New Hampshire":
		stateCode = "33"
		switch county {
		case "Belknap":
			countyCode = "001"
		case "Carroll":
			countyCode = "003"
		case "Cheshire":
			countyCode = "005"
		case "Coos":
			countyCode = "007"
		case "Grafton":
			countyCode = "009"
		case "Hillsborough":
			countyCode = "011"
		case "Merrimack":
			countyCode = "013"
		case "Rockingham":
			countyCode = "015"
		case "Strafford":
			countyCode = "017"
		case "Sullivan":
			countyCode = "019"
		}
	case "New Jersey":
		stateCode = "34"
		switch county {
		case "Atlantic":
			countyCode = "001"
		case "Bergen":
			countyCode = "003"
		case "Burlington":
			countyCode = "005"
		case "Camden":
			countyCode = "007"
		case "Cape May":
			countyCode = "009"
		case "Cumberland":
			countyCode = "011"
		case "Essex":
			countyCode = "013"
		case "Gloucester":
			countyCode = "015"
		case "Hudson":
			countyCode = "017"
		case "Hunterdon":
			countyCode = "019"
		case "Mercer":
			countyCode = "021"
		case "Middlesex":
			countyCode = "023"
		case "Monmouth":
			countyCode = "025"
		case "Morris":
			countyCode = "027"
		case "Ocean":
			countyCode = "029"
		case "Passaic":
			countyCode = "031"
		case "Salem":
			countyCode = "033"
		case "Somerset":
			countyCode = "035"
		case "Sussex":
			countyCode = "037"
		case "Union":
			countyCode = "039"
		case "Warren":
			countyCode = "041"
		}
	case "New Mexico":
		stateCode = "35"
		switch county {
		case "Bernalillo":
			countyCode = "001"
		case "Catron":
			countyCode = "003"
		case "Chaves":
			countyCode = "005"
		case "Cibola":
			countyCode = "006"
		case "Colfax":
			countyCode = "007"
		case "Curry":
			countyCode = "009"
		case "De Baca":
			countyCode = "011"
		case "Doña Ana":
			countyCode = "013"
		case "Eddy":
			countyCode = "015"
		case "Grant":
			countyCode = "017"
		case "Guadalupe":
			countyCode = "019"
		case "Harding":
			countyCode = "021"
		case "Hidalgo":
			countyCode = "023"
		case "Lea":
			countyCode = "025"
		case "Lincoln":
			countyCode = "027"
		case "Los Alamos":
			countyCode = "028"
		case "Luna":
			countyCode = "029"
		case "McKinley":
			countyCode = "031"
		case "Mora":
			countyCode = "033"
		case "Otero":
			countyCode = "035"
		case "Quay":
			countyCode = "037"
		case "Rio Arriba":
			countyCode = "039"
		case "Roosevelt":
			countyCode = "041"
		case "Sandoval":
			countyCode = "043"
		case "San Juan":
			countyCode = "045"
		case "San Miguel":
			countyCode = "047"
		case "Santa Fe":
			countyCode = "049"
		case "Sierra":
			countyCode = "051"
		case "Socorro":
			countyCode = "053"
		case "Taos":
			countyCode = "055"
		case "Torrance":
			countyCode = "057"
		case "Union":
			countyCode = "059"
		case "Valencia":
			countyCode = "061"
		}
	case "Nevada":
		stateCode = "32"
		switch county {
		case "Churchill":
			countyCode = "001"
		case "Clark":
			countyCode = "003"
		case "Douglas":
			countyCode = "005"
		case "Elko":
			countyCode = "007"
		case "Esmeralda":
			countyCode = "009"
		case "Eureka":
			countyCode = "011"
		case "Humboldt":
			countyCode = "013"
		case "Lander":
			countyCode = "015"
		case "Lincoln":
			countyCode = "017"
		case "Lyon":
			countyCode = "019"
		case "Mineral":
			countyCode = "021"
		case "Nye":
			countyCode = "023"
		case "Pershing":
			countyCode = "027"
		case "Storey":
			countyCode = "029"
		case "Washoe":
			countyCode = "031"
		case "White Pine":
			countyCode = "033"
		case "Carson City":
			countyCode = "510"
		}
	case "New York":
		stateCode = "36"
		switch county {
		case "Albany":
			countyCode = "001"
		case "Allegany":
			countyCode = "003"
		case "Bronx":
			countyCode = "005"
		case "Broome":
			countyCode = "007"
		case "Cattaraugus":
			countyCode = "009"
		case "Cayuga":
			countyCode = "011"
		case "Chautauqua":
			countyCode = "013"
		case "Chemung":
			countyCode = "015"
		case "Chenango":
			countyCode = "017"
		case "Clinton":
			countyCode = "019"
		case "Columbia":
			countyCode = "021"
		case "Cortland":
			countyCode = "023"
		case "Delaware":
			countyCode = "025"
		case "Dutchess":
			countyCode = "027"
		case "Erie":
			countyCode = "029"
		case "Essex":
			countyCode = "031"
		case "Franklin":
			countyCode = "033"
		case "Fulton":
			countyCode = "035"
		case "Genesee":
			countyCode = "037"
		case "Greene":
			countyCode = "039"
		case "Hamilton":
			countyCode = "041"
		case "Herkimer":
			countyCode = "043"
		case "Jefferson":
			countyCode = "045"
		case "Kings":
			countyCode = "047"
		case "Lewis":
			countyCode = "049"
		case "Livingston":
			countyCode = "051"
		case "Madison":
			countyCode = "053"
		case "Monroe":
			countyCode = "055"
		case "Montgomery":
			countyCode = "057"
		case "Nassau":
			countyCode = "059"
		case "New York":
			countyCode = "061"
		case "Niagara":
			countyCode = "063"
		case "Oneida":
			countyCode = "065"
		case "Onondaga":
			countyCode = "067"
		case "Ontario":
			countyCode = "069"
		case "Orange":
			countyCode = "071"
		case "Orleans":
			countyCode = "073"
		case "Oswego":
			countyCode = "075"
		case "Otsego":
			countyCode = "077"
		case "Putnam":
			countyCode = "079"
		case "Queens":
			countyCode = "081"
		case "Rensselaer":
			countyCode = "083"
		case "Richmond":
			countyCode = "085"
		case "Rockland":
			countyCode = "087"
		case "St. Lawrence":
			countyCode = "089"
		case "Saratoga":
			countyCode = "091"
		case "Schenectady":
			countyCode = "093"
		case "Schoharie":
			countyCode = "095"
		case "Schuyler":
			countyCode = "097"
		case "Seneca":
			countyCode = "099"
		case "Steuben":
			countyCode = "101"
		case "Suffolk":
			countyCode = "103"
		case "Sullivan":
			countyCode = "105"
		case "Tioga":
			countyCode = "107"
		case "Tompkins":
			countyCode = "109"
		case "Ulster":
			countyCode = "111"
		case "Warren":
			countyCode = "113"
		case "Washington":
			countyCode = "115"
		case "Wayne":
			countyCode = "117"
		case "Westchester":
			countyCode = "119"
		case "Wyoming":
			countyCode = "121"
		case "Yates":
			countyCode = "123"
		}
	case "Ohio":
		stateCode = "39"
		switch county {
		case "Adams":
			countyCode = "001"
		case "Allen":
			countyCode = "003"
		case "Ashland":
			countyCode = "005"
		case "Ashtabula":
			countyCode = "007"
		case "Athens":
			countyCode = "009"
		case "Auglaize":
			countyCode = "011"
		case "Belmont":
			countyCode = "013"
		case "Brown":
			countyCode = "015"
		case "Butler":
			countyCode = "017"
		case "Carroll":
			countyCode = "019"
		case "Champaign":
			countyCode = "021"
		case "Clark":
			countyCode = "023"
		case "Clermont":
			countyCode = "025"
		case "Clinton":
			countyCode = "027"
		case "Columbiana":
			countyCode = "029"
		case "Coshocton":
			countyCode = "031"
		case "Crawford":
			countyCode = "033"
		case "Cuyahoga":
			countyCode = "035"
		case "Darke":
			countyCode = "037"
		case "Defiance":
			countyCode = "039"
		case "Delaware":
			countyCode = "041"
		case "Erie":
			countyCode = "043"
		case "Fairfield":
			countyCode = "045"
		case "Fayette":
			countyCode = "047"
		case "Franklin":
			countyCode = "049"
		case "Fulton":
			countyCode = "051"
		case "Gallia":
			countyCode = "053"
		case "Geauga":
			countyCode = "055"
		case "Greene":
			countyCode = "057"
		case "Guernsey":
			countyCode = "059"
		case "Hamilton":
			countyCode = "061"
		case "Hancock":
			countyCode = "063"
		case "Hardin":
			countyCode = "065"
		case "Harrison":
			countyCode = "067"
		case "Henry":
			countyCode = "069"
		case "Highland":
			countyCode = "071"
		case "Hocking":
			countyCode = "073"
		case "Holmes":
			countyCode = "075"
		case "Huron":
			countyCode = "077"
		case "Jackson":
			countyCode = "079"
		case "Jefferson":
			countyCode = "081"
		case "Knox":
			countyCode = "083"
		case "Lake":
			countyCode = "085"
		case "Lawrence":
			countyCode = "087"
		case "Licking":
			countyCode = "089"
		case "Logan":
			countyCode = "091"
		case "Lorain":
			countyCode = "093"
		case "Lucas":
			countyCode = "095"
		case "Madison":
			countyCode = "097"
		case "Mahoning":
			countyCode = "099"
		case "Marion":
			countyCode = "101"
		case "Medina":
			countyCode = "103"
		case "Meigs":
			countyCode = "105"
		case "Mercer":
			countyCode = "107"
		case "Miami":
			countyCode = "109"
		case "Monroe":
			countyCode = "111"
		case "Montgomery":
			countyCode = "113"
		case "Morgan":
			countyCode = "115"
		case "Morrow":
			countyCode = "117"
		case "Muskingum":
			countyCode = "119"
		case "Noble":
			countyCode = "121"
		case "Ottawa":
			countyCode = "123"
		case "Paulding":
			countyCode = "125"
		case "Perry":
			countyCode = "127"
		case "Pickaway":
			countyCode = "129"
		case "Pike":
			countyCode = "131"
		case "Portage":
			countyCode = "133"
		case "Preble":
			countyCode = "135"
		case "Putnam":
			countyCode = "137"
		case "Richland":
			countyCode = "139"
		case "Ross":
			countyCode = "141"
		case "Sandusky":
			countyCode = "143"
		case "Scioto":
			countyCode = "145"
		case "Seneca":
			countyCode = "147"
		case "Shelby":
			countyCode = "149"
		case "Stark":
			countyCode = "151"
		case "Summit":
			countyCode = "153"
		case "Trumbull":
			countyCode = "155"
		case "Tuscarawas":
			countyCode = "157"
		case "Union":
			countyCode = "159"
		case "Van Wert":
			countyCode = "161"
		case "Vinton":
			countyCode = "163"
		case "Warren":
			countyCode = "165"
		case "Washington":
			countyCode = "167"
		case "Wayne":
			countyCode = "169"
		case "Williams":
			countyCode = "171"
		case "Wood":
			countyCode = "173"
		case "Wyandot":
			countyCode = "175"
		}
	case "Oklahoma":
		stateCode = "40"
		switch county {
		case "Adair":
			countyCode = "001"
		case "Alfalfa":
			countyCode = "003"
		case "Atoka":
			countyCode = "005"
		case "Beaver":
			countyCode = "007"
		case "Beckham":
			countyCode = "009"
		case "Blaine":
			countyCode = "011"
		case "Bryan":
			countyCode = "013"
		case "Caddo":
			countyCode = "015"
		case "Canadian":
			countyCode = "017"
		case "Carter":
			countyCode = "019"
		case "Cherokee":
			countyCode = "021"
		case "Choctaw":
			countyCode = "023"
		case "Cimarron":
			countyCode = "025"
		case "Cleveland":
			countyCode = "027"
		case "Coal":
			countyCode = "029"
		case "Comanche":
			countyCode = "031"
		case "Cotton":
			countyCode = "033"
		case "Craig":
			countyCode = "035"
		case "Creek":
			countyCode = "037"
		case "Custer":
			countyCode = "039"
		case "Delaware":
			countyCode = "041"
		case "Dewey":
			countyCode = "043"
		case "Ellis":
			countyCode = "045"
		case "Garfield":
			countyCode = "047"
		case "Garvin":
			countyCode = "049"
		case "Grady":
			countyCode = "051"
		case "Grant":
			countyCode = "053"
		case "Greer":
			countyCode = "055"
		case "Harmon":
			countyCode = "057"
		case "Harper":
			countyCode = "059"
		case "Haskell":
			countyCode = "061"
		case "Hughes":
			countyCode = "063"
		case "Jackson":
			countyCode = "065"
		case "Jefferson":
			countyCode = "067"
		case "Johnston":
			countyCode = "069"
		case "Kay":
			countyCode = "071"
		case "Kingfisher":
			countyCode = "073"
		case "Kiowa":
			countyCode = "075"
		case "Latimer":
			countyCode = "077"
		case "Le Flore":
			countyCode = "079"
		case "Lincoln":
			countyCode = "081"
		case "Logan":
			countyCode = "083"
		case "Love":
			countyCode = "085"
		case "McClain":
			countyCode = "087"
		case "McCurtain":
			countyCode = "089"
		case "McIntosh":
			countyCode = "091"
		case "Major":
			countyCode = "093"
		case "Marshall":
			countyCode = "095"
		case "Mayes":
			countyCode = "097"
		case "Murray":
			countyCode = "099"
		case "Muskogee":
			countyCode = "101"
		case "Noble":
			countyCode = "103"
		case "Nowata":
			countyCode = "105"
		case "Okfuskee":
			countyCode = "107"
		case "Oklahoma":
			countyCode = "109"
		case "Okmulgee":
			countyCode = "111"
		case "Osage":
			countyCode = "113"
		case "Ottawa":
			countyCode = "115"
		case "Pawnee":
			countyCode = "117"
		case "Payne":
			countyCode = "119"
		case "Pittsburg":
			countyCode = "121"
		case "Pontotoc":
			countyCode = "123"
		case "Pottawatomie":
			countyCode = "125"
		case "Pushmataha":
			countyCode = "127"
		case "Roger Mills":
			countyCode = "129"
		case "Rogers":
			countyCode = "131"
		case "Seminole":
			countyCode = "133"
		case "Sequoyah":
			countyCode = "135"
		case "Stephens":
			countyCode = "137"
		case "Texas":
			countyCode = "139"
		case "Tillman":
			countyCode = "141"
		case "Tulsa":
			countyCode = "143"
		case "Wagoner":
			countyCode = "145"
		case "Washington":
			countyCode = "147"
		case "Washita":
			countyCode = "149"
		case "Woods":
			countyCode = "151"
		case "Woodward":
			countyCode = "153"
		}
	case "Oregon":
		stateCode = "41"
		switch county {
		case "Baker":
			countyCode = "001"
		case "Benton":
			countyCode = "003"
		case "Clackamas":
			countyCode = "005"
		case "Clatsop":
			countyCode = "007"
		case "Columbia":
			countyCode = "009"
		case "Coos":
			countyCode = "011"
		case "Crook":
			countyCode = "013"
		case "Curry":
			countyCode = "015"
		case "Deschutes":
			countyCode = "017"
		case "Douglas":
			countyCode = "019"
		case "Gilliam":
			countyCode = "021"
		case "Grant":
			countyCode = "023"
		case "Harney":
			countyCode = "025"
		case "Hood River":
			countyCode = "027"
		case "Jackson":
			countyCode = "029"
		case "Jefferson":
			countyCode = "031"
		case "Josephine":
			countyCode = "033"
		case "Klamath":
			countyCode = "035"
		case "Lake":
			countyCode = "037"
		case "Lane":
			countyCode = "039"
		case "Lincoln":
			countyCode = "041"
		case "Linn":
			countyCode = "043"
		case "Malheur":
			countyCode = "045"
		case "Marion":
			countyCode = "047"
		case "Morrow":
			countyCode = "049"
		case "Multnomah":
			countyCode = "051"
		case "Polk":
			countyCode = "053"
		case "Sherman":
			countyCode = "055"
		case "Tillamook":
			countyCode = "057"
		case "Umatilla":
			countyCode = "059"
		case "Union":
			countyCode = "061"
		case "Wallowa":
			countyCode = "063"
		case "Wasco":
			countyCode = "065"
		case "Washington":
			countyCode = "067"
		case "Wheeler":
			countyCode = "069"
		case "Yamhill":
			countyCode = "071"
		}
	case "Pennsylvania":
		stateCode = "42"
		switch county {
		case "Adams":
			countyCode = "001"
		case "Allegheny":
			countyCode = "003"
		case "Armstrong":
			countyCode = "005"
		case "Beaver":
			countyCode = "007"
		case "Bedford":
			countyCode = "009"
		case "Berks":
			countyCode = "011"
		case "Blair":
			countyCode = "013"
		case "Bradford":
			countyCode = "015"
		case "Bucks":
			countyCode = "017"
		case "Butler":
			countyCode = "019"
		case "Cambria":
			countyCode = "021"
		case "Cameron":
			countyCode = "023"
		case "Carbon":
			countyCode = "025"
		case "Centre":
			countyCode = "027"
		case "Chester":
			countyCode = "029"
		case "Clarion":
			countyCode = "031"
		case "Clearfield":
			countyCode = "033"
		case "Clinton":
			countyCode = "035"
		case "Columbia":
			countyCode = "037"
		case "Crawford":
			countyCode = "039"
		case "Cumberland":
			countyCode = "041"
		case "Dauphin":
			countyCode = "043"
		case "Delaware":
			countyCode = "045"
		case "Elk":
			countyCode = "047"
		case "Erie":
			countyCode = "049"
		case "Fayette":
			countyCode = "051"
		case "Forest":
			countyCode = "053"
		case "Franklin":
			countyCode = "055"
		case "Fulton":
			countyCode = "057"
		case "Greene":
			countyCode = "059"
		case "Huntingdon":
			countyCode = "061"
		case "Indiana":
			countyCode = "063"
		case "Jefferson":
			countyCode = "065"
		case "Juniata":
			countyCode = "067"
		case "Lackawanna":
			countyCode = "069"
		case "Lancaster":
			countyCode = "071"
		case "Lawrence":
			countyCode = "073"
		case "Lebanon":
			countyCode = "075"
		case "Lehigh":
			countyCode = "077"
		case "Luzerne":
			countyCode = "079"
		case "Lycoming":
			countyCode = "081"
		case "McKean":
			countyCode = "083"
		case "Mercer":
			countyCode = "085"
		case "Mifflin":
			countyCode = "087"
		case "Monroe":
			countyCode = "089"
		case "Montgomery":
			countyCode = "091"
		case "Montour":
			countyCode = "093"
		case "Northampton":
			countyCode = "095"
		case "Northumberland":
			countyCode = "097"
		case "Perry":
			countyCode = "099"
		case "Philadelphia":
			countyCode = "101"
		case "Pike":
			countyCode = "103"
		case "Potter":
			countyCode = "105"
		case "Schuylkill":
			countyCode = "107"
		case "Snyder":
			countyCode = "109"
		case "Somerset":
			countyCode = "111"
		case "Sullivan":
			countyCode = "113"
		case "Susquehanna":
			countyCode = "115"
		case "Tioga":
			countyCode = "117"
		case "Union":
			countyCode = "119"
		case "Venango":
			countyCode = "121"
		case "Warren":
			countyCode = "123"
		case "Washington":
			countyCode = "125"
		case "Wayne":
			countyCode = "127"
		case "Westmoreland":
			countyCode = "129"
		case "Wyoming":
			countyCode = "131"
		case "York":
			countyCode = "133"
		}
	case "Puerto Rico":
		stateCode = "72"
		switch county {
		case "Adjuntas Municipio":
			countyCode = "001"
		case "Aguada Municipio":
			countyCode = "003"
		case "Aguadilla Municipio":
			countyCode = "005"
		case "Aguas Buenas Municipio":
			countyCode = "007"
		case "Aibonito Municipio":
			countyCode = "009"
		case "Añasco Municipio":
			countyCode = "011"
		case "Arecibo Municipio":
			countyCode = "013"
		case "Arroyo Municipio":
			countyCode = "015"
		case "Barceloneta Municipio":
			countyCode = "017"
		case "Barranquitas Municipio":
			countyCode = "019"
		case "Bayamón Municipio":
			countyCode = "021"
		case "Cabo Rojo Municipio":
			countyCode = "023"
		case "Caguas Municipio":
			countyCode = "025"
		case "Camuy Municipio":
			countyCode = "027"
		case "Canóvanas Municipio":
			countyCode = "029"
		case "Carolina Municipio":
			countyCode = "031"
		case "Cataño Municipio":
			countyCode = "033"
		case "Cayey Municipio":
			countyCode = "035"
		case "Ceiba Municipio":
			countyCode = "037"
		case "Ciales Municipio":
			countyCode = "039"
		case "Cidra Municipio":
			countyCode = "041"
		case "Coamo Municipio":
			countyCode = "043"
		case "Comerío Municipio":
			countyCode = "045"
		case "Corozal Municipio":
			countyCode = "047"
		case "Culebra Municipio":
			countyCode = "049"
		case "Dorado Municipio":
			countyCode = "051"
		case "Fajardo Municipio":
			countyCode = "053"
		case "Florida Municipio":
			countyCode = "054"
		case "Guánica Municipio":
			countyCode = "055"
		case "Guayama Municipio":
			countyCode = "057"
		case "Guayanilla Municipio":
			countyCode = "059"
		case "Guaynabo Municipio":
			countyCode = "061"
		case "Gurabo Municipio":
			countyCode = "063"
		case "Hatillo Municipio":
			countyCode = "065"
		case "Hormigueros Municipio":
			countyCode = "067"
		case "Humacao Municipio":
			countyCode = "069"
		case "Isabela Municipio":
			countyCode = "071"
		case "Jayuya Municipio":
			countyCode = "073"
		case "Juana Díaz Municipio":
			countyCode = "075"
		case "Juncos Municipio":
			countyCode = "077"
		case "Lajas Municipio":
			countyCode = "079"
		case "Lares Municipio":
			countyCode = "081"
		case "Las Marías Municipio":
			countyCode = "083"
		case "Las Piedras Municipio":
			countyCode = "085"
		case "Loíza Municipio":
			countyCode = "087"
		case "Luquillo Municipio":
			countyCode = "089"
		case "Manatí Municipio":
			countyCode = "091"
		case "Maricao Municipio":
			countyCode = "093"
		case "Maunabo Municipio":
			countyCode = "095"
		case "Mayagüez Municipio":
			countyCode = "097"
		case "Moca Municipio":
			countyCode = "099"
		case "Morovis Municipio":
			countyCode = "101"
		case "Naguabo Municipio":
			countyCode = "103"
		case "Naranjito Municipio":
			countyCode = "105"
		case "Orocovis Municipio":
			countyCode = "107"
		case "Patillas Municipio":
			countyCode = "109"
		case "Peñuelas Municipio":
			countyCode = "111"
		case "Ponce Municipio":
			countyCode = "113"
		case "Quebradillas Municipio":
			countyCode = "115"
		case "Rincón Municipio":
			countyCode = "117"
		case "Río Grande Municipio":
			countyCode = "119"
		case "Sabana Grande Municipio":
			countyCode = "121"
		case "Salinas Municipio":
			countyCode = "123"
		case "San Germán Municipio":
			countyCode = "125"
		case "San Juan Municipio":
			countyCode = "127"
		case "San Lorenzo Municipio":
			countyCode = "129"
		case "San Sebastián Municipio":
			countyCode = "131"
		case "Santa Isabel Municipio":
			countyCode = "133"
		case "Toa Alta Municipio":
			countyCode = "135"
		case "Toa Baja Municipio":
			countyCode = "137"
		case "Trujillo Alto Municipio":
			countyCode = "139"
		case "Utuado Municipio":
			countyCode = "141"
		case "Vega Alta Municipio":
			countyCode = "143"
		case "Vega Baja Municipio":
			countyCode = "145"
		case "Vieques Municipio":
			countyCode = "147"
		case "Villalba Municipio":
			countyCode = "149"
		case "Yabucoa Municipio":
			countyCode = "151"
		case "Yauco Municipio":
			countyCode = "153"
		}
	case "Rhode Island":
		stateCode = "44"
		switch county {
		case "Bristol":
			countyCode = "001"
		case "Kent":
			countyCode = "003"
		case "Newport":
			countyCode = "005"
		case "Providence":
			countyCode = "007"
		case "Washington":
			countyCode = "009"
		}
	case "South Carolina":
		stateCode = "45"
		switch county {
		case "Abbeville":
			countyCode = "001"
		case "Aiken":
			countyCode = "003"
		case "Allendale":
			countyCode = "005"
		case "Anderson":
			countyCode = "007"
		case "Bamberg":
			countyCode = "009"
		case "Barnwell":
			countyCode = "011"
		case "Beaufort":
			countyCode = "013"
		case "Berkeley":
			countyCode = "015"
		case "Calhoun":
			countyCode = "017"
		case "Charleston":
			countyCode = "019"
		case "Cherokee":
			countyCode = "021"
		case "Chester":
			countyCode = "023"
		case "Chesterfield":
			countyCode = "025"
		case "Clarendon":
			countyCode = "027"
		case "Colleton":
			countyCode = "029"
		case "Darlington":
			countyCode = "031"
		case "Dillon":
			countyCode = "033"
		case "Dorchester":
			countyCode = "035"
		case "Edgefield":
			countyCode = "037"
		case "Fairfield":
			countyCode = "039"
		case "Florence":
			countyCode = "041"
		case "Georgetown":
			countyCode = "043"
		case "Greenville":
			countyCode = "045"
		case "Greenwood":
			countyCode = "047"
		case "Hampton":
			countyCode = "049"
		case "Horry":
			countyCode = "051"
		case "Jasper":
			countyCode = "053"
		case "Kershaw":
			countyCode = "055"
		case "Lancaster":
			countyCode = "057"
		case "Laurens":
			countyCode = "059"
		case "Lee":
			countyCode = "061"
		case "Lexington":
			countyCode = "063"
		case "McCormick":
			countyCode = "065"
		case "Marion":
			countyCode = "067"
		case "Marlboro":
			countyCode = "069"
		case "Newberry":
			countyCode = "071"
		case "Oconee":
			countyCode = "073"
		case "Orangeburg":
			countyCode = "075"
		case "Pickens":
			countyCode = "077"
		case "Richland":
			countyCode = "079"
		case "Saluda":
			countyCode = "081"
		case "Spartanburg":
			countyCode = "083"
		case "Sumter":
			countyCode = "085"
		case "Union":
			countyCode = "087"
		case "Williamsburg":
			countyCode = "089"
		case "York":
			countyCode = "091"
		}
	case "South Dakota":
		stateCode = "46"
		switch county {
		case "Aurora":
			countyCode = "003"
		case "Beadle":
			countyCode = "005"
		case "Bennett":
			countyCode = "007"
		case "Bon Homme":
			countyCode = "009"
		case "Brookings":
			countyCode = "011"
		case "Brown":
			countyCode = "013"
		case "Brule":
			countyCode = "015"
		case "Buffalo":
			countyCode = "017"
		case "Butte":
			countyCode = "019"
		case "Campbell":
			countyCode = "021"
		case "Charles Mix":
			countyCode = "023"
		case "Clark":
			countyCode = "025"
		case "Clay":
			countyCode = "027"
		case "Codington":
			countyCode = "029"
		case "Corson":
			countyCode = "031"
		case "Custer":
			countyCode = "033"
		case "Davison":
			countyCode = "035"
		case "Day":
			countyCode = "037"
		case "Deuel":
			countyCode = "039"
		case "Dewey":
			countyCode = "041"
		case "Douglas":
			countyCode = "043"
		case "Edmunds":
			countyCode = "045"
		case "Fall River":
			countyCode = "047"
		case "Faulk":
			countyCode = "049"
		case "Grant":
			countyCode = "051"
		case "Gregory":
			countyCode = "053"
		case "Haakon":
			countyCode = "055"
		case "Hamlin":
			countyCode = "057"
		case "Hand":
			countyCode = "059"
		case "Hanson":
			countyCode = "061"
		case "Harding":
			countyCode = "063"
		case "Hughes":
			countyCode = "065"
		case "Hutchinson":
			countyCode = "067"
		case "Hyde":
			countyCode = "069"
		case "Jackson":
			countyCode = "071"
		case "Jerauld":
			countyCode = "073"
		case "Jones":
			countyCode = "075"
		case "Kingsbury":
			countyCode = "077"
		case "Lake":
			countyCode = "079"
		case "Lawrence":
			countyCode = "081"
		case "Lincoln":
			countyCode = "083"
		case "Lyman":
			countyCode = "085"
		case "McCook":
			countyCode = "087"
		case "McPherson":
			countyCode = "089"
		case "Marshall":
			countyCode = "091"
		case "Meade":
			countyCode = "093"
		case "Mellette":
			countyCode = "095"
		case "Miner":
			countyCode = "097"
		case "Minnehaha":
			countyCode = "099"
		case "Moody":
			countyCode = "101"
		case "Pennington":
			countyCode = "103"
		case "Perkins":
			countyCode = "105"
		case "Potter":
			countyCode = "107"
		case "Roberts":
			countyCode = "109"
		case "Sanborn":
			countyCode = "111"
		case "Shannon":
			countyCode = "113"
		case "Spink":
			countyCode = "115"
		case "Stanley":
			countyCode = "117"
		case "Sully":
			countyCode = "119"
		case "Todd":
			countyCode = "121"
		case "Tripp":
			countyCode = "123"
		case "Turner":
			countyCode = "125"
		case "Union":
			countyCode = "127"
		case "Walworth":
			countyCode = "129"
		case "Yankton":
			countyCode = "135"
		case "Ziebach":
			countyCode = "137"
		}
	case "Tennessee":
		stateCode = "47"
		switch county {
		case "Anderson":
			countyCode = "001"
		case "Bedford":
			countyCode = "003"
		case "Benton":
			countyCode = "005"
		case "Bledsoe":
			countyCode = "007"
		case "Blount":
			countyCode = "009"
		case "Bradley":
			countyCode = "011"
		case "Campbell":
			countyCode = "013"
		case "Cannon":
			countyCode = "015"
		case "Carroll":
			countyCode = "017"
		case "Carter":
			countyCode = "019"
		case "Cheatham":
			countyCode = "021"
		case "Chester":
			countyCode = "023"
		case "Claiborne":
			countyCode = "025"
		case "Clay":
			countyCode = "027"
		case "Cocke":
			countyCode = "029"
		case "Coffee":
			countyCode = "031"
		case "Crockett":
			countyCode = "033"
		case "Cumberland":
			countyCode = "035"
		case "Davidson":
			countyCode = "037"
		case "Decatur":
			countyCode = "039"
		case "DeKalb":
			countyCode = "041"
		case "Dickson":
			countyCode = "043"
		case "Dyer":
			countyCode = "045"
		case "Fayette":
			countyCode = "047"
		case "Fentress":
			countyCode = "049"
		case "Franklin":
			countyCode = "051"
		case "Gibson":
			countyCode = "053"
		case "Giles":
			countyCode = "055"
		case "Grainger":
			countyCode = "057"
		case "Greene":
			countyCode = "059"
		case "Grundy":
			countyCode = "061"
		case "Hamblen":
			countyCode = "063"
		case "Hamilton":
			countyCode = "065"
		case "Hancock":
			countyCode = "067"
		case "Hardeman":
			countyCode = "069"
		case "Hardin":
			countyCode = "071"
		case "Hawkins":
			countyCode = "073"
		case "Haywood":
			countyCode = "075"
		case "Henderson":
			countyCode = "077"
		case "Henry":
			countyCode = "079"
		case "Hickman":
			countyCode = "081"
		case "Houston":
			countyCode = "083"
		case "Humphreys":
			countyCode = "085"
		case "Jackson":
			countyCode = "087"
		case "Jefferson":
			countyCode = "089"
		case "Johnson":
			countyCode = "091"
		case "Knox":
			countyCode = "093"
		case "Lake":
			countyCode = "095"
		case "Lauderdale":
			countyCode = "097"
		case "Lawrence":
			countyCode = "099"
		case "Lewis":
			countyCode = "101"
		case "Lincoln":
			countyCode = "103"
		case "Loudon":
			countyCode = "105"
		case "McMinn":
			countyCode = "107"
		case "McNairy":
			countyCode = "109"
		case "Macon":
			countyCode = "111"
		case "Madison":
			countyCode = "113"
		case "Marion":
			countyCode = "115"
		case "Marshall":
			countyCode = "117"
		case "Maury":
			countyCode = "119"
		case "Meigs":
			countyCode = "121"
		case "Monroe":
			countyCode = "123"
		case "Montgomery":
			countyCode = "125"
		case "Moore":
			countyCode = "127"
		case "Morgan":
			countyCode = "129"
		case "Obion":
			countyCode = "131"
		case "Overton":
			countyCode = "133"
		case "Perry":
			countyCode = "135"
		case "Pickett":
			countyCode = "137"
		case "Polk":
			countyCode = "139"
		case "Putnam":
			countyCode = "141"
		case "Rhea":
			countyCode = "143"
		case "Roane":
			countyCode = "145"
		case "Robertson":
			countyCode = "147"
		case "Rutherford":
			countyCode = "149"
		case "Scott":
			countyCode = "151"
		case "Sequatchie":
			countyCode = "153"
		case "Sevier":
			countyCode = "155"
		case "Shelby":
			countyCode = "157"
		case "Smith":
			countyCode = "159"
		case "Stewart":
			countyCode = "161"
		case "Sullivan":
			countyCode = "163"
		case "Sumner":
			countyCode = "165"
		case "Tipton":
			countyCode = "167"
		case "Trousdale":
			countyCode = "169"
		case "Unicoi":
			countyCode = "171"
		case "Union":
			countyCode = "173"
		case "Van Buren":
			countyCode = "175"
		case "Warren":
			countyCode = "177"
		case "Washington":
			countyCode = "179"
		case "Wayne":
			countyCode = "181"
		case "Weakley":
			countyCode = "183"
		case "White":
			countyCode = "185"
		case "Williamson":
			countyCode = "187"
		case "Wilson":
			countyCode = "189"
		}
	case "Texas":
		stateCode = "48"
		switch county {
		case "Anderson":
			countyCode = "001"
		case "Andrews":
			countyCode = "003"
		case "Angelina":
			countyCode = "005"
		case "Aransas":
			countyCode = "007"
		case "Archer":
			countyCode = "009"
		case "Armstrong":
			countyCode = "011"
		case "Atascosa":
			countyCode = "013"
		case "Austin":
			countyCode = "015"
		case "Bailey":
			countyCode = "017"
		case "Bandera":
			countyCode = "019"
		case "Bastrop":
			countyCode = "021"
		case "Baylor":
			countyCode = "023"
		case "Bee":
			countyCode = "025"
		case "Bell":
			countyCode = "027"
		case "Bexar":
			countyCode = "029"
		case "Blanco":
			countyCode = "031"
		case "Borden":
			countyCode = "033"
		case "Bosque":
			countyCode = "035"
		case "Bowie":
			countyCode = "037"
		case "Brazoria":
			countyCode = "039"
		case "Brazos":
			countyCode = "041"
		case "Brewster":
			countyCode = "043"
		case "Briscoe":
			countyCode = "045"
		case "Brooks":
			countyCode = "047"
		case "Brown":
			countyCode = "049"
		case "Burleson":
			countyCode = "051"
		case "Burnet":
			countyCode = "053"
		case "Caldwell":
			countyCode = "055"
		case "Calhoun":
			countyCode = "057"
		case "Callahan":
			countyCode = "059"
		case "Cameron":
			countyCode = "061"
		case "Camp":
			countyCode = "063"
		case "Carson":
			countyCode = "065"
		case "Cass":
			countyCode = "067"
		case "Castro":
			countyCode = "069"
		case "Chambers":
			countyCode = "071"
		case "Cherokee":
			countyCode = "073"
		case "Childress":
			countyCode = "075"
		case "Clay":
			countyCode = "077"
		case "Cochran":
			countyCode = "079"
		case "Coke":
			countyCode = "081"
		case "Coleman":
			countyCode = "083"
		case "Collin":
			countyCode = "085"
		case "Collingsworth":
			countyCode = "087"
		case "Colorado":
			countyCode = "089"
		case "Comal":
			countyCode = "091"
		case "Comanche":
			countyCode = "093"
		case "Concho":
			countyCode = "095"
		case "Cooke":
			countyCode = "097"
		case "Coryell":
			countyCode = "099"
		case "Cottle":
			countyCode = "101"
		case "Crane":
			countyCode = "103"
		case "Crockett":
			countyCode = "105"
		case "Crosby":
			countyCode = "107"
		case "Culberson":
			countyCode = "109"
		case "Dallam":
			countyCode = "111"
		case "Dallas":
			countyCode = "113"
		case "Dawson":
			countyCode = "115"
		case "Deaf Smith":
			countyCode = "117"
		case "Delta":
			countyCode = "119"
		case "Denton":
			countyCode = "121"
		case "DeWitt":
			countyCode = "123"
		case "Dickens":
			countyCode = "125"
		case "Dimmit":
			countyCode = "127"
		case "Donley":
			countyCode = "129"
		case "Duval":
			countyCode = "131"
		case "Eastland":
			countyCode = "133"
		case "Ector":
			countyCode = "135"
		case "Edwards":
			countyCode = "137"
		case "Ellis":
			countyCode = "139"
		case "El Paso":
			countyCode = "141"
		case "Erath":
			countyCode = "143"
		case "Falls":
			countyCode = "145"
		case "Fannin":
			countyCode = "147"
		case "Fayette":
			countyCode = "149"
		case "Fisher":
			countyCode = "151"
		case "Floyd":
			countyCode = "153"
		case "Foard":
			countyCode = "155"
		case "Fort Bend":
			countyCode = "157"
		case "Franklin":
			countyCode = "159"
		case "Freestone":
			countyCode = "161"
		case "Frio":
			countyCode = "163"
		case "Gaines":
			countyCode = "165"
		case "Galveston":
			countyCode = "167"
		case "Garza":
			countyCode = "169"
		case "Gillespie":
			countyCode = "171"
		case "Glasscock":
			countyCode = "173"
		case "Goliad":
			countyCode = "175"
		case "Gonzales":
			countyCode = "177"
		case "Gray":
			countyCode = "179"
		case "Grayson":
			countyCode = "181"
		case "Gregg":
			countyCode = "183"
		case "Grimes":
			countyCode = "185"
		case "Guadalupe":
			countyCode = "187"
		case "Hale":
			countyCode = "189"
		case "Hall":
			countyCode = "191"
		case "Hamilton":
			countyCode = "193"
		case "Hansford":
			countyCode = "195"
		case "Hardeman":
			countyCode = "197"
		case "Hardin":
			countyCode = "199"
		case "Harris":
			countyCode = "201"
		case "Harrison":
			countyCode = "203"
		case "Hartley":
			countyCode = "205"
		case "Haskell":
			countyCode = "207"
		case "Hays":
			countyCode = "209"
		case "Hemphill":
			countyCode = "211"
		case "Henderson":
			countyCode = "213"
		case "Hidalgo":
			countyCode = "215"
		case "Hill":
			countyCode = "217"
		case "Hockley":
			countyCode = "219"
		case "Hood":
			countyCode = "221"
		case "Hopkins":
			countyCode = "223"
		case "Houston":
			countyCode = "225"
		case "Howard":
			countyCode = "227"
		case "Hudspeth":
			countyCode = "229"
		case "Hunt":
			countyCode = "231"
		case "Hutchinson":
			countyCode = "233"
		case "Irion":
			countyCode = "235"
		case "Jack":
			countyCode = "237"
		case "Jackson":
			countyCode = "239"
		case "Jasper":
			countyCode = "241"
		case "Jeff Davis":
			countyCode = "243"
		case "Jefferson":
			countyCode = "245"
		case "Jim Hogg":
			countyCode = "247"
		case "Jim Wells":
			countyCode = "249"
		case "Johnson":
			countyCode = "251"
		case "Jones":
			countyCode = "253"
		case "Karnes":
			countyCode = "255"
		case "Kaufman":
			countyCode = "257"
		case "Kendall":
			countyCode = "259"
		case "Kenedy":
			countyCode = "261"
		case "Kent":
			countyCode = "263"
		case "Kerr":
			countyCode = "265"
		case "Kimble":
			countyCode = "267"
		case "King":
			countyCode = "269"
		case "Kinney":
			countyCode = "271"
		case "Kleberg":
			countyCode = "273"
		case "Knox":
			countyCode = "275"
		case "Lamar":
			countyCode = "277"
		case "Lamb":
			countyCode = "279"
		case "Lampasas":
			countyCode = "281"
		case "La Salle":
			countyCode = "283"
		case "Lavaca":
			countyCode = "285"
		case "Lee":
			countyCode = "287"
		case "Leon":
			countyCode = "289"
		case "Liberty":
			countyCode = "291"
		case "Limestone":
			countyCode = "293"
		case "Lipscomb":
			countyCode = "295"
		case "Live Oak":
			countyCode = "297"
		case "Llano":
			countyCode = "299"
		case "Loving":
			countyCode = "301"
		case "Lubbock":
			countyCode = "303"
		case "Lynn":
			countyCode = "305"
		case "McCulloch":
			countyCode = "307"
		case "McLennan":
			countyCode = "309"
		case "McMullen":
			countyCode = "311"
		case "Madison":
			countyCode = "313"
		case "Marion":
			countyCode = "315"
		case "Martin":
			countyCode = "317"
		case "Mason":
			countyCode = "319"
		case "Matagorda":
			countyCode = "321"
		case "Maverick":
			countyCode = "323"
		case "Medina":
			countyCode = "325"
		case "Menard":
			countyCode = "327"
		case "Midland":
			countyCode = "329"
		case "Milam":
			countyCode = "331"
		case "Mills":
			countyCode = "333"
		case "Mitchell":
			countyCode = "335"
		case "Montague":
			countyCode = "337"
		case "Montgomery":
			countyCode = "339"
		case "Moore":
			countyCode = "341"
		case "Morris":
			countyCode = "343"
		case "Motley":
			countyCode = "345"
		case "Nacogdoches":
			countyCode = "347"
		case "Navarro":
			countyCode = "349"
		case "Newton":
			countyCode = "351"
		case "Nolan":
			countyCode = "353"
		case "Nueces":
			countyCode = "355"
		case "Ochiltree":
			countyCode = "357"
		case "Oldham":
			countyCode = "359"
		case "Orange":
			countyCode = "361"
		case "Palo Pinto":
			countyCode = "363"
		case "Panola":
			countyCode = "365"
		case "Parker":
			countyCode = "367"
		case "Parmer":
			countyCode = "369"
		case "Pecos":
			countyCode = "371"
		case "Polk":
			countyCode = "373"
		case "Potter":
			countyCode = "375"
		case "Presidio":
			countyCode = "377"
		case "Rains":
			countyCode = "379"
		case "Randall":
			countyCode = "381"
		case "Reagan":
			countyCode = "383"
		case "Real":
			countyCode = "385"
		case "Red River":
			countyCode = "387"
		case "Reeves":
			countyCode = "389"
		case "Refugio":
			countyCode = "391"
		case "Roberts":
			countyCode = "393"
		case "Robertson":
			countyCode = "395"
		case "Rockwall":
			countyCode = "397"
		case "Runnels":
			countyCode = "399"
		case "Rusk":
			countyCode = "401"
		case "Sabine":
			countyCode = "403"
		case "San Augustine":
			countyCode = "405"
		case "San Jacinto":
			countyCode = "407"
		case "San Patricio":
			countyCode = "409"
		case "San Saba":
			countyCode = "411"
		case "Schleicher":
			countyCode = "413"
		case "Scurry":
			countyCode = "415"
		case "Shackelford":
			countyCode = "417"
		case "Shelby":
			countyCode = "419"
		case "Sherman":
			countyCode = "421"
		case "Smith":
			countyCode = "423"
		case "Somervell":
			countyCode = "425"
		case "Starr":
			countyCode = "427"
		case "Stephens":
			countyCode = "429"
		case "Sterling":
			countyCode = "431"
		case "Stonewall":
			countyCode = "433"
		case "Sutton":
			countyCode = "435"
		case "Swisher":
			countyCode = "437"
		case "Tarrant":
			countyCode = "439"
		case "Taylor":
			countyCode = "441"
		case "Terrell":
			countyCode = "443"
		case "Terry":
			countyCode = "445"
		case "Throckmorton":
			countyCode = "447"
		case "Titus":
			countyCode = "449"
		case "Tom Green":
			countyCode = "451"
		case "Travis":
			countyCode = "453"
		case "Trinity":
			countyCode = "455"
		case "Tyler":
			countyCode = "457"
		case "Upshur":
			countyCode = "459"
		case "Upton":
			countyCode = "461"
		case "Uvalde":
			countyCode = "463"
		case "Val Verde":
			countyCode = "465"
		case "Van Zandt":
			countyCode = "467"
		case "Victoria":
			countyCode = "469"
		case "Walker":
			countyCode = "471"
		case "Waller":
			countyCode = "473"
		case "Ward":
			countyCode = "475"
		case "Washington":
			countyCode = "477"
		case "Webb":
			countyCode = "479"
		case "Wharton":
			countyCode = "481"
		case "Wheeler":
			countyCode = "483"
		case "Wichita":
			countyCode = "485"
		case "Wilbarger":
			countyCode = "487"
		case "Willacy":
			countyCode = "489"
		case "Williamson":
			countyCode = "491"
		case "Wilson":
			countyCode = "493"
		case "Winkler":
			countyCode = "495"
		case "Wise":
			countyCode = "497"
		case "Wood":
			countyCode = "499"
		case "Yoakum":
			countyCode = "501"
		case "Young":
			countyCode = "503"
		case "Zapata":
			countyCode = "505"
		case "Zavala":
			countyCode = "507"
		}
	case "Utah":
		stateCode = "49"
		switch county {
		case "Beaver":
			countyCode = "001"
		case "Box Elder":
			countyCode = "003"
		case "Cache":
			countyCode = "005"
		case "Carbon":
			countyCode = "007"
		case "Daggett":
			countyCode = "009"
		case "Davis":
			countyCode = "011"
		case "Duchesne":
			countyCode = "013"
		case "Emery":
			countyCode = "015"
		case "Garfield":
			countyCode = "017"
		case "Grand":
			countyCode = "019"
		case "Iron":
			countyCode = "021"
		case "Juab":
			countyCode = "023"
		case "Kane":
			countyCode = "025"
		case "Millard":
			countyCode = "027"
		case "Morgan":
			countyCode = "029"
		case "Piute":
			countyCode = "031"
		case "Rich":
			countyCode = "033"
		case "Salt Lake":
			countyCode = "035"
		case "San Juan":
			countyCode = "037"
		case "Sanpete":
			countyCode = "039"
		case "Sevier":
			countyCode = "041"
		case "Summit":
			countyCode = "043"
		case "Tooele":
			countyCode = "045"
		case "Uintah":
			countyCode = "047"
		case "Utah":
			countyCode = "049"
		case "Wasatch":
			countyCode = "051"
		case "Washington":
			countyCode = "053"
		case "Wayne":
			countyCode = "055"
		case "Weber":
			countyCode = "057"
		}
	case "Virginia":
		stateCode = "51"
		switch county {
		case "Accomack":
			countyCode = "001"
		case "Albemarle":
			countyCode = "003"
		case "Alleghany":
			countyCode = "005"
		case "Amelia":
			countyCode = "007"
		case "Amherst":
			countyCode = "009"
		case "Appomattox":
			countyCode = "011"
		case "Arlington":
			countyCode = "013"
		case "Augusta":
			countyCode = "015"
		case "Bath":
			countyCode = "017"
		case "Bedford":
			countyCode = "019"
		case "Bland":
			countyCode = "021"
		case "Botetourt":
			countyCode = "023"
		case "Brunswick":
			countyCode = "025"
		case "Buchanan":
			countyCode = "027"
		case "Buckingham":
			countyCode = "029"
		case "Campbell":
			countyCode = "031"
		case "Caroline":
			countyCode = "033"
		case "Carroll":
			countyCode = "035"
		case "Charles City":
			countyCode = "036"
		case "Charlotte":
			countyCode = "037"
		case "Chesterfield":
			countyCode = "041"
		case "Clarke":
			countyCode = "043"
		case "Craig":
			countyCode = "045"
		case "Culpeper":
			countyCode = "047"
		case "Cumberland":
			countyCode = "049"
		case "Dickenson":
			countyCode = "051"
		case "Dinwiddie":
			countyCode = "053"
		case "Essex":
			countyCode = "057"
		case "Fairfax":
			countyCode = "059"
		case "Fauquier":
			countyCode = "061"
		case "Floyd":
			countyCode = "063"
		case "Fluvanna":
			countyCode = "065"
		case "Franklin":
			countyCode = "067"
		case "Frederick":
			countyCode = "069"
		case "Giles":
			countyCode = "071"
		case "Gloucester":
			countyCode = "073"
		case "Goochland":
			countyCode = "075"
		case "Grayson":
			countyCode = "077"
		case "Greene":
			countyCode = "079"
		case "Greensville":
			countyCode = "081"
		case "Halifax":
			countyCode = "083"
		case "Hanover":
			countyCode = "085"
		case "Henrico":
			countyCode = "087"
		case "Henry":
			countyCode = "089"
		case "Highland":
			countyCode = "091"
		case "Isle of Wight":
			countyCode = "093"
		case "James City":
			countyCode = "095"
		case "King and Queen":
			countyCode = "097"
		case "King George":
			countyCode = "099"
		case "King William":
			countyCode = "101"
		case "Lancaster":
			countyCode = "103"
		case "Lee":
			countyCode = "105"
		case "Loudoun":
			countyCode = "107"
		case "Louisa":
			countyCode = "109"
		case "Lunenburg":
			countyCode = "111"
		case "Madison":
			countyCode = "113"
		case "Mathews":
			countyCode = "115"
		case "Mecklenburg":
			countyCode = "117"
		case "Middlesex":
			countyCode = "119"
		case "Montgomery":
			countyCode = "121"
		case "Nelson":
			countyCode = "125"
		case "New Kent":
			countyCode = "127"
		case "Northampton":
			countyCode = "131"
		case "Northumberland":
			countyCode = "133"
		case "Nottoway":
			countyCode = "135"
		case "Orange":
			countyCode = "137"
		case "Page":
			countyCode = "139"
		case "Patrick":
			countyCode = "141"
		case "Pittsylvania":
			countyCode = "143"
		case "Powhatan":
			countyCode = "145"
		case "Prince Edward":
			countyCode = "147"
		case "Prince George":
			countyCode = "149"
		case "Prince William":
			countyCode = "153"
		case "Pulaski":
			countyCode = "155"
		case "Rappahannock":
			countyCode = "157"
		case "Richmond":
			countyCode = "159"
		case "Roanoke":
			countyCode = "161"
		case "Rockbridge":
			countyCode = "163"
		case "Rockingham":
			countyCode = "165"
		case "Russell":
			countyCode = "167"
		case "Scott":
			countyCode = "169"
		case "Shenandoah":
			countyCode = "171"
		case "Smyth":
			countyCode = "173"
		case "Southampton":
			countyCode = "175"
		case "Spotsylvania":
			countyCode = "177"
		case "Stafford":
			countyCode = "179"
		case "Surry":
			countyCode = "181"
		case "Sussex":
			countyCode = "183"
		case "Tazewell":
			countyCode = "185"
		case "Warren":
			countyCode = "187"
		case "Washington":
			countyCode = "191"
		case "Westmoreland":
			countyCode = "193"
		case "Wise":
			countyCode = "195"
		case "Wythe":
			countyCode = "197"
		case "York":
			countyCode = "199"
		case "Alexandria city":
			countyCode = "510"
		case "Bedford city":
			countyCode = "515"
		case "Bristol city":
			countyCode = "520"
		case "Buena Vista city":
			countyCode = "530"
		case "Charlottesville city":
			countyCode = "540"
		case "Chesapeake city":
			countyCode = "550"
		case "Colonial Heights city":
			countyCode = "570"
		case "Covington city":
			countyCode = "580"
		case "Danville city":
			countyCode = "590"
		case "Emporia city":
			countyCode = "595"
		case "Fairfax city":
			countyCode = "600"
		case "Falls Church city":
			countyCode = "610"
		case "Franklin city":
			countyCode = "620"
		case "Fredericksburg city":
			countyCode = "630"
		case "Galax city":
			countyCode = "640"
		case "Hampton city":
			countyCode = "650"
		case "Harrisonburg city":
			countyCode = "660"
		case "Hopewell city":
			countyCode = "670"
		case "Lexington city":
			countyCode = "678"
		case "Lynchburg city":
			countyCode = "680"
		case "Manassas city":
			countyCode = "683"
		case "Manassas Park city":
			countyCode = "685"
		case "Martinsville city":
			countyCode = "690"
		case "Newport News city":
			countyCode = "700"
		case "Norfolk city":
			countyCode = "710"
		case "Norton city":
			countyCode = "720"
		case "Petersburg city":
			countyCode = "730"
		case "Poquoson city":
			countyCode = "735"
		case "Portsmouth city":
			countyCode = "740"
		case "Radford city":
			countyCode = "750"
		case "Richmond city":
			countyCode = "760"
		case "Roanoke city":
			countyCode = "770"
		case "Salem city":
			countyCode = "775"
		case "Staunton city":
			countyCode = "790"
		case "Suffolk city":
			countyCode = "800"
		case "Virginia Beach city":
			countyCode = "810"
		case "Waynesboro city":
			countyCode = "820"
		case "Williamsburg city":
			countyCode = "830"
		case "Winchester city":
			countyCode = "840"
		}
	case "Vermont":
		stateCode = "50"
		switch county {
		case "Addison":
			countyCode = "001"
		case "Bennington":
			countyCode = "003"
		case "Caledonia":
			countyCode = "005"
		case "Chittenden":
			countyCode = "007"
		case "Essex":
			countyCode = "009"
		case "Franklin":
			countyCode = "011"
		case "Grand Isle":
			countyCode = "013"
		case "Lamoille":
			countyCode = "015"
		case "Orange":
			countyCode = "017"
		case "Orleans":
			countyCode = "019"
		case "Rutland":
			countyCode = "021"
		case "Washington":
			countyCode = "023"
		case "Windham":
			countyCode = "025"
		case "Windsor":
			countyCode = "027"
		}
	case "Washington":
		stateCode = "53"
		switch county {
		case "Adams":
			countyCode = "001"
		case "Asotin":
			countyCode = "003"
		case "Benton":
			countyCode = "005"
		case "Chelan":
			countyCode = "007"
		case "Clallam":
			countyCode = "009"
		case "Clark":
			countyCode = "011"
		case "Columbia":
			countyCode = "013"
		case "Cowlitz":
			countyCode = "015"
		case "Douglas":
			countyCode = "017"
		case "Ferry":
			countyCode = "019"
		case "Franklin":
			countyCode = "021"
		case "Garfield":
			countyCode = "023"
		case "Grant":
			countyCode = "025"
		case "Grays Harbor":
			countyCode = "027"
		case "Island":
			countyCode = "029"
		case "Jefferson":
			countyCode = "031"
		case "King":
			countyCode = "033"
		case "Kitsap":
			countyCode = "035"
		case "Kittitas":
			countyCode = "037"
		case "Klickitat":
			countyCode = "039"
		case "Lewis":
			countyCode = "041"
		case "Lincoln":
			countyCode = "043"
		case "Mason":
			countyCode = "045"
		case "Okanogan":
			countyCode = "047"
		case "Pacific":
			countyCode = "049"
		case "Pend Oreille":
			countyCode = "051"
		case "Pierce":
			countyCode = "053"
		case "San Juan":
			countyCode = "055"
		case "Skagit":
			countyCode = "057"
		case "Skamania":
			countyCode = "059"
		case "Snohomish":
			countyCode = "061"
		case "Spokane":
			countyCode = "063"
		case "Stevens":
			countyCode = "065"
		case "Thurston":
			countyCode = "067"
		case "Wahkiakum":
			countyCode = "069"
		case "Walla Walla":
			countyCode = "071"
		case "Whatcom":
			countyCode = "073"
		case "Whitman":
			countyCode = "075"
		case "Yakima":
			countyCode = "077"
		}
	case "Wisconsin":
		stateCode = "55"
		switch county {
		case "Adams":
			countyCode = "001"
		case "Ashland":
			countyCode = "003"
		case "Barron":
			countyCode = "005"
		case "Bayfield":
			countyCode = "007"
		case "Brown":
			countyCode = "009"
		case "Buffalo":
			countyCode = "011"
		case "Burnett":
			countyCode = "013"
		case "Calumet":
			countyCode = "015"
		case "Chippewa":
			countyCode = "017"
		case "Clark":
			countyCode = "019"
		case "Columbia":
			countyCode = "021"
		case "Crawford":
			countyCode = "023"
		case "Dane":
			countyCode = "025"
		case "Dodge":
			countyCode = "027"
		case "Door":
			countyCode = "029"
		case "Douglas":
			countyCode = "031"
		case "Dunn":
			countyCode = "033"
		case "Eau Claire":
			countyCode = "035"
		case "Florence":
			countyCode = "037"
		case "Fond du Lac":
			countyCode = "039"
		case "Forest":
			countyCode = "041"
		case "Grant":
			countyCode = "043"
		case "Green":
			countyCode = "045"
		case "Green Lake":
			countyCode = "047"
		case "Iowa":
			countyCode = "049"
		case "Iron":
			countyCode = "051"
		case "Jackson":
			countyCode = "053"
		case "Jefferson":
			countyCode = "055"
		case "Juneau":
			countyCode = "057"
		case "Kenosha":
			countyCode = "059"
		case "Kewaunee":
			countyCode = "061"
		case "La Crosse":
			countyCode = "063"
		case "Lafayette":
			countyCode = "065"
		case "Langlade":
			countyCode = "067"
		case "Lincoln":
			countyCode = "069"
		case "Manitowoc":
			countyCode = "071"
		case "Marathon":
			countyCode = "073"
		case "Marinette":
			countyCode = "075"
		case "Marquette":
			countyCode = "077"
		case "Menominee":
			countyCode = "078"
		case "Milwaukee":
			countyCode = "079"
		case "Monroe":
			countyCode = "081"
		case "Oconto":
			countyCode = "083"
		case "Oneida":
			countyCode = "085"
		case "Outagamie":
			countyCode = "087"
		case "Ozaukee":
			countyCode = "089"
		case "Pepin":
			countyCode = "091"
		case "Pierce":
			countyCode = "093"
		case "Polk":
			countyCode = "095"
		case "Portage":
			countyCode = "097"
		case "Price":
			countyCode = "099"
		case "Racine":
			countyCode = "101"
		case "Richland":
			countyCode = "103"
		case "Rock":
			countyCode = "105"
		case "Rusk":
			countyCode = "107"
		case "St. Croix":
			countyCode = "109"
		case "Sauk":
			countyCode = "111"
		case "Sawyer":
			countyCode = "113"
		case "Shawano":
			countyCode = "115"
		case "Sheboygan":
			countyCode = "117"
		case "Taylor":
			countyCode = "119"
		case "Trempealeau":
			countyCode = "121"
		case "Vernon":
			countyCode = "123"
		case "Vilas":
			countyCode = "125"
		case "Walworth":
			countyCode = "127"
		case "Washburn":
			countyCode = "129"
		case "Washington":
			countyCode = "131"
		case "Waukesha":
			countyCode = "133"
		case "Waupaca":
			countyCode = "135"
		case "Waushara":
			countyCode = "137"
		case "Winnebago":
			countyCode = "139"
		case "Wood":
			countyCode = "141"
		}
	case "West Virginia":
		stateCode = "54"
		switch county {
		case "Barbour":
			countyCode = "001"
		case "Berkeley":
			countyCode = "003"
		case "Boone":
			countyCode = "005"
		case "Braxton":
			countyCode = "007"
		case "Brooke":
			countyCode = "009"
		case "Cabell":
			countyCode = "011"
		case "Calhoun":
			countyCode = "013"
		case "Clay":
			countyCode = "015"
		case "Doddridge":
			countyCode = "017"
		case "Fayette":
			countyCode = "019"
		case "Gilmer":
			countyCode = "021"
		case "Grant":
			countyCode = "023"
		case "Greenbrier":
			countyCode = "025"
		case "Hampshire":
			countyCode = "027"
		case "Hancock":
			countyCode = "029"
		case "Hardy":
			countyCode = "031"
		case "Harrison":
			countyCode = "033"
		case "Jackson":
			countyCode = "035"
		case "Jefferson":
			countyCode = "037"
		case "Kanawha":
			countyCode = "039"
		case "Lewis":
			countyCode = "041"
		case "Lincoln":
			countyCode = "043"
		case "Logan":
			countyCode = "045"
		case "McDowell":
			countyCode = "047"
		case "Marion":
			countyCode = "049"
		case "Marshall":
			countyCode = "051"
		case "Mason":
			countyCode = "053"
		case "Mercer":
			countyCode = "055"
		case "Mineral":
			countyCode = "057"
		case "Mingo":
			countyCode = "059"
		case "Monongalia":
			countyCode = "061"
		case "Monroe":
			countyCode = "063"
		case "Morgan":
			countyCode = "065"
		case "Nicholas":
			countyCode = "067"
		case "Ohio":
			countyCode = "069"
		case "Pendleton":
			countyCode = "071"
		case "Pleasants":
			countyCode = "073"
		case "Pocahontas":
			countyCode = "075"
		case "Preston":
			countyCode = "077"
		case "Putnam":
			countyCode = "079"
		case "Raleigh":
			countyCode = "081"
		case "Randolph":
			countyCode = "083"
		case "Ritchie":
			countyCode = "085"
		case "Roane":
			countyCode = "087"
		case "Summers":
			countyCode = "089"
		case "Taylor":
			countyCode = "091"
		case "Tucker":
			countyCode = "093"
		case "Tyler":
			countyCode = "095"
		case "Upshur":
			countyCode = "097"
		case "Wayne":
			countyCode = "099"
		case "Webster":
			countyCode = "101"
		case "Wetzel":
			countyCode = "103"
		case "Wirt":
			countyCode = "105"
		case "Wood":
			countyCode = "107"
		case "Wyoming":
			countyCode = "109"
		}
	case "Wyoming":
		stateCode = "56"
		switch county {
		case "Albany":
			countyCode = "001"
		case "Big Horn":
			countyCode = "003"
		case "Campbell":
			countyCode = "005"
		case "Carbon":
			countyCode = "007"
		case "Converse":
			countyCode = "009"
		case "Crook":
			countyCode = "011"
		case "Fremont":
			countyCode = "013"
		case "Goshen":
			countyCode = "015"
		case "Hot Springs":
			countyCode = "017"
		case "Johnson":
			countyCode = "019"
		case "Laramie":
			countyCode = "021"
		case "Lincoln":
			countyCode = "023"
		case "Natrona":
			countyCode = "025"
		case "Niobrara":
			countyCode = "027"
		case "Park":
			countyCode = "029"
		case "Platte":
			countyCode = "031"
		case "Sheridan":
			countyCode = "033"
		case "Sublette":
			countyCode = "035"
		case "Sweetwater":
			countyCode = "037"
		case "Teton":
			countyCode = "039"
		case "Uinta":
			countyCode = "041"
		case "Washakie":
			countyCode = "043"
		case "Weston":
			countyCode = "045"
		}
	}
	return countyCode, stateCode
}
