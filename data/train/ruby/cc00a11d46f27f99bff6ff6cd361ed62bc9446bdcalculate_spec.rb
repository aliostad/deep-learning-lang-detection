require File.expand_path('../../spec_helper', __FILE__)

describe Genability::Client do

  Genability::Configuration::VALID_FORMATS.each do |format|

    context ".new(:format => '#{format}')" do

      before(:all) do
        @options = {:format => format}.merge(configuration_defaults)
        @client = Genability::Client.new(@options)
        @master_tariff_id = 512
        @from = "Monday, September 1st, 2011"
        @to = "Monday, September 10th, 2011"
        @metadata_options = {
                              "connectionType" => "Primary Connection",
                              "cityLimits" => "Inside"
                            }
      end

      context ".calculate_metadata" do

        use_vcr_cassette "calculate"

        it "should return the inputs required to use the calculate method" do
          metadata = @client.calculate_metadata(
                       @master_tariff_id, @from, @to, { :additional_values => @metadata_options }
                     ).first
          metadata.unit.should == "kwh"
        end

      end

      context ".calculate" do

        use_vcr_cassette "calculate"

        it "should calculate the total cost" do
          # First, get the Calculate Input metadata
          metadata = @client.calculate_metadata(
                       @master_tariff_id, @from, @to, { :additional_values => @metadata_options }
                     )
          # Then run the calculation with the input metadata
          calc = @client.calculate(
                   @master_tariff_id, @from, @to, metadata, {}
                 )
          calc.tariff_name.should == "Residential Service"
          calc.items.first.rate_name.should == "Basic Service Charge"
        end

        it "should not allow invalid tariff inputs" do
          lambda do
            @client.calculate(
              512,
              "Monday, September 1st, 2011",
              "Monday, September 10th, 2011",
              "InvalidTariffInput"
              )
          end.should raise_error(Genability::InvalidInput)
        end

      end

    end

  end
end

