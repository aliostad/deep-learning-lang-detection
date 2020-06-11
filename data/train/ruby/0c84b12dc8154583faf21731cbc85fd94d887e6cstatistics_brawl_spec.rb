# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Statistics do
  describe '#calculate_brawl_bonus_from_special_rules' do
    let(:statistics) { Statistics.new }

    it { expect(statistics.calculate_brawl_bonus_from_special_rules).to eq 0 }
  end

  describe '#calculate_brawl_bonus_from_skills' do
    let(:statistics) { Statistics.new }
    let!(:stats_modifiers) { [create(:stats_modifier, modifies: 'fighting', group_name: 'Bijatyka', value: 2)] }

    before do
      statistics.stats_modifiers << stats_modifiers
    end

    it { expect(statistics.calculate_brawl_bonus_from_skills).to eq 2 }
  end

  describe '#calculate_total_brawling' do
    let(:statistics) { Statistics.new }

    context 'attack' do
      let(:context) { 'attack' }

      before do
        statistics.stub(:raw_fencing_when_attacking) { 1 }
        statistics.stub(:calculate_dexterity_and_strength_bonus) { 1 }
      end

      it { expect(statistics.calculate_total_brawling(context)).to eq 2 }
    end

    context 'defense' do
      let(:context) { 'defense' }

      before do
        statistics.stub(:raw_fencing_when_defending) { 1 }
        statistics.stub(:calculate_current_zr) { 10 }
        statistics.stub(:calculate_wi) { 10 }
        statistics.stub(:calculate_brawl_bonus_from_skills) { 1 }
      end

      it { expect(statistics.calculate_total_brawling(context)).to eq 2 }
    end
  end
end
