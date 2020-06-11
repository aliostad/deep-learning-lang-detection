require 'spec_helper'

describe IngredientFetch do
  let(:meal) { ["a"] } # array of meals ids
  let(:servings_needed) { 4 }
  let(:servings) { {"a" => 4 } } # hash with keys: meals_id and value: numberOfServings
  let(:ingredients) { { "a" => ["unit" => "unit","qta" => 2] } } # hash with keys meals_id and value:[hash of ingredients]

  context "#calculate_ingredients_needed" do
    #self.calculate_ingredients_needed(meal,servings_needed,servings,ingredients)

    it "should call calculate_ingredient_qta with ingredient quantity,servings_needed,meal and servings " do
      # testing if calculate_ingredient_qta calls servings_selected

      #self.calculate_ingredient_qta(original_qty,servings_needed,meal,servings)
      expect(IngredientFetch).to receive(:calculate_ingredient_qta).with(2,servings_needed,meal,servings).and_return(1)  
      IngredientFetch.calculate_ingredients_needed(meal,servings_needed,servings,ingredients)
    end 


    it "should return ingredients if servings selected qty is equal to needed quantity " do
      allow(IngredientFetch).to receive(:calculate_ingredient_qta).with(2,servings_needed,meal,servings).and_return(2)
      expect(IngredientFetch.calculate_ingredients_needed(meal,servings_needed,servings,ingredients)).to eq(ingredients)
    end

    it "should return ingredients with double qtt if servings selected qty is half of needed quantity " do
      allow(IngredientFetch).to receive(:calculate_ingredient_qta).with(2,8,meal,servings).and_return(4)
      expect(IngredientFetch.calculate_ingredients_needed(meal,8,servings,ingredients)).to eq({ "a" => ["unit" => "unit","qta" => 4] })
    end

    it "should return ingredients with qty = 0 if servings selected is eql 0 " do
      allow(IngredientFetch).to receive(:calculate_ingredient_qta).with(2,0,meal,servings).and_return(0)
      expect(IngredientFetch.calculate_ingredients_needed(meal,0,servings,ingredients)).to eq({ "a" => ["unit" => "unit","qta" => 0] })
    end

  end

  context "#calculate_ingredient_qta" do
    #self.calculate_ingredient_qta(original_qty,servings_needed,meal,servings)

    it "should call servings_selected with meal and servings " do
      # testing if calculate_ingredient_qta calls servings_selected
      expect(IngredientFetch).to receive(:servings_selected).with("a","b").and_return(1)
      IngredientFetch.calculate_ingredient_qta(1,1,"a","b")
    end

    it "should return return 1 if everything is 1 " do
      # pretending that servings_selected result is equal 1 (not calling it really!)
      allow(IngredientFetch).to receive(:servings_selected).with("a","b").and_return(1)
      expect(IngredientFetch.calculate_ingredient_qta(1,1,"a","b")).to eq(1)
    end

    it "should return return 8 if original 2 and needed 4" do
      # pretending that servings_selected result is equal 1 (not calling it really!)
      allow(IngredientFetch).to receive(:servings_selected).with("a","b").and_return(1)
      expect(IngredientFetch.calculate_ingredient_qta(2,4,"a","b")).to eq(8)
    end

    it "should return return 0 if servings_selected is 0" do
      # pretending that servings_selected result is equal 1 (not calling it really!)
      allow(IngredientFetch).to receive(:servings_selected).with("a","b").and_return(0)
      expect(IngredientFetch.calculate_ingredient_qta(2,4,"a","b")).to eq(0)
    end

  end

  context "#servings_selected" do

    it ("should return 4 if I select 4 servings") do
      expect(IngredientFetch.servings_selected(["1","2"],{"1" => 1,"2" => 3})).to eq(4)
    end

    it ("should return 0 if I select 0 servings") do
      expect(IngredientFetch.servings_selected([],{})).to eq(0)
    end
  end

end
