require 'shak/repository_disk_store'

module Shak
  module Operation

    class NullUI < BasicObject
      def display_error(error)
      end
      def abort
      end
    end

    class Base

      def user_interface
        @user_interface ||= NullUI.new
      end
      attr_writer :user_interface

      protected


      def store
        @store ||= Shak::RepositoryDiskStore.new
      end

      def repository
        @repository ||= store.read
      end

      def write_repository
        store.write(repository)
      end

    end
  end
end
