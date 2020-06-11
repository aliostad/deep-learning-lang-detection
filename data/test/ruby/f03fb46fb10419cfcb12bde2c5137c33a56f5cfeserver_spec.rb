require 'securerandom'
require 'spec_helper'

module CMIS
  describe Server do
    describe '#repositories' do
      it 'are all Repositories' do
        server.repositories.each do |r|
          expect(r).to be_a Repository
        end
      end

      it 'contains the test repository' do
        repo_array = server.repositories.map(&:id)
        expect(repo_array).to include(repository_id)
      end
    end

    describe '#repository' do
      it 'is a Repository' do
        expect(repository).to be_a Repository
      end

      it 'has the correct id' do
        expect(repository.id).to eq(repository_id)
      end
    end

    describe '#repository?' do
      it 'returns true for a present repository' do
        expect(server.repository?(repository_id)).to be true
      end

      it 'returns false for an absent repository' do
        absent_repository_id = SecureRandom.uuid
        expect(server.repository?(absent_repository_id)).to be false
      end
    end
  end
end
