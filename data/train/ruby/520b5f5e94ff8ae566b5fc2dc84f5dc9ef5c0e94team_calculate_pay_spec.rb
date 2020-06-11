require_relative "../../helpers/company_creator"

describe "Calculating pay for team members" do
	
	before :all do
		@company=CompanyCreator.create_company
		@team=@company.teams[0]
		@team.do_sprint(5)
	end

	context "Calculate pay for team developer" do
		let(:dev) { @team.developers[0] }
		it "developer salary calculated" do
			output=dev.calculate_pay(@company)
			expect(output).to eql(392.4)
		end
	end

	context "Calculate pay for team manager" do
		let(:man) { @team.manager }
		it "manager salary calculated" do
			output=man.calculate_pay(@company)
			expect(output).to eql(570.0)
		end
	end

	context "Calculate pay for team tester" do
		let(:tester) { @team.testers[0] }
		it "tester salary calculated" do
			output=tester.calculate_pay(@company)
			expect(output).to eql(333.2)
		end
	end
end