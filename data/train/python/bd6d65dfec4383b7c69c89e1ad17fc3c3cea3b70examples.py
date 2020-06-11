from noaa_radar import Radar

noaa = Radar()

image = noaa.get_composite_reflectivity('HTX')
image.save("composite_reflectivity.jpg")

image = noaa.get_base_reflectivity('HTX')
image.save("base_reflectivity.jpg")

image = noaa.get_storm_relative_motion('HTX')
image.save("storm_relative_motion.jpg")

image = noaa.get_base_velocity('HTX')
image.save("base_velocity.jpg")

image = noaa.get_one_hour_precipitation('HTX')
image.save("one_hour_precipitation.jpg")

image = noaa.get_storm_total_precipitation('HTX')
image.save("storm_total_precipitation.jpg")