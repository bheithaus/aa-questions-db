require 'singleton'
require 'sqlite3'
require './question'
require './user'
require './reply'

class QuestionDatabase < SQLite3::Database
  include Singleton

  def initialize
    super("questions.db")
    self.results_as_hash = true
    self.type_translation = true
  end
end

DB ||= QuestionDatabase.instance







