require 'open-uri'
require 'JSON'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      @letters << ('A'..'Z').to_a.sample(1)
    end
    @start_time = Time.now
  end

  def score(word)
    end_time = Time.now
    results = run_game(word, @letter, @start_time, end_time)
  end

  private

  def run_game(attempt, grid, start_time, end_time)
    # TODO: runs the game and return detailed hash of resultrake
    result_hash = { time: end_time - start_time, score: 0.0, message: "Well done!" }

    # retrieve JSON object
    api_hash = JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{attempt}").read)

    # check if word is english, and in the grid
    if api_hash["found"] == false
      result_hash[:message] = "Word not found. Probably not an English word."
    elsif !check_in_grid?(attempt, grid)
      result_hash[:message] = "The given word is not in the grid"
    else
      result_hash[:score] = api_hash["length"].to_f + (8.0 / result_hash[:time])
    end

    return result_hash
  end

  def hashed(string)
    hashed_string = {}
    string.split("").each do |letter|
      hashed_string[letter] = 0 unless hashed_string.key?(letter)
      hashed_string[letter] += 1
    end
    return hashed_string
  end

  def check_in_grid?(attempt, grid)
    attempt.upcase.split("").all? { |letter| attempt.upcase.count(letter) <= grid.join.count(letter) }
  end
end
