require 'pg'
require 'graphviz'
require 'optparse'
require 'ostruct'
require 'pry'

require_relative 'peekdb/graph'
require_relative 'peekdb/database'
require_relative 'peekdb/database_psql'
require_relative 'peekdb/database_mysql'
require_relative 'peekdb/database_sqlite'

class PeekDB

  def initialize(argv)
    puts "PeekDB:"
    begin
      parse_options(argv)
    rescue Exception => e
      puts "... Error FATAL: #{e}"
      exit(1)
    end
  end

  def parse_options(args)
    @options = OpenStruct.new

    opts = OptionParser.new do |opts|
      opts.banner = "Usage: peekdb [options]"
      opts.program_name = "PeekDB"
      opts.separator ""
      opts.separator "Specific options:"

      opts.on("-n", "--name NAME", "Name of database - required") do |name|
        @options.name = name
      end

      opts.on("-t", "--type [TYPE]", [:psql, :mysql, :sqlite], "Type of database (psql, mysql, sqlite) - required") do |type|
        @options.type = type
      end

      opts.on("-f", "--format [FORMAT]", [:pdf, :dot], "Format of output file (pdf, dot) - default pdf") do |format|
        @options.format = format
      end
    end
    opts.parse!(args)
  end

  def run
    if @options.name && @options.name
      case @options.type
      when :psql
        db = DatabasePSQL.new @options.name
      when :mysql
        db = DatabaseMySQL.new @options.name
      when :sqlite
        db = DatabaseSQLite.new @options.name
      else
        puts "... Error FATAL: Unknown database type #{@options.type}"
        exit(1)
      end

      graph = Graph.new
      graph.build(db.name, db.tables, db.relations)
      graph.output(db.name, @options.format)
    else
      puts '... Error FATAL: missing arguments'
      exit(1)
    end
  end

  def self.usage
    puts <<-EOT
    Usage: rails COMMAND [ARGS]

    The most common rails commands are:
    generate    Generate new code (short-cut alias: "g")
    console     Start the Rails console (short-cut alias: "c")
    server      Start the Rails server (short-cut alias: "s")
    dbconsole   Start a console for the database specified in config/database.yml
    (short-cut alias: "db")
    new         Create a new Rails application. "rails new my_app" creates a
    new application called MyApp in "./my_app"

    In addition to those, there are:
    application  Generate the Rails application code
    destroy      Undo code generated with "generate" (short-cut alias: "d")
    benchmarker  See how fast a piece of code runs
    profiler     Get profile information from a piece of code
    plugin new   Generates skeleton for developing a Rails plugin
    runner       Run a piece of code in the application environment (short-cut alias: "r")

    All commands can be run with -h (or --help) for more information.
    EOT
  end

end