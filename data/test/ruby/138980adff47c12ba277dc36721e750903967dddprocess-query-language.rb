
require 'plucky'

module ProcessQueryLanguage

  autoload :Version,          'process-query-language/version'
  autoload :Collection,       'process-query-language/collection'
  autoload :Matcher,          'process-query-language/matcher'

  module Backend
    autoload :ProcessStatus,  'process-query-language/backend/process-status'
  end

end


module Process

  def self.pql(backend)
    klass = ProcessQueryLanguage::Backend.const_get(backend)
    @@pql = ProcessQueryLanguage::Collection.new(klass.new)
  end

  # Only expose selected methods from the Plucky::Query object
  %w{ find remove count where }.each do |method|
    module_eval <<-eval
      def Process.#{method}(*args)
        @@pql ||= ProcessQueryLanguage::Collection.new(ProcessQueryLanguage::Backend::ProcessStatus.new)
        Plucky::Query.new(@@pql).#{method}(*args)
      end
    eval
  end

end
