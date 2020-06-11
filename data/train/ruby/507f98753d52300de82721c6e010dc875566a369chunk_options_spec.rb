require 'spec_helper'

describe "chunk options" do

  subject { KnitrRuby::Knitr.new(chunk_options: chunk_options) }
  let(:input) { "```{r}\n3*3\n```" }

  describe "knit echo=FALSE" do
    let(:chunk_options) {{ 'echo' => false }}
    let(:output) { "\n```r\n3 * 3\n```\n\n```\n## [1] 9\n```\n\n" }

    it "should knit" do
      subject.chunk_options.should eq(chunk_options)
      subject.knit(input).should eq(output)
    end
  end

  describe "knit include=FALSE" do
    let(:chunk_options) {{ 'include' => false }}
    let(:output) { "\n```r\n3 * 3\n```\n\n```\n## [1] 9\n```\n\n" }

    it "should knit" do
      subject.chunk_options.should eq(chunk_options)
      subject.knit(input).should eq(output)
    end
  end

  describe "knit error=FALSE" do
    let(:chunk_options) {{ 'error' => false }}
    let(:output) { "\n```r\n3 * 3\n```\n\n```\n## [1] 9\n```\n\n" }

    it "should knit" do
      subject.chunk_options.should eq(chunk_options)
      subject.knit(input).should eq(output)
    end
  end

  describe "knit error=FALSE" do
    let(:chunk_options) {{ 'fig.show' => 'hold', 'fig.width' => 10, 'fig.height' => 7, 'dev' => 'svg' }}
    let(:output) { "\n```r\n3 * 3\n```\n\n```\n## [1] 9\n```\n\n" }

    it "should knit" do
      subject.chunk_options.should eq(chunk_options)
      subject.knit(input).should eq(output)
    end
  end

end