#!/bin/env ruby
require 'stringio'

class QuestionBuilder
  def initialize(prompt)
    @prompt = prompt
    @right = nil
    @answers = []
  end

  def add_answer(answer)
    answer.strip!

    if answer.start_with? '@'
      if !@right.nil?
        raise ArgumentError, "Redefining the index for the right question (prompt: #{@prompt}, current answer: #{answer}, previous right index: #{@right}"
      end

      answer.slice!(0)
      @right = @answers.length
    end

    @answers << answer
  end

  def build
    if @right.nil?
      raise ArgumentError, "No right answer for question #{@prompt}"
    end
    question = Question.new(@prompt, @answers, @right)
    return question
  end
end

class Question
  def initialize(question_prompt, answers = [], right = 0)
    @question_prompt = question_prompt
    @answers = answers
    @right = right

    if @answers.length <= @right
      raise ArgumentError, "#{@right} is out of bounds for answers with length #{@answers.length}"
    end
  end

  # Displays the question's prompts and its answers listed.
  #
  # NOTE: The answers will have an index next to them, this 
  # index starts at '1' instead of '0'
  def display(index=nil)
    puts "-" * 30
    if !index.nil?
      print "#{index}. "
    end
    puts " :: #{@question_prompt}"
    puts "-" * 30

    count = 1
    @answers.each do |answer|
      puts " [#{count}]: #{answer}"
      count += 1
    end

  end

  # Returns the right answer.
  def right_answer
    @answers[@right]
  end

  # Displays the answers with the given index (if given)
  # and prompts the user. The answer returned will correspond to
  # its index in @answers (the user's answer - 1).
  def prompt(index = nil)
    self.display index

    choice = -1 
    while choice < 1 || choice > @answers.length
      print "Answer: "
      choice = STDIN.gets.chomp.to_i

      if choice > @answers.length
        puts "Invalid answer (range: 0, #{@answers.length})"
      end
    end

    @right == choice - 1
  end

  def to_s
    sb = StringIO.new
    sb.puts "#{@question_prompt} (RIGHT QUESTION INDEX: #{@right})"

    count = 1
    @answers.each do |answer|
      sb.puts " #{count}: #{answer}"
      count += 1
    end
    
    return sb.string
  end

  attr_reader :question_prompt, :answers, :right
end

# Represents a collection of questions.
class QuestionBundle
  # Reads a file line by line creating questions
  def initialize(file_path)
    @questions = []

    current_question = nil

    File.foreach(file_path) do |line|
      if blank_string?(line) 
        next
      elsif line.start_with? " "
        if current_question.nil?
          raise ArgumentError, "The file starts with an answer (#{line}) instead of a prompt."
        end
        current_question.add_answer line
      else
        if !current_question.nil?
          @questions << current_question.build
          current_question = nil
        end
        current_question = QuestionBuilder.new line 
      end
    end
    if !current_question.nil?
      @questions << current_question.build
    end
  end

  # Shuffles all questions
  def shuffle!
    @questions.shuffle!
  end

  # Prompts question by question, returning
  # the number of right answers given by the user.
  def prompt_all
    score = 0

    count = 0
    @questions.each do |question|
      count += 1
      if question.prompt count
        score += 1
      else
        puts "Incorrect! The right answer was: #{question.right_answer}"
      end
    end

    score
  end

  def to_s
    sb = StringIO.new

    @questions.each do |question|
      sb.puts question.to_s
      sb.puts "" 
    end

    sb.string
  end

  # Number of questions
  def length
    @questions.length
  end
end

# Checks if the given string is empty/only 
# contains spaces.
def blank_string?(text)
  return text.strip == ""
end
