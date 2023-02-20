require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @alphabet = Array("a".."z")
    @letters = []
    10.times { @letters << @alphabet[rand(0...@alphabet.size)] }
    @@let = @letters
    @@starting_time = Time.now
  end

  def score
    @@let
    @word = params[:word]
    @word_exist = word_exist?(@word)
    @word_in_grid = word_in_grid?(@word, @@let)
    @results = results(@word_exist, @word_in_grid, @word)
    @total_time = (Time.now - @@starting_time).to_i
  end

  private

  def word_exist?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    dictionary = URI.open(url).read
    parsed_dictionary = JSON.parse(dictionary)
    parsed_dictionary['found']
  end

  def word_in_grid?(word, grid)
    word_in_grid = true
    word.chars.each do |letter|
      if grid.include?(letter)
        grid.delete_at(grid.index(letter))
      else
        word_in_grid = false
        break
      end
    end
    word_in_grid
  end

  def results(word_exists, word_in_grid, attempt)
    results = { score: 0 }
    if word_exists == false
      results[:message] = "The word: #{attempt.upcase} is not an english word!"
    elsif word_in_grid == false
      results[:message] = "The word: #{attempt.upcase} is not in the grid"
    else
      results[:score] = 10 + attempt.size
      results[:message] = "Well done! Your score is: #{results[:score]}"
    end
    results
  end
end
