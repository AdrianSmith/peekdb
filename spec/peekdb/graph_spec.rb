require_relative '../spec_helper.rb'

describe Graph do
  before do
    @tables = ['book', 'author', 'format']
    @relations = [
      ['author-book', 'author', 'id', 'book', 'id'],
      ['book-format', 'book', 'id',  'format', 'id']
    ]
  end

  it "should create a new graph using database table and relation data" do
    graph = Graph.new
    graph.build('test', @tables, @relations)
    graph.dwg.should be_not_nil
  end

end