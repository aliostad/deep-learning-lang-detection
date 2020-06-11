class VboxSnapshotVmDriver < VmDriver

  def initialize
    @name = get_env("NAME")
    @ip = get_env("IP")
    @snapshot = get_env("SNAPSHOT")
  end

  def init
    vbox_manage "snapshot \"#{@name}\" restore \"#{@snapshot}\""
    vbox_manage "startvm \"#{@name}\" --type headless"
    sleep 2
  end

  def ip
    @ip
  end

  def destroy
    unless ENV["KEEP_SERVER"]
      vbox_manage "controlvm \"#{@name}\" poweroff"
      sleep 2
    end
  end

  private

    def vbox_manage cmd
      exec_local "VBoxManage #{cmd}"
    end

end