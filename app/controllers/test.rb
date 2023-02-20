alphabet = Array("a".."z")
p alphabet
letters = []
10.times { letters << alphabet[rand(0...alphabet.size)] }
p letters
