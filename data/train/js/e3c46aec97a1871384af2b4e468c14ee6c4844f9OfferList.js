angular.module('offerScope', [])
.controller('offerController', ['$scope', function ($scope) {


    $scope.getEmployeeList = function () {
        return $.ajax({
            type: "GET",
            url: "/api/api_Employee",
            dataType: 'json',
            contentType: 'application/json; charset=utf-8',
            async: false,
            success: function (html) {
                return html;
            }
        }).responseText;
    };
    $scope.employeeList = JSON.parse($scope.getEmployeeList());

	    $scope.Klikacz = function () {
console.log('Klikacz');

    };
	

    $scope.mock = [
            
  { serviceName: 'Wymiana oleju'
, serviceCost: 'od 35'
, },

  { serviceName: 'Wymiana oleju w skrzyni biegów'
, serviceCost: 'od 40'
, },

  { serviceName: 'Wymiana filtra paliwa'
, serviceCost: 'od 35'
, },

  { serviceName: 'Wymiana filtra powietrza'
, serviceCost: 'od 15'
, },

  { serviceName: 'Ustawienie zbieżności'
, serviceCost: 'od 80'
, },

  { serviceName: 'Wymiana klocków'
, serviceCost: 'od 65'
, },

  { serviceName: 'Wymiana tarcz i klocków'
, serviceCost: 'od 99'
, },

  { serviceName: 'Wymiana przewodu hamulcowego elastycznego'
, serviceCost: 'od 45'
, },

  { serviceName: 'Wymiana płynu hamulcowego'
, serviceCost: 'od 70'
, },

  { serviceName: 'Odpowietrzenie układu hamulcowego'
, serviceCost: 'od 50'
, },

  { serviceName: 'Czyszczenie zacisku hamulcowego'
, serviceCost: 'od 90'
, },

  { serviceName: 'Wymiana sworznia wahacza'
, serviceCost: 'od 55'
, },

  { serviceName: 'Wymiana wahacza'
, serviceCost: 'od 65'
, },

  { serviceName: 'Wymiana końcówki drążka kierowniczego'
, serviceCost: 'od 40'
, },

  { serviceName: 'Wymiana drążka kierowniczego'
, serviceCost: 'od 70'
, },

  { serviceName: 'Wymiana silentblocka wahacza'
, serviceCost: 'od 70'
, },

  { serviceName: 'Wymiana łącznika stabilizatora'
, serviceCost: 'od 35'
, },

  { serviceName: 'Wymiana poduszki stabilizatora'
, serviceCost: 'od 45'
, },

  { serviceName: 'Wymiana łożyska przedniego'
, serviceCost: 'od 95'
, },

  { serviceName: 'Wymiana amortyzatorów przednich'
, serviceCost: 'od 180'
, },

  { serviceName: 'Wymiana łożyska tylnego'
, serviceCost: 'od 65'
, },

  { serviceName: 'Wymiana szczęk'
, serviceCost: 'od 95'
, },

  { serviceName: 'Wymiana silentblocków belki tylnej'
, serviceCost: 'od 280'
, },

  { serviceName: 'Wymiana amortyzatorów tylnych'
, serviceCost: 'od 85'
, },

  { serviceName: 'Wymiana przegubu napędowego'
, serviceCost: 'od 95'
, },

  { serviceName: 'Wymiana osłony przegubu napędowego'
, serviceCost: 'od 90'
, },

  { serviceName: 'Wymiana paska klinowego'
, serviceCost: 'od 30'
, },

  { serviceName: 'Wymiana płynu w układzie chłodniczym'
, serviceCost: 'od 55'
, },

  { serviceName: 'Wymiana świecy zapłonowej'
, serviceCost: 'od 15'
, },

  { serviceName: 'Wymiana kabli zapłonowych'
, serviceCost: 'od 30'
, },

  { serviceName: 'Wymiana tłumika tylnego'
, serviceCost: 'od 60'
, },

  { serviceName: 'Wymiana tłumika przedniego'
, serviceCost: 'od 80'
, },

{ serviceName: 'Wymiana filtra kabiny (przeciwpyłkowego)',
 serviceCost: 'od 45',
 },

  { serviceName: 'Przegląd OT'
, serviceCost: 'od 200'
, },


  { serviceName: 'KOMPUTEROWA GEOMETRIA ZAWIESZENIA'
, serviceCost: 'od 199'
, },


{ serviceName: 'WYMIANA OPON'
, serviceCost: 'od 99zł', },



    ]

    $scope.checkQuery2 = function () {
        if ($scope.query2.length == 0) {
            $scope.query2 = undefined;
        }

    };


}]);

