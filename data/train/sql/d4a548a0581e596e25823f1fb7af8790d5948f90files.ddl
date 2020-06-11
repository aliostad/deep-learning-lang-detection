metadata    :name        => "File utilities for RPC Agents",
            :description => "",
            :author      => "David Ceresuela <david.ceresuela@gmail.com>",
            :license     => "",
            :version     => "0.3",
            :url         => "",
            :timeout     => 10

action "create", :description => "Creates a file" do
   display :always

   input :path,
         :prompt      => "The file path",
         :description => "The file path",
         :type        => :string,
         :validation  => '^.+$',
         :optional    => false,
         :maxlength   => 300

   input :content,
         :prompt      => "The content of the file",
         :description => "The content of the file",
         :type        => :string,
         :validation  => '^.+$',
         :optional    => false,
         :maxlength   => 3000

   output :success,
          :description => "Success on creating the file",
          :display_as  => "File created"

end


action "append", :description => "Appends content to a file" do
   display :always

   input :path,
         :prompt      => "The file path",
         :description => "The file path",
         :type        => :string,
         :validation  => '^.+$',
         :optional    => false,
         :maxlength   => 300

   input :content,
         :prompt      => "The content to be appended to the file",
         :description => "The content to be appended to the file",
         :type        => :string,
         :validation  => '^.+$',
         :optional    => false,
         :maxlength   => 3000

   output :success,
          :description => "Success on appending the content to the file",
          :display_as  => "Content appended"

end


action "append_check", :description => "Appends content to a file if it is not already there" do
   display :always

   input :path,
         :prompt      => "The file path",
         :description => "The file path",
         :type        => :string,
         :validation  => '^.+$',
         :optional    => false,
         :maxlength   => 300

   input :content,
         :prompt      => "The content to be appended to the file",
         :description => "The content to be appended to the file",
         :type        => :string,
         :validation  => '^.+$',
         :optional    => false,
         :maxlength   => 3000

   output :success,
          :description => "Success on appending the content to the file",
          :display_as  => "Content appended"

end


action "delete", :description => "Deletes a file" do
   display :always

   input :path,
         :prompt      => "The file path",
         :description => "The file path",
         :type        => :string,
         :validation  => '^.+$',
         :optional    => false,
         :maxlength   => 300

   output :success,
          :description => "Success on deleting the file",
          :display_as  => "File deleted"

end
