require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = ('a'..'z').to_a.sample(10)
  end

  def score
    grid = params[:letters].split
    attempt = params[:guess]
    word_hash = JSON.parse(URI.open("https://wagon-dictionary.herokuapp.com/#{attempt.downcase}").read)
    print word_hash
    if attempt.chars.all? { |c| grid.include?(c) } && get_bool(attempt, grid)
      if word_hash.key?("error")
        @result = "#{attempt} is not an english word. "
      else
        @result = "Well done, #{attempt} is a word & in the grid."
      end
    else
      @result = "#{attempt} is not in the grid. "
    end

  end

  def get_bool(str, arr)
    my_arr = str.chars.map do |c|
      str.chars.count(c) <= arr.count(c)
    end
    my_arr.all?(true)
  end
end
