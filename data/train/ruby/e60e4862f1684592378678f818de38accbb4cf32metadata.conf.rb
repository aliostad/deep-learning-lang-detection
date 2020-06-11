{
  :Deliverables => {
    'TestDeliverable' => {
      :Processes => {
        :DummyBuild => {
          :FullyAutomated => true,
          :Dir => $FSCMSTest_RepositoryToolsDir,
          :Cmd => 'ruby -w DummyBuild.rb @{DeliverableDir} @{ProcessParam1} @{ProcessParam2}'
        }
      },
      :Execute => {
        :Process => :DummyBuild,
        :Parameters => {
          :ProcessParam1 => 'ProcessParam1Value',
          :ProcessParam2 => 'ProcessParam2Value'
        }
      }
    }
  }
}