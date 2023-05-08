require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @load_time = Time.now
    vowels = %w[a e i o u]
    @letters = []
    2.times do
      @letters << vowels.sample
    end
    # while @letters.count < 10
    #   @letters << ('a'..'z').to_a.sample
    # end
    @letters += ('a'..'z').to_a.sample(8)
    @letters.shuffle
  end

  def score
    grid = params[:letters].split
    attempt = params[:guess]
    load_time = Time.parse(params[:load_time])
    post_time = Time.now
    r_s = 1 / (post_time - load_time) * attempt.length
    word_hash = JSON.parse(URI.open("https://wagon-dictionary.herokuapp.com/#{attempt.downcase}").read)
    if attempt.chars.all? { |c| grid.include?(c) } && get_bool(attempt, grid)
      if word_hash.key?("error")
        @result = "score: 0 & #{attempt} is not an english word. "
      else
        @result = "score: #{(r_s*10).round(2)} Well done, #{attempt} is a word & in the grid."
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
