def draw_man(parts)
  empty_image = ['____________', '|      | ', '|      ', '|     ', '|      ', '|     ', '|   ', '------------']
  spare_parts = ['@', '/', '|', '\\', '|', '/', ' \\']
  if parts >= 1
    empty_image[2] += spare_parts[0]
  end
  if parts >= 2
    empty_image[3] += spare_parts[1]
  end
  if parts >= 3
    empty_image[3] += spare_parts[2]
  end
  if parts >= 4
    empty_image[3] += spare_parts[3]
  end
  if parts >= 5
    empty_image[4] += spare_parts[4]
  end
  if parts >= 6
    empty_image[5] += spare_parts[5]
  end
  if parts == 7
    empty_image[5] += spare_parts[6]
  end
  puts empty_image.join("\n")
end


def check_letter(word, letter)
  where_letter_is = []
  word.length.times do |w|
    if word.slice(w).downcase == letter.downcase
      where_letter_is.push(w)
    end
  end
  if where_letter_is == []
    nil
  else
    where_letter_is
  end
end


def display_result(word, letter_array)
  guessed_loc = {}
  letter_array.each do |letter|
    word.length.times do |w|
      if word.slice(w).downcase == letter.downcase
        guessed_loc[w] = true
      end
    end
  end
  word_letters = word.split('')
  word_letters.length.times do |o|
    if guessed_loc[o] == nil
      word_letters[o] = '_'
    end
  end
  puts 'You have guessed these letters'
  print letter_array.join(', '), "\n"
  puts word_letters.join(' ')
end

module Screen
  def self.clear
    system 'clear' or system 'cls'
  end
end

def len_choice(length, dict)
  word = dict.sample
  if length == 's'
    while word.length > 7 or word.length < 4
      word = dict.sample
    end
  elsif length == 'm'
    while word.length < 8 or word.length > 11
      word = dict.sample
    end
  elsif length == 'l'
    while word.length < 12
      word = dict.sample
    end
  else
    puts 'Your length will be random'
  end
  word
end

f = File.new('EnglishDictionary.txt', 'r')
webster = f.read.split("\n")
f.close
wrong_guesses = 0


guessed_letters = []

puts 'How long would you like your word?'
puts 'Type s for short (4-7 letters), m for medium (8-11), or l for long (12+)'
puts 'Anything else will be random'
request_len = gets.chomp.downcase

word_to_guess = len_choice(request_len, webster)

puts "Your word is #{word_to_guess.length} letters long. Guess a letter"
num_letters_guessed = 0
while true
  while true
    letter_guess = gets.chomp
    if letter_guess.length == 1 and letter_guess.length != ' '
      guessed = false
      guessed_letters.each do |l|
        if l == letter_guess
          puts 'Guess a different letter!'
          guessed = true
        end
      end
      if guessed
        next
      end

      if check_letter(word_to_guess, letter_guess) == nil
        wrong_guesses += 1
      else
        num_letters_guessed += check_letter(word_to_guess, letter_guess).length
      end

      guessed_letters.push(letter_guess)
    elsif letter_guess.length == word_to_guess.length
      if letter_guess == word_to_guess
        puts 'You got it!'
        num_letters_guessed = word_to_guess.length
      else
        puts 'Not the word!'
        wrong_guesses += 1
      end
    else
      puts 'Remember to guess only one letter!'
      next
    end
    Screen.clear
    draw_man(wrong_guesses)
    if letter_guess.length == 1 and letter_guess.length != ' '
      display_result(word_to_guess, guessed_letters)
    elsif letter_guess.length == word_to_guess.length and num_letters_guessed == word_to_guess.length
      puts word_to_guess.split('').join(' ')
    end
    if wrong_guesses == 7
      puts "Game over! The word was: #{word_to_guess}"
      break
    elsif num_letters_guessed == word_to_guess.length
      puts 'You win! You got the word!'
      break
    else
      puts 'Guess another letter, or try to type the word at any time'
      puts "Any input that is #{word_to_guess.length} letters long will be considered a word guess"
    end
  end


  puts 'Do you want to play again?(y/n)'
  puts 'Unless you type y, it will end the program'
  play_again = gets.chomp
  if play_again == 'y'
    wrong_guesses = 0
    guessed_letters = []
    puts 'How long would you like your word?'
    puts 'Type s for short (4-7 letters), m for medium (8-11), or l for long (12+)'
    request_len = gets.chomp.downcase
    word_to_guess = len_choice(request_len, webster)

    num_letters_guessed = 0
    puts "Your word is #{word_to_guess.length} letters long. Guess a letter"
  else
    puts 'Thanks for playing!'
    break
  end
end