module DatabaseLoader
  class << self
    def prepare_database
      create_database
      create_table
    end

    private

    def db_config
      @db_config ||= begin
        filepath = File.join('spec', 'database.yml')
        YAML.load_file(filepath)['test']
      end
    end

    def establish_connection(config = nil)
      config = db_config unless config
      ActiveRecord::Base.establish_connection(config)
      ActiveRecord::Base.connection
    end

    def create_database
      system_config = db_config.merge('database' => 'postgres', 'schema_search_path' => 'public')
      connection = establish_connection(system_config)
      connection.create_database(db_config['database']) rescue nil
      enable_extension
    end

    # :nocov:
    def enable_extension
      connection = establish_connection
      unless connection.select_value("SELECT proname FROM pg_proc WHERE proname = 'akeys'")
        if connection.send(:postgresql_version) < 90100
          pg_sharedir = `pg_config --sharedir`.strip
          hstore_script_path = File.join(pg_sharedir, 'contrib', 'hstore.sql')
          connection.execute(File.read(hstore_script_path))
        else
          connection.execute('CREATE EXTENSION IF NOT EXISTS hstore')
        end
      end
    end
    # :nocov:

    def create_table
      connection = establish_connection
      connection.create_table(:posts, :force => true) do |t|
        t.string :title
        t.column :title_translations, 'hstore'
      end
    end
  end
end
