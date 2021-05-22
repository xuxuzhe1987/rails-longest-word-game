require "open-uri"
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    grid = params[:letters]
    attempt = params[:word]
    if included?(attempt.upcase, grid)
      if english_word?(attempt)
        @score = "well done"
      else
        @score = "not an english word"
      end
    else
      @score = "not in the grid"
    end
  end

  private

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end
end
