require 'spec_helper'

describe ProjectSourceCode do
  describe '.start_repository' do
    let(:project) { create :project }

    it 'set the repository url to the project' do
      repository_url = 'example.com/github/repository_name'
      Github::Repos.stub_chain(:new, :create).and_return({ :html_url => repository_url })

      ProjectSourceCode.start_repository project, project.team_leader, 'repository_name'

      project.repository_url.should == repository_url
    end

    it 'returns the created repository url' do
      expected_url = 'example.com/github/repository_name'
      Github::Repos.stub_chain(:new, :create).and_return({ :html_url => expected_url})

      repository_url = ProjectSourceCode.start_repository project, project.team_leader, 'repository_name'

      repository_url.should == expected_url
    end

    context 'user is not the project leader' do
      it 'raise an error' do
        create :team_leader, project: project

        expect { 
          ProjectSourceCode.start_repository project, create(:developer), 'repository_name'
        }.to raise_exception(Exception, /Only the project team leader can start it's repository/)
      end
    end
  end
end
