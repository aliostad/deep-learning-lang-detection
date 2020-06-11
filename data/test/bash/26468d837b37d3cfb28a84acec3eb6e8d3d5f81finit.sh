cloud_vagrant_virtualbox_usage() {
	usage_section "vagrant-virtualbox box"

	usage_description "This plugin builds a 'Vagrant box' suitable for
	                  use with Virtualbox, the default Vagrant
	                  virtualisation provider."
}

register_usage "cloud_vagrant_virtualbox_usage"

load_plugin_or_die "misc/vagrant"

load_plugin_or_die "misc/raw-image-file"
load_plugin_or_die "partitioner/required"
load_plugin_or_die "misc/ext4-filesystem"

load_plugin_or_die "package/dhclient"
load_plugin_or_die "package/grub"
load_plugin_or_die "package/sshd"
load_plugin_or_die "package/sudo"

disk_partition() {
	echo "/dev/sda$1"
}
