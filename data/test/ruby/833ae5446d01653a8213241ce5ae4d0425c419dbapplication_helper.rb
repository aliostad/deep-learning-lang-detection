module ApplicationHelper
  def find_additional_weight_from_calories_mets_gender_height_weight_age_mets_time(calories, gender, height, weight, age, mets, time)
    weight_in_kg      = Calculate.lb_to_kg(weight)
    height_in_cm      = Calculate.in_to_cm(height)
    time_in_hours     = time / 60.0
    bmr               = Calculate.bmr_from_calories_mets_hours(calories, mets, time_in_hours)
    additional_weight = Calculate.additional_weight_from_bmr_gender_centimeters_and_age(
      bmr,
      gender,
      height_in_cm,
      age
    )

    Calculate.kg_to_lb(additional_weight)
  end

  def find_time_from_calories_mets_gender_height_weight_additional_weight_age(calories, mets, gender, height, weight, additional_weight, age)
    weight_in_kg            = Calculate.lb_to_kg(weight)
    additional_weight_in_kg = Calculate.lb_to_kg(additional_weight)
    height_in_cm            = Calculate.in_to_cm(height)
    bmr                     = Calculate.bmr_from_gender_height_weight_age(gender, height_in_cm, weight_in_kg + additional_weight_in_kg, age)

    Calculate.time_from_calories_mets_bmr(calories, mets, bmr) * 60.0
  end
end
