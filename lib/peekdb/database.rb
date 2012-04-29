class Database

  attr_reader :name, :connection, :tables, :relations

  def initialize(name)
    @name = name

    begin
      open_connection(@name)
      puts "... Inspecting database #{@name}"

      find_tables
      puts "... Found #{@tables.size} tables"

      find_relations
      puts "... Found #{@relations.size} relations"
    rescue Exception => e
      puts "... Error #{e}"
      exit(1)
    end
  end

  private

  def open_connection(database_name)
    raise NotImplementedError
  end

  def find_tables
    raise NotImplementedError
  end

  def find_relations
    raise NotImplementedError
  end
end