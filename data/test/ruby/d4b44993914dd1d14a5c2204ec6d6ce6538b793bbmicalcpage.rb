require 'page-object'
class BmiCalcPage
	include PageObject
	
	text_field(:height, :id => 'heightCMS')
	text_field(:weight, :id => 'weightKg')
	button(:calculate, :value => 'Calculate')

	text_field(:bmi, :id => 'bmi')
	text_field(:bmi_category, :id => 'bmi_category')
	
	def calculate_bmi(height, weight)
		self.height = height
		self.weight = weight
		calculate
	end
	
	def open()
		@browser.get 'http://dl.dropbox.com/u/55228056/bmicalculator.html'
	end
	
	def close()
		@browser.close()
	end
end
