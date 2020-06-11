require 'shell_shock/context'
require 'shh/commands'

class Shh::EntriesMenu
  include Shh::Command
  include ShellShock::Context

  def initialize io, repository
    @io, @repository = io, repository
    @prompt_text = 'shh > '
    @commands = {
      'ls'   => load_command(:list_entries, @repository, @io),
      'cd'   => load_command(:open_entry, @repository, @io)
    }
    if @repository.vcs_supported?
      @commands['history'] = load_command(:show_history, @repository, @io)
      @commands['exhume'] = load_command(:exhume_entry, @repository, @io)
      @commands['diff'] = load_command(:diff_entry, @repository, @io)
      @commands['ci'] = load_command(:commit_changes, @repository, @io)
    end
  end
end