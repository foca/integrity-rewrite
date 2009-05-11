module Integrity
  module Migrations # :nodoc:
    class InitialState < Sequel::Migration # :nodoc:
      def up
        create_table :projects do
          primary_key :id
          varchar     :name
          varchar     :permalink, :unique => true
          varchar     :kind
          varchar     :uri
          varchar     :branch
          text        :build_script
          boolean     :public
          timestamp   :created_at
          timestamp   :updated_at
        end

        create_table :commits do
          primary_key :id
          integer     :project_id
          varchar     :identifier, :unique => true
          varchar     :message
          varchar     :author
          timestamp   :committed_at
          timestamp   :created_at
          timestamp   :updated_at
        end

        create_table :builds do
          primary_key :id
          integer     :commit_id
          boolean     :status
          text        :output
          timestamp   :started_at
          timestamp   :finished_at
          timestamp   :created_at
          timestamp   :updated_at
        end
      end

      def down
        drop_table :builds
        drop_table :commits
        drop_table :projects
      end
    end
  end
end
