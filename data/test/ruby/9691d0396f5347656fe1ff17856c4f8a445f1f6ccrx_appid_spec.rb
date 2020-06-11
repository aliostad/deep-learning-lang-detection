require 'crx_appid'

describe CrxAppid do
  let(:appid) do
    open(File.expand_path(File.join(File.dirname(__FILE__), "fixtures", "appid.txt"))).read.chomp
  end

  let(:pem_file) do
    File.expand_path(File.join(File.dirname(__FILE__), "fixtures", "extension.pem"))
  end

  let(:pem) do
    open(pem_file).read
  end

  describe '#calculate' do
    it "calculates appid from pem string" do
      expect(subject.calculate(pem)).to eq(appid)
    end
  end

  describe '#calculate_from_file' do
    it "calculates appid from pem file" do
      expect(subject.calculate_from_file(pem_file)).to eq(appid)
    end
  end

  describe '.calculate' do
    it "calculates appid from pem string" do
      expect(described_class.calculate(pem)).to eq(appid)
    end
  end

  describe '.calculate_from_file' do
    it "calculates appid from pem file" do
      expect(described_class.calculate_from_file(pem_file)).to eq(appid)
    end
  end
end
