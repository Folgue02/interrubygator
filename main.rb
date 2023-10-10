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

  def right_answer
    @answers[@right]
  end

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

    return @right == choice - 1
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

class QuestionBundle
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

    return score
  end

  def to_s
    sb = StringIO.new

    @questions.each do |question|
      sb.puts question.to_s
      sb.puts "" 
    end

    return sb.string
  end

  def length
    @questions.length
  end
end

def blank_string?(text)
  return text.strip == ""
end

def main
  if ARGV.length < 1
    puts "No file specified :("
  else
    bdl = QuestionBundle.new ARGV[0]
    puts "Loaded file '#{ARGV[0]}' with #{bdl.length} question(s)"

    start = Integer(Time.now.strftime '%s%L')
    puts "Right answers: #{bdl.prompt_all}/#{bdl.length}"
    endTime = Integer(Time.now.strftime '%s%L')
    puts "You've finished the test in #{(endTime - start) / 1000} seconds, with an average of #{(endTime - start) / 1000 / bdl.length} per question."
  end
end


main()
