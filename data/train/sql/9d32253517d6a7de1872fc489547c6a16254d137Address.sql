SET IDENTITY_INSERT dbo.[Address] ON;
GO

WITH cData(StreetNumber, AddressLine1, City, Region, PostCode, Country) AS (

	SELECT 65, '568-1433 Auctor St.', 'Chastre-Villeroux-Blanmont', 1, '931', 'New Zealand' UNION ALL
	SELECT 39, 'P.O. Box 463, 9290 Ipsum Road', 'Mansfield', 3, '7871', 'New Zealand' UNION ALL
	SELECT 115, '473-2540 Pede Av.', 'Belgaum', 4, '2427', 'New Zealand' UNION ALL
	SELECT 122, '3431 Magna. Av.', 'Raigarh', 3, '918', 'New Zealand' UNION ALL
	SELECT 12, 'Ap #628-1771 Neque Av.', 'College', 2, '9164', 'New Zealand' UNION ALL
	SELECT 139, 'P.O. Box 273, 4246 Nunc Road', 'Neuruppin', 4, '1056', 'New Zealand' UNION ALL
	SELECT 188, 'Ap #839-6396 Tellus, Ave', 'Woodstock', 3, '7771', 'New Zealand' UNION ALL
	SELECT 133, 'P.O. Box 735, 8633 Donec Street', 'Castiglione Messer Raimondo', 3, '8920', 'New Zealand' UNION ALL
	SELECT 160, 'Ap #986-1889 Enim. Avenue', 'San Maurizio Canavese', 1, '8370', 'New Zealand' UNION ALL
	SELECT 91, 'P.O. Box 632, 3268 Euismod Ave', 'Wilmington', 1, '3453', 'New Zealand' UNION ALL
	SELECT 113, '357 Quis Avenue', 'Mattersburg', 4, '4840', 'New Zealand' UNION ALL
	SELECT 200, 'P.O. Box 445, 3249 Egestas Ave', 'Biesme-sous-Thuin', 2, '1389', 'New Zealand' UNION ALL
	SELECT 51, 'Ap #261-1346 Cum Ave', 'Bhavnagar', 1, '2167', 'New Zealand' UNION ALL
	SELECT 96, '7421 Gravida. Rd.', 'Bear', 3, '1500', 'New Zealand' UNION ALL
	SELECT 94, '705-6861 Egestas Rd.', 'Anchorage', 3, '2082', 'New Zealand' UNION ALL
	SELECT 3, '336-6405 A, Rd.', 'Sint-Genesius-Rode', 3, '532', 'New Zealand' UNION ALL
	SELECT 197, 'P.O. Box 346, 177 Ligula. St.', 'Parramatta', 4, '1816', 'New Zealand' UNION ALL
	SELECT 30, '6994 Proin Avenue', 'Warrnambool', 3, '5677', 'New Zealand' UNION ALL
	SELECT 47, '662-8681 Pede Rd.', 'Coquitlam', 3, '3819', 'New Zealand' UNION ALL
	SELECT 85, 'P.O. Box 234, 6840 Nunc St.', 'Court-Saint-Etienne', 3, '8926', 'New Zealand' UNION ALL
	SELECT 153, 'P.O. Box 167, 9151 Nisl Av.', 'Nanton', 4, '5789', 'New Zealand' UNION ALL
	SELECT 42, 'P.O. Box 534, 3707 Eu, Ave', 'Mosciano Sant''Angelo', 1, '6284', 'New Zealand' UNION ALL
	SELECT 180, '1112 Amet Rd.', 'San Jose', 4, '5319', 'New Zealand' UNION ALL
	SELECT 76, '2789 Consequat Avenue', 'Sprimont', 4, '80', 'New Zealand' UNION ALL
	SELECT 165, '390-2518 Vitae Road', 'Wazirabad', 4, '2194', 'New Zealand' UNION ALL
	SELECT 105, 'Ap #244-3817 Libero. Ave', 'Longueville', 3, '9742', 'New Zealand' UNION ALL
	SELECT 115, '1211 Placerat St.', 'Indore', 4, '4795', 'New Zealand' UNION ALL
	SELECT 155, 'Ap #991-906 In Rd.', 'Carovilli', 1, '149', 'New Zealand' UNION ALL
	SELECT 131, '5307 Sagittis Road', 'Deschambault', 2, '7490', 'New Zealand' UNION ALL
	SELECT 36, '294-8515 Vitae, Rd.', 'Piagge', 2, '1406', 'New Zealand' UNION ALL
	SELECT 13, '6807 Cursus Ave', 'Stranraer', 1, '1961', 'New Zealand' UNION ALL
	SELECT 163, 'P.O. Box 682, 7852 Posuere Rd.', 'Elversele', 4, '3711', 'New Zealand' UNION ALL
	SELECT 198, 'P.O. Box 820, 8273 Vehicula Street', 'Burdinne', 1, '3304', 'New Zealand' UNION ALL
	SELECT 162, 'P.O. Box 137, 9280 Urna Rd.', 'Des Moines', 2, '4493', 'New Zealand' UNION ALL
	SELECT 178, 'P.O. Box 245, 8734 Lorem, Avenue', 'Hamme-Mille', 4, '9111', 'New Zealand' UNION ALL
	SELECT 97, 'P.O. Box 291, 540 Amet Av.', 'Konstanz', 4, '1021', 'New Zealand' UNION ALL
	SELECT 106, 'P.O. Box 700, 9049 Sem St.', 'Mignanego', 3, '2949', 'New Zealand' UNION ALL
	SELECT 175, '876 Duis Street', 'Sint-Niklaas', 3, '8952', 'New Zealand' UNION ALL
	SELECT 48, 'P.O. Box 448, 9974 Urna Avenue', 'Kearny', 4, '3694', 'New Zealand' UNION ALL
	SELECT 106, 'Ap #487-3225 Sed Avenue', 'Fort Simpson', 2, '9097', 'New Zealand' UNION ALL
	SELECT 18, 'P.O. Box 136, 9126 Duis Rd.', 'Nijmegen', 4, '5272', 'New Zealand' UNION ALL
	SELECT 24, 'Ap #728-9076 Non Rd.', 'Bothey', 3, '6933', 'New Zealand' UNION ALL
	SELECT 120, '5726 Mollis. Av.', 'Ways', 2, '6886', 'New Zealand' UNION ALL
	SELECT 91, '180-1190 Eu Avenue', 'College', 4, '7705', 'New Zealand' UNION ALL
	SELECT 141, '120-2592 Nunc St.', 'Essex', 4, '1026', 'New Zealand' UNION ALL
	SELECT 191, 'Ap #416-7688 Risus. Av.', 'Massa e Cozzile', 1, '4552', 'New Zealand' UNION ALL
	SELECT 18, '4520 Semper Av.', 'Presteigne', 2, '7223', 'New Zealand' UNION ALL
	SELECT 130, '7869 Ornare, Av.', 'Galbiate', 2, '8521', 'New Zealand' UNION ALL
	SELECT 11, '187-3581 Dui Street', 'Chelsea', 4, '6765', 'New Zealand' UNION ALL
	SELECT 190, '432-2233 Faucibus Street', 'Linz', 4, '8426', 'New Zealand' UNION ALL
	SELECT 130, '672-4030 Donec Road', 'Landeck', 2, '9108', 'New Zealand' UNION ALL
	SELECT 9, 'Ap #724-1728 Eu, Avenue', 'Bomal', 1, '2110', 'New Zealand' UNION ALL
	SELECT 29, '393-9059 Eleifend. St.', 'Lampertheim', 2, '7656', 'New Zealand' UNION ALL
	SELECT 137, 'P.O. Box 419, 408 Dolor, Avenue', 'Penrith', 2, '5180', 'New Zealand' UNION ALL
	SELECT 162, '9071 Dui, Rd.', 'Perth', 4, '7227', 'New Zealand' UNION ALL
	SELECT 131, 'Ap #172-2994 Elit. Rd.', 'Nobressart', 4, '4162', 'New Zealand' UNION ALL
	SELECT 46, 'Ap #217-2577 Erat St.', 'Anchorage', 1, '1659', 'New Zealand' UNION ALL
	SELECT 111, 'P.O. Box 303, 4007 Phasellus Road', 'Scunthorpe', 1, '3521', 'New Zealand' UNION ALL
	SELECT 46, 'P.O. Box 498, 1615 Odio Rd.', 'Pincher Creek', 3, '8072', 'New Zealand' UNION ALL
	SELECT 93, 'Ap #347-6006 A Street', 'Baltimore', 3, '9357', 'New Zealand' UNION ALL
	SELECT 149, 'P.O. Box 316, 9843 Consequat Avenue', 'Hugli-Chinsurah', 4, '20', 'New Zealand' UNION ALL
	SELECT 180, '937-1556 Nibh Rd.', 'Amersfoort', 3, '1384', 'New Zealand' UNION ALL
	SELECT 188, 'P.O. Box 729, 4560 Vestibulum St.', 'Comeglians', 1, '5864', 'New Zealand' UNION ALL
	SELECT 101, '739-4873 Sed, Av.', 'Liernu', 4, '3782', 'New Zealand' UNION ALL
	SELECT 147, 'P.O. Box 943, 3531 Sociis Rd.', 'l''Ecluse', 4, '2700', 'New Zealand' UNION ALL
	SELECT 67, 'P.O. Box 927, 2914 Cum Road', 'Bhavnagar', 3, '2276', 'New Zealand' UNION ALL
	SELECT 55, 'P.O. Box 877, 2344 Donec St.', 'Warspite', 1, '8188', 'New Zealand' UNION ALL
	SELECT 193, '971-546 Cras Street', 'Wimbledon', 1, '8010', 'New Zealand' UNION ALL
	SELECT 42, '7647 Velit. Avenue', 'Chiauci', 3, '5441', 'New Zealand' UNION ALL
	SELECT 103, 'P.O. Box 967, 7164 Consequat Rd.', 'Newbury', 3, '6966', 'New Zealand' UNION ALL
	SELECT 158, 'P.O. Box 867, 3378 Urna. Rd.', 'Fumal', 1, '4376', 'New Zealand' UNION ALL
	SELECT 106, '7790 Ipsum. Avenue', 'Chandannagar', 4, '9032', 'New Zealand' UNION ALL
	SELECT 50, 'P.O. Box 982, 7755 Eu Ave', 'Harlingen', 2, '5142', 'New Zealand' UNION ALL
	SELECT 64, '392-7573 Iaculis Rd.', 'Whitby', 2, '9360', 'New Zealand' UNION ALL
	SELECT 47, '4188 Justo Road', 'Eisenhï¿½ttenstadt', 1, '3483', 'New Zealand' UNION ALL
	SELECT 177, '6704 Enim. Ave', 'Loy', 3, '3788', 'New Zealand' UNION ALL
	SELECT 164, '3236 Dapibus Avenue', 'Guntur', 3, '4565', 'New Zealand' UNION ALL
	SELECT 1, '3475 Bibendum. Avenue', 'JaÃ©n', 4, '7795', 'New Zealand' UNION ALL
	SELECT 13, '3185 Erat Av.', 'La Rochelle', 3, '7444', 'New Zealand' UNION ALL
	SELECT 127, 'Ap #585-4895 Nisl. Rd.', 'Guelph', 1, '6096', 'New Zealand' UNION ALL
	SELECT 85, '161-3237 Malesuada Street', 'Badalona', 2, '6439', 'New Zealand' UNION ALL
	SELECT 47, '5923 Enim Street', 'Tuscaloosa', 3, '7204', 'New Zealand' UNION ALL
	SELECT 135, 'Ap #465-1493 Velit Av.', 'Guna', 2, '4777', 'New Zealand' UNION ALL
	SELECT 97, '450-4457 Semper St.', 'Ledbury', 4, '8942', 'New Zealand' UNION ALL
	SELECT 18, '5369 Lacus. Avenue', 'Tredegar', 2, '6541', 'New Zealand' UNION ALL
	SELECT 113, '323-8659 Tortor. St.', 'Salice Salentino', 3, '6204', 'New Zealand' UNION ALL
	SELECT 172, '7171 Imperdiet Rd.', 'Bruderheim', 2, '4802', 'New Zealand' UNION ALL
	SELECT 127, '5359 Dolor. Road', 'Pelago', 3, '5761', 'New Zealand' UNION ALL
	SELECT 66, 'P.O. Box 934, 3159 Sem. St.', 'Rexton', 1, '5460', 'New Zealand' UNION ALL
	SELECT 42, '909 Fringilla Rd.', 'Naperville', 4, '9963', 'New Zealand' UNION ALL
	SELECT 180, '5456 Vehicula. Rd.', 'Caprauna', 1, '3634', 'New Zealand' UNION ALL
	SELECT 140, 'Ap #676-5620 Est, Rd.', 'Bayreuth', 3, '5549', 'New Zealand' UNION ALL
	SELECT 117, 'P.O. Box 755, 1959 Sit Rd.', 'Holman', 4, '383', 'New Zealand' UNION ALL
	SELECT 51, '486-7316 Nec, St.', 'San Maurizio Canavese', 2, '5135', 'New Zealand' UNION ALL
	SELECT 91, 'Ap #186-5451 Eu, Av.', 'Broechem', 1, '3293', 'New Zealand' UNION ALL
	SELECT 120, 'Ap #535-6992 Tortor Ave', 'Campomorone', 1, '9972', 'New Zealand' UNION ALL
	SELECT 19, 'P.O. Box 426, 1558 Auctor Rd.', 'Pittsburgh', 3, '8217', 'New Zealand' UNION ALL
	SELECT 153, 'Ap #959-5983 In Ave', 'Omaha', 1, '414', 'New Zealand' UNION ALL
	SELECT 132, 'Ap #128-204 Morbi Avenue', 'Neustrelitz', 4, '719', 'New Zealand' UNION ALL
	SELECT 25, 'P.O. Box 175, 7798 Est, Avenue', 'Saint-Marc', 1, '2980', 'New Zealand' 

), cAddress AS(

	SELECT
		ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS AddressID
		,StreetNumber
		,CASE WHEN CHARINDEX(',', AddressLine1) > 0 THEN LEFT(AddressLine1, CHARINDEX(',', AddressLine1) - 1) ELSE AddressLine1 END AS AddressLine1
		,CASE WHEN CHARINDEX(',', AddressLine1) > 0 THEN RIGHT(AddressLine1, LEN(AddressLine1) - CHARINDEX(',', AddressLine1) - 1) ELSE NULL END AS AddressLine2
		,City
		,Region
		,RIGHT('0000' + PostCode, 4) AS PostCode
		,Country
	FROM
		cData

)
MERGE INTO dbo.[Address] AS tgt
USING cAddress AS src
ON tgt.AddressID = src.AddressID

WHEN MATCHED THEN UPDATE
SET StreetNumber = src.StreetNumber, AddressLine1 = src.AddressLine1, AddressLine2 = src.AddressLine2, City = src.City, Region = src.Region, PostCode = src.PostCode, Country = src.Country

WHEN NOT MATCHED THEN INSERT(AddressID, StreetNumber, AddressLine1, AddressLine2, City, Region, PostCode, Country)
VALUES(src.AddressID, src.StreetNumber, src.AddressLine1, src.AddressLine2, src.City, src.Region, src.PostCode, src.Country)
;
GO

SET IDENTITY_INSERT dbo.[Address] OFF;
GO