module MarkLogic
  module Persistence
    include MarkLogic::Loggable
    extend ActiveSupport::Concern

    module ClassMethods
      def manage_connection=(manage_conn)
        @@manage_connection = manage_conn if manage_conn
      end

      def manage_connection
        @@manage_connection ||= MarkLogic::Connection.manage_connection
      end

      def admin_connection=(admin_conn)
        @@admin_connection = admin_conn if admin_conn
      end

      def admin_connection
        @@admin_connection ||= MarkLogic::Connection.admin_connection
      end
    end

    def connection=(conn)
      @connection = conn if conn
    end

    def connection
      @connection
    end

    def manage_connection=(manage_conn)
      @manage_connection = manage_conn if manage_conn
    end

    def manage_connection
      @manage_connection ||= MarkLogic::Connection.manage_connection
    end

    def admin_connection=(admin_conn)
      @admin_connection = admin_conn if admin_conn
    end

    def admin_connection
      @admin_connection ||= MarkLogic::Connection.admin_connection
    end
  end
end
