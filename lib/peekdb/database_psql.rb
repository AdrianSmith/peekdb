class DatabasePSQL < Database

  attr_reader :name, :connection, :tables, :relations

  private

  def open_connection(database_name)
    @connection = PGconn.open(:dbname => @name)
  end

  # Reference from PostgreSQL:
  # \d information_schema.tables
  # Column                       |               Type                | Modifiers
  # -----------------------------+-----------------------------------+-----------
  # table_catalog                | information_schema.sql_identifier |
  # table_schema                 | information_schema.sql_identifier |
  # table_name                   | information_schema.sql_identifier |
  # table_type                   | information_schema.character_data |
  # self_referencing_column_name | information_schema.sql_identifier |
  # reference_generation         | information_schema.character_data |
  # user_defined_type_catalog    | information_schema.sql_identifier |
  # user_defined_type_schema     | information_schema.sql_identifier |
  # user_defined_type_name       | information_schema.sql_identifier |
  # is_insertable_into           | information_schema.yes_or_no      |
  # is_typed                     | information_schema.yes_or_no      |
  # commit_action                | information_schema.character_data |
  def find_tables
    sql = <<-eos
    SELECT table_name
    FROM information_schema.tables
    WHERE table_type = 'BASE TABLE'
    AND table_schema = 'public'
    eos
    @tables = @connection.exec(sql).values.flatten
  end

  # Reference from PostgreSQL:
  # [0] constraint_name
  # [1] table_name
  # [2] column_name
  # [3] foreign_table_name
  # [4] foreign_column_name
  def find_relations
    sql = <<-eos
    SELECT
    tc.constraint_name, tc.table_name, kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name
    FROM
    information_schema.table_constraints AS tc
    JOIN information_schema.key_column_usage AS kcu ON tc.constraint_name = kcu.constraint_name
    JOIN information_schema.constraint_column_usage AS ccu ON ccu.constraint_name = tc.constraint_name
    WHERE constraint_type = 'FOREIGN KEY'
    eos
    @relations = @connection.exec(sql).values
  end
end