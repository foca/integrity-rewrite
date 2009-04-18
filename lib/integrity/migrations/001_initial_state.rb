module Integrity
  module Migrations
    class InitialState < Sequel::Migration
      def up
        create_table :projects do
          primary_key :id
          varchar     :name
          varchar     :permalink, :unique => true
          varchar     :repo_kind
          varchar     :repo_uri
          varchar     :repo_branch
          text        :build_script
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
