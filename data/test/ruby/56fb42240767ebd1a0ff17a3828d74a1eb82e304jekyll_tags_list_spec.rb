require 'spec_helper'

RSpec.describe Jekyll::Prism do
	
	before(:each) do
		@site = double("tags" => {
			'a' => [1,2,3,4,5],
			'b' => [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15],
			'c' => [1,2,3],
			'd' => [1,2],
			'e' => [1,2,3,4],
			'f' => [1,2,3,4,5,6,7],
			'g' => [1,2,3,4,5,6,7,8],
			'g' => [1,2,3,4,5,6,7,8,9,10,11],
			'h' => [1,2,3],
			'i' => [1,2,3,4,5],
		},
		"config" => {
			"number_popularity_classes" => 5
		})
	end

	it "calculates the number of posts for tag" do
		expect(described_class.number_of_posts_for_tag(@site, 'a')).to eql(5)
		expect(described_class.number_of_posts_for_tag(@site, 'b')).to eql(15)
		expect(described_class.number_of_posts_for_tag(@site, 'c')).to eql(3)
	end
	
	it "calculates the maximum post count for a tag" do
		expect(described_class.calculate_maximum_post_count(@site)).to eql(15)
	end

	it "calculates the popularity of a post for a tag" do
		expect(described_class.calculate_popularity(15, 12)).to eql(80)
		expect(described_class.calculate_popularity(15, 2)).to eql(13)
		expect(described_class.calculate_popularity(15, 3)).to eql(20)
		expect(described_class.calculate_popularity(15, 4)).to eql(26)
		expect(described_class.calculate_popularity(15, 5)).to eql(33)
		expect(described_class.calculate_popularity(15, 8)).to eql(53)
	end
	
	it "calculates the popularity class of a post for a tag" do
		expect(described_class.calculate_popularity_class(@site, 100, 0)).to eql(0)
		expect(described_class.calculate_popularity_class(@site, 100, 9)).to eql(0)
		expect(described_class.calculate_popularity_class(@site, 100, 10)).to eql(1)
		expect(described_class.calculate_popularity_class(@site, 100, 20)).to eql(1)
		expect(described_class.calculate_popularity_class(@site, 100, 21)).to eql(1)
		expect(described_class.calculate_popularity_class(@site, 100, 29)).to eql(1)
		expect(described_class.calculate_popularity_class(@site, 100, 30)).to eql(2)
		expect(described_class.calculate_popularity_class(@site, 100, 39)).to eql(2)
		expect(described_class.calculate_popularity_class(@site, 100, 40)).to eql(2)
		expect(described_class.calculate_popularity_class(@site, 100, 49)).to eql(2)
		expect(described_class.calculate_popularity_class(@site, 100, 50)).to eql(3)
		expect(described_class.calculate_popularity_class(@site, 100, 59)).to eql(3)
		expect(described_class.calculate_popularity_class(@site, 100, 60)).to eql(3)
		expect(described_class.calculate_popularity_class(@site, 100, 69)).to eql(3)
		expect(described_class.calculate_popularity_class(@site, 100, 70)).to eql(4)
		expect(described_class.calculate_popularity_class(@site, 100, 79)).to eql(4)
		expect(described_class.calculate_popularity_class(@site, 100, 80)).to eql(4)
		expect(described_class.calculate_popularity_class(@site, 100, 89)).to eql(4)
		expect(described_class.calculate_popularity_class(@site, 100, 90)).to eql(5)
		expect(described_class.calculate_popularity_class(@site, 100, 99)).to eql(5)
		expect(described_class.calculate_popularity_class(@site, 100, 100)).to eql(5)
	end

	it "generates a tags structure for site" do
		result = described_class.generate_tags_structure(@site)
		expect(result["a"]["post_count"]).to eql("5")
		expect(result["a"]["popularity"]).to eql("33")
		expect(result["a"]["popularity_class"]).to eql("2")
	end	
	
end
