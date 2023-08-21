require "json"
require "open-uri"

class GamesController < ApplicationController

  def new
    @letters = []
    vowels = %w[a e i o u]
    5.times do
      letter_random = (('a'..'z').to_a - vowels).sample
      @letters << vowels.sample
      @letters << letter_random
    end
  end

  def score
    @word = params[:word]
    @letters = params[:letters].split(' ')
    @score = 0
    @message = "Sorry but <strong>#{@word.upcase}</strong> can't be built out of #{@letters.join(', ').upcase}"
    if include_letters?(@letters, @word)
      @message = "Sorry but <strong>#{@word.upcase}</strong> does not seem to be a valid english word..."
      if checked?(@word)
        @message = "<strong>Congrats</strong> #{@word.upcase} is a valid english word"
        @score = 50
      end
    end
  end

  private

  def include_letters?(letters, word)
    results = word.chars.map do |character|
      letters.include?(character)
    end
    results.all?
  end

  def checked?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    response = URI.open(url).read
    parse_response = JSON.parse(response)
    parse_response['found']
  end
end
