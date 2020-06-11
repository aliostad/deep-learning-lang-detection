module Torutsume
  module Git
    describe RepositoryWriter do
      let(:creator) do
        RepositoryWriter.new(
          repository_creator: repository_creator,
          repository_loader: repository_loader,
          commit_writer: commit_writer,
        )
      end

      let(:repository_loader) do
        double('repository_loader')
      end

      let(:commit_writer) do
        commit_writer = double('commit_writer')
        allow(commit_writer).to receive(:write)
        commit_writer
      end

      let(:repository_path) { '/path/repo/1' }

      let(:text) { ::Text.new(id: 1) }
      let(:user) { build :user }

      describe '#create' do
        subject { creator.create(user: user, text: text) }

        context 'when succeeded' do
          let(:repository_creator) do
            repository_creator = double('repository_creator')
            allow(repository_creator).to receive(:create).and_return(repository)
            repository_creator
          end

          let(:repository) { double(Rugged::Repository) }

          it 'should create repository at expected place' do
            expect(subject).to be_equal(repository)
            expect(repository_creator).to have_received(:create).with(text)
          end
        end

        context 'when failed' do
          let(:repository_creator) do
            repository_creator = double('repository_creator')
            allow(repository_creator).to receive(:create).and_raise(error)
            repository_creator
          end

          let(:error) { StandardError.new 'Some error occured' }

          it 'should create repository at expected place' do
            expect(subject).to be_nil
            expect(repository_creator).to have_received(:create).with(text)
            expect(creator.error).to be_equal(error)
          end
        end
      end
    end
  end
end
