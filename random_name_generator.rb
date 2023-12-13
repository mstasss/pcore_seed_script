def generate_fake_name
    alphabet = ('a'..'z').to_a
    first_word_length = rand(4..7)
    second_word_length = rand(4..7)

    first_word = Array.new(first_word_length) { alphabet.sample }.join
    second_word = Array.new(second_word_length) { alphabet.sample }.join

    "#{first_word} #{second_word}"
  end