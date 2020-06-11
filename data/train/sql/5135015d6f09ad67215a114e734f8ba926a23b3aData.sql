delimiter $$

INSERT INTO `role`
(`Name`)
VALUES
('Pending');$$



INSERT INTO `role`
(`Name`)
VALUES
('Active');$$



INSERT INTO `role`
(`Name`)
VALUES
('Administrator');$$



INSERT INTO `role`
(`Name`)
VALUES
('KioskAdministrator');$$



INSERT INTO `role`
(`Name`)
VALUES
('Inactive');$$



INSERT INTO `right`
(`Code`)
VALUES
('ReadMyVolunteerInfo');$$



INSERT INTO `right`
(`Code`)
VALUES
('ReadOthersVolunteerInfo');$$



INSERT INTO `right`
(`Code`)
VALUES
('UpdateMyVolunteerInfo');$$



INSERT INTO `right`
(`Code`)
VALUES
('UpdateOthersVolunteerInfo');$$


INSERT INTO `right`
(`Code`)
VALUES
('ReadInterestAreas');$$



INSERT INTO `right`
(`Code`)
VALUES
('UpdateInterestAreas');$$



INSERT INTO `right`
(`Code`)
VALUES
('CreateInterestAreas');$$



INSERT INTO `right`
(`Code`)
VALUES
('DeleteInterestAreas');$$



INSERT INTO `right`
(`Code`)
VALUES
('ReadMyInterests');$$



INSERT INTO `right`
(`Code`)
VALUES
('CreateMyInterests');$$



INSERT INTO `right`
(`Code`)
VALUES
('UpdateMyInterests');$$



INSERT INTO `right`
(`Code`)
VALUES
('DeleteMyInterests');$$



INSERT INTO `right`
(`Code`)
VALUES
('ReadOtherInterests');$$



INSERT INTO `right`
(`Code`)
VALUES
('CreateOthersInterests');$$



INSERT INTO `right`
(`Code`)
VALUES
('UpdateOthersInterests');$$



INSERT INTO `right`
(`Code`)
VALUES
('DeleteOthersInterests');$$



INSERT INTO `right`
(`Code`)
VALUES
('ReadMyHours');$$



INSERT INTO `right`
(`Code`)
VALUES
('CreateMyHours');$$



INSERT INTO `right`
(`Code`)
VALUES
('UpdateMyHours');$$



INSERT INTO `right`
(`Code`)
VALUES
('DeleteMyHours');$$



INSERT INTO `right`
(`Code`)
VALUES
('ReadOthersHours');$$



INSERT INTO `right`
(`Code`)
VALUES
('CreateOthersHours');$$



INSERT INTO `right`
(`Code`)
VALUES
('UpdateOthersHours');$$



INSERT INTO `right`
(`Code`)
VALUES
('DeleteOthersHours');$$



INSERT INTO `right`
(`Code`)
VALUES
('ReadMyFamilyHours');$$



INSERT INTO `right`
(`Code`)
VALUES
('ReadOthersFamilyHours');$$



INSERT INTO `right`
(`Code`)
VALUES
('ViewAdminTab');$$



INSERT INTO `right`
(`Code`)
VALUES
('CreateAccessToken');$$



INSERT INTO `right`
(`Code`)
VALUES
('ReadAllHours');$$



INSERT INTO `right`
(`Code`)
VALUES
('ViewHoursTab');$$



INSERT INTO `right`
(`Code`)
VALUES
('UpdateOthersVolunteerRole');$$



INSERT INTO `right`
(`Code`)
VALUES
('ReadAllVolunteerInfo');$$



INSERT INTO `right`
(`Code`)
VALUES
('CreateMyProfile');$$



INSERT INTO `right`
(`Code`)
VALUES
('ReadKioskCheckIn');$$



INSERT INTO `right`
(`Code`)
VALUES
('CreateKioskCheckIn');$$



INSERT INTO `right`
(`Code`)
VALUES
('UpdateKioskCheckIn');$$



INSERT INTO `roletoright`
(`Role_PK`, `Right_PK`)
SELECT ro.Role_PK, ri.Right_PK
FROM `role` ro
CROSS JOIN `right` ri
WHERE ro.Name = 'Pending'
AND ri.Code IN
('ReadMyVolunteerInfo',
'UpdateMyVolunteerInfo',
'ReadInterestAreas',
'ReadMyInterests',
'CreateMyInterests',
'UpdateMyInterests',
'DeleteMyInterests',
'CreateAccessToken',
'ReadRights',
'ViewHoursTab',
'CreateMyProfile');$$



INSERT INTO `roletoright`
(`Role_PK`, `Right_PK`)
SELECT ro.Role_PK, ri.Right_PK
FROM `role` ro
CROSS JOIN `right` ri
WHERE ro.Name = 'Active'
AND ri.Code IN
('ReadMyVolunteerInfo',
'UpdateMyVolunteerInfo',
'ReadInterestAreas',
'ReadMyInterests',
'CreateMyInterests',
'UpdateMyInterests',
'DeleteMyInterests',
'ReadMyHours',
'CreateMyHours',
'DeleteMyHours',
'ReadMyFamilyHours',
'CreateAccessToken',
'ReadRights',
'ViewHoursTab',
'CreateMyProfile');$$



INSERT INTO `roletoright`
(`Role_PK`, `Right_PK`)
SELECT ro.Role_PK, ri.Right_PK
FROM `role` ro
CROSS JOIN `right` ri
WHERE ro.Name = 'KioskAdministrator'
AND ri.Code IN
('ReadKioskCheckIn',
'CreateKioskCheckIn',
'CreateAccessToken',
'UpdateKioskCheckIn',
'ReadAllVolunteerInfo',
'ReadInterestAreas');$$



INSERT INTO `roletoright`
(`Role_PK`, `Right_PK`)
SELECT ro.Role_PK, ri.Right_PK
FROM `role` ro
CROSS JOIN `right` ri
WHERE ro.Name = 'Administrator';$$

INSERT INTO `interestarea`(`SortOrder`, `Name`) VALUES (1, 'Art Room Assistance');$$
INSERT INTO `interestarea`(`SortOrder`, `Name`) VALUES (1, 'Athletics');$$
INSERT INTO `interestarea`(`SortOrder`, `Name`) VALUES (1, 'AVA Gala');$$
INSERT INTO `interestarea`(`SortOrder`, `Name`) VALUES (1, 'BASE Volunteers');$$
INSERT INTO `interestarea`(`SortOrder`, `Name`) VALUES (1, 'Book Fair');$$
INSERT INTO `interestarea`(`SortOrder`, `Name`) VALUES (1, 'Box Tops');$$
INSERT INTO `interestarea`(`SortOrder`, `Name`) VALUES (1, 'Carpool A.M.');$$
INSERT INTO `interestarea`(`SortOrder`, `Name`) VALUES (1, 'Carpool P.M.');$$
INSERT INTO `interestarea`(`SortOrder`, `Name`) VALUES (1, 'Choir');$$
INSERT INTO `interestarea`(`SortOrder`, `Name`) VALUES (1, 'Classroom');$$
INSERT INTO `interestarea`(`SortOrder`, `Name`) VALUES (1, 'Community Service');$$
INSERT INTO `interestarea`(`SortOrder`, `Name`) VALUES (1, 'Computer Lab');$$
INSERT INTO `interestarea`(`SortOrder`, `Name`) VALUES (1, 'Field Day');$$
INSERT INTO `interestarea`(`SortOrder`, `Name`) VALUES (1, 'Field Trips');$$
INSERT INTO `interestarea`(`SortOrder`, `Name`) VALUES (1, 'Fundraising');$$
INSERT INTO `interestarea`(`SortOrder`, `Name`) VALUES (1, 'Grant Committee');$$
INSERT INTO `interestarea`(`SortOrder`, `Name`) VALUES (1, 'Library');$$
INSERT INTO `interestarea`(`SortOrder`, `Name`) VALUES (1, 'Lunch Duty');$$
INSERT INTO `interestarea`(`SortOrder`, `Name`) VALUES (1, 'Office Help');$$
INSERT INTO `interestarea`(`SortOrder`, `Name`) VALUES (1, 'Other');$$
INSERT INTO `interestarea`(`SortOrder`, `Name`) VALUES (1, 'PE');$$
INSERT INTO `interestarea`(`SortOrder`, `Name`) VALUES (1, 'Preschool');$$
INSERT INTO `interestarea`(`SortOrder`, `Name`) VALUES (1, 'Room Parent');$$
INSERT INTO `interestarea`(`SortOrder`, `Name`) VALUES (1, 'SAC');$$
INSERT INTO `interestarea`(`SortOrder`, `Name`) VALUES (1, 'Science');$$
INSERT INTO `interestarea`(`SortOrder`, `Name`) VALUES (1, 'Staff Appreciation');$$
INSERT INTO `interestarea`(`SortOrder`, `Name`) VALUES (1, 'Social Events/Spirit Days');$$
INSERT INTO `interestarea`(`SortOrder`, `Name`) VALUES (1, 'Teacher Appreciation');$$
INSERT INTO `interestarea`(`SortOrder`, `Name`) VALUES (1, 'Thursday Folders');$$
INSERT INTO `interestarea`(`SortOrder`, `Name`) VALUES (1, 'Volunteer from Home');$$
INSERT INTO `interestarea`(`SortOrder`, `Name`) VALUES (1, 'Watch D.O.G.S.');$$
INSERT INTO `interestarea`(`SortOrder`, `Name`) VALUES (1, 'Yearbook');$$
INSERT INTO `interestarea`(`SortOrder`, `Name`) VALUES (1, 'Finance Committee');$$
INSERT INTO `interestarea`(`SortOrder`, `Name`) VALUES (1, 'Foundation Council');$$
INSERT INTO `interestarea`(`SortOrder`, `Name`) VALUES (1, 'Literacy');$$
INSERT INTO `interestarea`(`SortOrder`, `Name`) VALUES (1, 'Family Resource Workshop');$$
INSERT INTO `interestarea`(`SortOrder`, `Name`) VALUES (1, 'Used Uniform Sale');$$


INSERT INTO `volunteer`
(`FirstName`,
`LastName`,
`EmailAddress`,
`PasswordHash`,
`Salt`,
`FamilyID`,
`Role_PK`)
VALUES
('Admin',
'Admin',
'admin@admin.com',
'1274b2dbaabbabba975f0a1ec70f7ef4e909b03bfae106d925568414dc23a740',
'51bfd0336e086',
1,
3);$$
