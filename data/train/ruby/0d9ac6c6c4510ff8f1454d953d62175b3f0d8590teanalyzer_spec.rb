require File.expand_path('./../../lib/teanalyzer', __FILE__)

describe 'Teanalyzer' do
  before(:each) do
    Parameters.reset
  end
  subject { Teanalyzer }
  describe 'calculate' do
    describe 'compare efforts of texts' do
      # some subjective examples using the standard parameter settings
      specify { subject.calculate('1z0').should > subject.calculate('typingeffort') }
      specify { subject.calculate('payquarterly').should > subject.calculate('gakkklskjdjfklaksdfjkas') }
      specify { subject.calculate('zumba').should > subject.calculate('fastandfurious') }
    end
    describe 'edge cases' do
      it 'should not crash with unknown characters' do
        subject.calculate('Jörg')
      end
      it 'should not yield result for short texts' do
        subject.calculate('Ah').should be_nil
      end
      it 'should remove space from input' do
        subject.calculate('Hello World').should be==(subject.calculate('HelloWorld'))
      end
    end
  end

  describe 'calculate_total' do
    describe 'compare total effort of words' do
      # some subjective examples using the standard parameter settings
      specify { subject.calculate_total('glow').should < subject.calculate_total('glowing') }
      specify { subject.calculate_total('glove').should < subject.calculate_total('glucose') }
      specify { subject.calculate_total('kitsch').should < subject.calculate_total('knee-high') }
      specify { subject.calculate_total('oasis').should < subject.calculate_total('oblige') }
      specify { subject.calculate_total('haulier').should < subject.calculate_total('haunch') }
      specify { subject.calculate_total('"wastelands"').should < subject.calculate_total('nitrogen') }
      specify { subject.calculate_total('Yes').should < subject.calculate_total('YesY') }
      specify { subject.calculate_total('YesY').should < subject.calculate_total('YesYe') }
      specify { subject.calculate_total('YesYe').should < subject.calculate_total('YesYes') }
      specify { subject.calculate_total('YesYes').should < subject.calculate_total('YesYesY') }
    end

    describe 'edge cases' do
      it 'should not crash with unknown characters' do
        subject.calculate_total('Jörg')
      end
      it 'should not yield result for short texts' do
        subject.calculate_total('Ah').should be_nil
      end
    end
  end
end