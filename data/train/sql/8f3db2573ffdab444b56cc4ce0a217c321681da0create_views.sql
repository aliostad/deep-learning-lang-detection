SELECT * INTO ffsbc.view_1_Lakes
FROM db_datawriter.Create_Waterbody_View()

SELECT * INTO  ffsbc.view_1a_Lake_Profiles
FROM db_datawriter.Create_Waterbody_Profile_View()

SELECT * INTO  ffsbc.view_1b_Lake_Access
FROM db_datawriter.Create_Waterbody_Access_View()

SELECT * INTO  ffsbc.view_1c_Lake_Dimensions
FROM db_datawriter.Create_Waterbody_Dimensions_View()

SELECT * INTO  ffsbc.view_2_Assessment_Summary
FROM db_datawriter.Create_Assessment_View()

SELECT * INTO  ffsbc.view_2a_Net_Summary
FROM db_datawriter.Create_Net_Summary_View()

SELECT * INTO  ffsbc.view_2b_Biological_Data
FROM db_datawriter.Create_Biological_View()

SELECT * INTO  ffsbc.view_2c_Net_Summary_Counts
FROM db_datawriter.Create_Net_Summary_Counts_View()

SELECT * INTO  ffsbc.view_4_Creel
FROM db_datawriter.Create_Creel_View()

SELECT * INTO  ffsbc.view_4a_Creel_Counts
FROM db_datawriter.Create_Creel_Count_View()

SELECT * INTO  ffsbc.view_5_Effort
FROM db_datawriter.Create_Effort_View()

SELECT * INTO  ffsbc.view_7_Project
FROM db_datawriter.Create_Project_View()
