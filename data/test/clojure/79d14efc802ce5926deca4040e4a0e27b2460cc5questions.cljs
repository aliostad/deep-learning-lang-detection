(ns om-quiz.questions)

(def questions
  [{:question "What is the Answer to the Ultimate Question of Life, Universe, and Everything?"
    :answer "42"
    :choices ["0" "24" "42" "NaN" "\"\""]
    :score 1}
   {:question "What was eventually accepted for the Ultimate *Question* of Life, Universe, and Everything?"
    :choices ["What is yellow and dangerous?"
              "How many roads must a man walk down?"
              "How many Vogons does it take to change a lightbulb?"
              "What is six times seven?"
              "What is six times nine (in base 13)?"
              "None of the above."]
    :answer "How many roads must a man walk down?"
    :score 2}
   {:question "In the beginning of the 1st book, Arthur Dent's house was demolished to make way for what?"
    :choices ["A subway."
              "A corporate headquaters."
              "A pub."
              "A bypass."]
    :answer  "A bypass."
    :score 3}
   {:question "In the beginning of the 1st book, planet Earth was demolished to make way for what?"
    :choices ["A sub-etha casino."
              "A Galgafrinchian golf course."
              "A Hyperspace bypass."
              "A space maze for white mice."]
    :answer  "A Hyperspace bypass."
    :score 4}
   {:question "Yeah, that's *their* cover story - but really?"
    :choices ["To kill Arthur Dent, who was inexplicably woven into the fabric of time and space."
              "To kill Zaphod Beeblebrox, who had a secret locked up inside of his brain."
              "To kill Fenchurch, who had a secret locked up inside of her brain."
              "To stop the *real* question from being discovered on Earth."
              "3 and 4."
              "... demolishing planets is just what Vogons do."]
    :answer "3 and 4."
    :score 5}
   {:question "On planet Earth, in the ordering of the species by their intelligence level, what is the number assigned to Homo Sapiens?"
    :choices [ "1" "2" "3" "4" "5"]
    :answer "3"
    :score 6}
   {:question "What does Hitchhiker's Guide to the Galaxy has to say about planet Earth?"
    :choices ["Deadly."
              "Beautiful."
              "Boring."
              "Harmless."]
    :answer "Harmless."
    :score 7}
   {:question "... and after Ford Prefect spending 15 years stuck on the planet, what does it expand to?"
    :choices ["Deadly but boring."
              "Beautiful...kind of."
              "Boring but deadly."
              "Mostly harmless."]
    :answer "Mostly harmless."
    :score 8}
   {:question "Arthur Dent, when trying to get Heart of Gold's supercomputer to brew him a drink, was invariably getting a cup of hot, brown liquid, which was almost, but not quite, entirely unlike... what?"
    :choices [ "Tea"
               "Coffee"
               "Gin"
               "Milk"]
    :answer "Tea"
    :score 9}
   {:question "How do you pronounce \"Magrathea\""
    :choices ["MA-gra-the-a"
              "Ma-GRA-the-a"
              "Ma-gra-THE-a"
              "Ma-gra-the-A"]
    :answer "Ma-gra-THE-a"
    :score 10}
   {:question "When orbiting the legendary planet of Magrathea, two incoming nuclear missiles were turned by the Improbability Drive of Heart Of Gold spaceship into... what, exactly?"
    :choices ["A little rubber mallet and a vinyl of Elvis."
              "A sperm whale and bowl of petunias."
              "A team of sales executives."
              "All of the above."]
    :answer "A sperm whale and bowl of petunias."
    :score 11}
   {:question " What's the trick to learning how to fly?"
    :choices ["Really convince yourself you actually can do it."
              "Procuring some antigrav gel."
              "Start falling but manage to miss the ground."
              "Spend an year on top of a pillar on a second planet of Stavromula Beta."]
    :answer "Start falling but manage to miss the ground."
    :score 12}
   {:question " Written in thirty-foot high letters of fire on top of the Quentulus Quazgar Mountains in the land of Sevorbeupstry on planet Preliumtarn is God's Final Message to His Creation. What is it?"
    :choices ["Conditions may apply."
              "May cause depression and anxiety."
              "Don't panic!"
              "We apologize for the inconvenience."]
    :answer "We apologize for the inconvenience."
    :score 13}
   {:question " Marvin, 'the paranoid android', especially loathed this creation of his native Cirius Cybernetics Corporation."
    :choices ["Robotic tanks."
              "Electronic salesmen."
              "Sentient elevators."
              "Talking doors."]
    :answer "Talking doors."
    :score 14}
   {:question " As a Sandwich Maker of Lamuella, meat of what animal was Arthur Dent using for his sandwiches?"
    :choices ["Perfectly Normal Beast"
              "The Dish Of The Day"
              "Scintillating Jeweled Scuttling Crabs"
              "None of the above"]
    :answer "Perfectly Normal Beast"
    :score 15}
   {:question "What was the message dolphins left on Earth, before disappearing?"
    :choices ["So long, and thanks for all the fish."
              "It was nice, but now it's gone."
              "Take care, and visit us on Santraginus V."]
    :answer "So long, and thanks for all the fish."
    :score 16}
   {:question "What was the name of the daughter of Arthur Dent and Trillian."
    :choices ["Last Call Amanda"
              "Melody Pond"
              "Eccentrica Gallumbits"
              "Random Frequent Flyer"]
    :answer "Random Frequent Flyer"
    :score 17}
   {:question "Which of these books is NOT mentioned in Hitchhiker's Guide To The Galaxy"
    :choices ["Hitchhiker's Guide To The Galaxy"
              "What You Never Wanted to Know About Sex But Were Forced To Find Out"
              "Some More Of God's Greatest Mistakes"
              "Last Chance To See"
              "The Salmon Of Doubt"
              "Fifty-Three More Things To Do In Zero Gravity"]
    :answer "The Salmon Of Doubt"
    :score 18}])
