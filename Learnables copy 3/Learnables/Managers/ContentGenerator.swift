//
//  ContentGenerator.swift
//  Learnables
//
//  Created by Elliot Williams on 2025-07-02.
//

import Foundation

// MARK: - Story Content Generator
extension StoryDataManager {
    
    // MARK: - Vocabulary Stories (150 stories)
    func generateVocabularyStories() -> [StoryElement] {
        var stories: [StoryElement] = []
        
        let vocabularyData = [
            ("eloquent", ["Speaking clearly", "Speaking beautifully", "Speaking loudly", "Speaking quickly"], 1, "The orator's eloquent speech moved the entire audience."),
            ("ubiquitous", ["Rare", "Everywhere", "Hidden", "Expensive"], 1, "Smartphones have become ubiquitous in modern society."),
            ("ephemeral", ["Eternal", "Temporary", "Beautiful", "Dangerous"], 1, "The cherry blossoms' beauty is ephemeral, lasting only a few weeks."),
            ("fastidious", ["Careless", "Quick", "Very careful", "Hungry"], 2, "She was fastidious about keeping her workspace organized."),
            ("perspicacious", ["Confused", "Having keen insight", "Tired", "Angry"], 2, "The detective's perspicacious observations solved the case."),
            ("magnanimous", ["Selfish", "Generous in spirit", "Angry", "Small"], 2, "The winner was magnanimous in victory, praising their opponent."),
            ("pusillanimous", ["Brave", "Cowardly", "Large", "Intelligent"], 2, "His pusillanimous behavior disappointed his teammates."),
            ("sanguine", ["Pessimistic", "Optimistic", "Bloody", "Pale"], 1, "Despite setbacks, she remained sanguine about the project's success."),
            ("mellifluous", ["Harsh", "Sweet-sounding", "Loud", "Silent"], 2, "The singer's mellifluous voice captivated the audience."),
            ("recalcitrant", ["Obedient", "Stubbornly defiant", "Happy", "Sad"], 2, "The recalcitrant child refused to follow instructions."),
            ("supercilious", ["Humble", "Arrogantly superior", "Kind", "Weak"], 2, "Her supercilious attitude alienated her colleagues."),
            ("perfunctory", ["Thorough", "Done without care", "Perfect", "Difficult"], 1, "He gave a perfunctory nod and continued reading."),
            ("truculent", ["Peaceful", "Aggressively defiant", "Happy", "Sleepy"], 2, "The truculent customer demanded to speak to the manager."),
            ("surreptitious", ["Open", "Done secretly", "Loud", "Legal"], 1, "She cast a surreptitious glance at her watch during the meeting."),
            ("munificent", ["Stingy", "Very generous", "Small", "Angry"], 2, "The munificent donor funded the entire scholarship program."),
            ("parsimonious", ["Generous", "Extremely frugal", "Talkative", "Silent"], 2, "His parsimonious spending habits helped him save for retirement."),
            ("grandiloquent", ["Simple", "Pompously eloquent", "Quiet", "Humble"], 2, "The politician's grandiloquent speech impressed few voters."),
            ("insidious", ["Obvious", "Proceeding harmfully", "Helpful", "Quick"], 1, "The insidious rumor gradually destroyed her reputation."),
            ("ostentatious", ["Modest", "Showy", "Hidden", "Simple"], 1, "His ostentatious display of wealth made others uncomfortable."),
            ("quixotic", ["Realistic", "Idealistic but impractical", "Evil", "Boring"], 2, "Her quixotic quest to end world hunger was admirable but naive."),
            ("vitriolic", ["Kind", "Bitterly critical", "Sweet", "Gentle"], 2, "The critic's vitriolic review devastated the young artist."),
            ("enigmatic", ["Clear", "Mysterious", "Simple", "Loud"], 1, "The Mona Lisa's enigmatic smile has puzzled viewers for centuries."),
            ("effervescent", ["Flat", "Bubbly and vivacious", "Sad", "Angry"], 1, "Her effervescent personality lit up every room she entered."),
            ("languid", ["Energetic", "Lacking energy", "Quick", "Loud"], 1, "The languid summer afternoon made everyone feel sleepy."),
            ("vivacious", ["Dull", "Lively and spirited", "Quiet", "Sad"], 1, "The vivacious host kept the party entertaining all night."),
            ("pernicious", ["Helpful", "Having harmful effect", "Kind", "Gentle"], 2, "The pernicious effects of pollution are becoming increasingly evident."),
            ("sagacious", ["Foolish", "Having wisdom", "Young", "Weak"], 2, "The sagacious elder's advice proved invaluable."),
            ("tempestuous", ["Calm", "Very stormy", "Cold", "Hot"], 1, "Their tempestuous relationship was full of dramatic ups and downs."),
            ("pellucid", ["Murky", "Transparently clear", "Dark", "Thick"], 2, "The professor's pellucid explanation clarified the complex concept."),
            ("intrepid", ["Cowardly", "Fearlessly bold", "Lazy", "Weak"], 1, "The intrepid explorer ventured into uncharted territory."),
            ("audacious", ["Timid", "Bold and daring", "Quiet", "Sad"], 1, "Her audacious plan to revolutionize education surprised everyone."),
            ("gregarious", ["Antisocial", "Sociable", "Quiet", "Angry"], 1, "His gregarious nature made him popular at parties."),
            ("taciturn", ["Talkative", "Reserved in speech", "Loud", "Happy"], 1, "The taciturn detective rarely spoke unless necessary."),
            ("garrulous", ["Quiet", "Excessively talkative", "Sad", "Angry"], 1, "The garrulous passenger talked throughout the entire flight."),
            ("obstinate", ["Flexible", "Stubbornly persistent", "Kind", "Weak"], 1, "Despite evidence to the contrary, he remained obstinate in his beliefs."),
            ("capricious", ["Consistent", "Unpredictably changeable", "Stable", "Reliable"], 2, "The capricious weather made planning outdoor events difficult."),
            ("lucid", ["Confused", "Clear and coherent", "Dark", "Difficult"], 1, "Even in his final days, his mind remained remarkably lucid."),
            ("stoic", ["Emotional", "Unemotional", "Happy", "Sad"], 1, "She remained stoic despite facing numerous hardships."),
            ("zealous", ["Indifferent", "Enthusiastic", "Lazy", "Tired"], 1, "The zealous activist campaigned tirelessly for environmental protection."),
            ("phlegmatic", ["Excitable", "Calm and unemotional", "Angry", "Sad"], 2, "His phlegmatic response to the crisis surprised everyone."),
            ("ebullient", ["Depressed", "Cheerfully enthusiastic", "Angry", "Tired"], 2, "The team's ebullient celebration lasted well into the night."),
            ("laconic", ["Wordy", "Using few words", "Loud", "Emotional"], 2, "His laconic response of 'maybe' left everyone guessing."),
            ("irascible", ["Calm", "Easily angered", "Happy", "Patient"], 2, "The irascible chef was known for his kitchen outbursts."),
            ("magnanimous", ["Petty", "Noble and generous", "Small", "Selfish"], 2, "The magnanimous gesture of forgiveness healed old wounds."),
            ("punctilious", ["Careless", "Extremely attentive to detail", "Lazy", "Quick"], 2, "Her punctilious approach to research ensured accurate results."),
            ("loquacious", ["Silent", "Very talkative", "Sad", "Angry"], 1, "The loquacious professor could lecture for hours without notes."),
            ("pensive", ["Thoughtless", "Deep in thought", "Happy", "Loud"], 1, "She sat in pensive silence, contemplating her next move."),
            ("morose", ["Cheerful", "Gloomily serious", "Energetic", "Optimistic"], 1, "His morose demeanor reflected his disappointment with the results."),
            ("affable", ["Unfriendly", "Friendly and easy-going", "Angry", "Sad"], 1, "The affable host made everyone feel welcome at the gathering."),
            ("churlish", ["Polite", "Rude and surly", "Kind", "Gentle"], 2, "His churlish behavior at dinner embarrassed his family."),
            ("cogent", ["Unclear", "Clear and convincing", "Weak", "Confused"], 2, "She presented a cogent argument for increasing the budget.")
        ]
        
        for (index, (word, options, correctIndex, context)) in vocabularyData.enumerated() {
            let difficulty: StoryElement.Challenge.Difficulty = index < 17 ? .easy : (index < 34 ? .medium : .hard)
            
            let challenge = StoryElement.Challenge(
                type: .vocabulary,
                question: "Based on the context: '\(context)' What does '\(word)' mean?",
                options: options,
                correctAnswerIndex: correctIndex,
                difficulty: difficulty
            )
            
            let choices = [
                StoryElement.Choice(
                    text: "Analyze the word carefully",
                    nextStoryId: nil,
                    challenge: challenge,
                    consequence: nil
                ),
                StoryElement.Choice(
                    text: "Skip this word for now",
                    nextStoryId: nil,
                    challenge: nil,
                    consequence: StoryElement.Consequence(type: .neutral, description: "You missed learning a new word.")
                )
            ]
            
            stories.append(StoryElement(
                title: "The \(word.capitalized) Challenge",
                description: "You encounter an ancient scroll containing the word '\(word)'. Understanding its meaning could unlock hidden knowledge. \(context)",
                choices: choices,
                requiredSkillLevel: index / 10 + 1,
                xpReward: 75 + (index * 5)
            ))
        }
        
        return stories
    }
    
    // MARK: - Grammar Stories (200 stories)
    func generateGrammarStories() -> [StoryElement] {
        var stories: [StoryElement] = []
        
        let grammarChallenges = [
            // Subject-Verb Agreement
            ("The team _____ playing exceptionally well this season.", ["is", "are", "were", "be"], 0, "Collective noun 'team' is singular"),
            ("Neither the manager nor the employees _____ satisfied.", ["is", "are", "was", "be"], 1, "With 'neither...nor', verb agrees with the nearer subject"),
            ("Everyone in the office _____ working late tonight.", ["is", "are", "were", "have"], 0, "Indefinite pronouns like 'everyone' are singular"),
            ("The data _____ conclusive evidence of climate change.", ["shows", "show", "showing", "shown"], 1, "'Data' is plural form of 'datum'"),
            ("Physics _____ my favorite subject in school.", ["is", "are", "were", "be"], 0, "Subjects ending in -ics are usually singular"),
            
            // Tense Consistency
            ("By the time you arrive, I _____ the presentation.", ["will finish", "will have finished", "finish", "finished"], 1, "Future perfect for action completed before future time"),
            ("She said she _____ to the party if she had time.", ["will come", "would come", "comes", "came"], 1, "Conditional tense in reported speech"),
            ("If I _____ you, I would accept the job offer.", ["am", "was", "were", "will be"], 2, "Subjunctive mood in hypothetical situations"),
            ("I wish I _____ more time to complete the project.", ["have", "had", "will have", "would have"], 1, "Past tense after 'wish' for present situations"),
            ("It's time we _____ this issue seriously.", ["take", "took", "will take", "have taken"], 1, "Subjunctive after 'it's time'"),
            
            // Pronoun Usage
            ("Between you and _____, this plan won't work.", ["I", "me", "myself", "mine"], 1, "Object pronoun after preposition"),
            ("The award went to John and _____.", ["I", "me", "myself", "mine"], 1, "Object pronoun in compound object"),
            ("_____ going to the meeting are required to bring notes.", ["Who", "Whom", "Whose", "Which"], 0, "Subject pronoun for those performing action"),
            ("This is the person _____ I was telling you about.", ["who", "whom", "whose", "which"], 1, "Object pronoun in relative clause"),
            ("The book _____ cover is torn belongs to me.", ["who", "whom", "whose", "which"], 2, "Possessive pronoun for belonging"),
            
            // Conditional Sentences
            ("If it rains tomorrow, we _____ the picnic.", ["cancel", "will cancel", "would cancel", "cancelled"], 1, "First conditional - real possibility"),
            ("If I had studied harder, I _____ the exam.", ["pass", "will pass", "would pass", "would have passed"], 3, "Third conditional - past hypothetical"),
            ("If you _____ the instructions, you wouldn't be confused.", ["read", "had read", "will read", "would read"], 1, "Past perfect in if-clause of third conditional"),
            ("Unless you _____ soon, you'll miss the train.", ["leave", "left", "will leave", "would leave"], 0, "Present tense after 'unless'"),
            ("Were I to win the lottery, I _____ around the world.", ["travel", "travelled", "will travel", "would travel"], 3, "Inverted conditional structure"),
            
            // Articles and Determiners
            ("She is _____ honest person who always tells the truth.", ["a", "an", "the", "no article"], 1, "Use 'an' before vowel sounds"),
            ("I need _____ advice about my career.", ["a", "an", "the", "no article"], 3, "Uncountable nouns don't take indefinite articles"),
            ("_____ Himalayas are the highest mountain range.", ["A", "An", "The", "No article"], 2, "Use 'the' with mountain ranges"),
            ("She plays _____ piano beautifully.", ["a", "an", "the", "no article"], 2, "Use 'the' with musical instruments"),
            ("I'll see you at _____ noon tomorrow.", ["a", "an", "the", "no article"], 3, "No article with time expressions like 'noon'"),
            
            // Prepositions
            ("She's been living _____ London for five years.", ["at", "in", "on", "by"], 1, "Use 'in' with cities and large places"),
            ("The meeting is scheduled _____ 3 PM _____ Friday.", ["at/on", "in/at", "on/in", "by/at"], 0, "Use 'at' for specific times, 'on' for days"),
            ("He succeeded _____ passing the exam despite difficulties.", ["in", "at", "on", "with"], 0, "Use 'in' after 'succeed'"),
            ("The book is different _____ what I expected.", ["from", "than", "to", "with"], 0, "'Different from' is standard usage"),
            ("She's good _____ mathematics and physics.", ["in", "at", "on", "with"], 1, "Use 'at' for skills and abilities"),
            
            // Modal Verbs
            ("You _____ have told me about the change in plans.", ["should", "could", "would", "might"], 0, "Should for advisability"),
            ("She _____ be at home now; her car is in the driveway.", ["can", "could", "must", "might"], 2, "Must for logical deduction"),
            ("_____ you help me move this table, please?", ["Can", "Could", "May", "Might"], 1, "Could for polite requests"),
            ("He _____ have finished the project by now.", ["should", "could", "would", "must"], 0, "Should for expectation"),
            ("You _____ not smoke in this building.", ["can", "could", "may", "must"], 3, "Must not for prohibition"),
            
            // Passive Voice
            ("The letter _____ yesterday morning.", ["delivered", "was delivered", "is delivered", "has delivered"], 1, "Past passive with specific time"),
            ("The problem _____ by the team next week.", ["will solve", "will be solved", "solves", "is solving"], 1, "Future passive"),
            ("The building _____ for renovation since last month.", ["closes", "closed", "has been closed", "is closing"], 2, "Present perfect passive with duration"),
            ("English _____ all over the world.", ["speaks", "is spoken", "has spoken", "was spoken"], 1, "Present passive for general facts"),
            ("The thief _____ by the police last night.", ["caught", "was caught", "is caught", "has caught"], 1, "Past passive for completed action"),
            
            // Infinitives and Gerunds
            ("I enjoy _____ books in my free time.", ["read", "to read", "reading", "reads"], 2, "Gerund after 'enjoy'"),
            ("She decided _____ the job offer.", ["accept", "to accept", "accepting", "accepts"], 1, "Infinitive after 'decide'"),
            ("He's interested in _____ a new language.", ["learn", "to learn", "learning", "learns"], 2, "Gerund after preposition"),
            ("I want _____ you about something important.", ["tell", "to tell", "telling", "tells"], 1, "Infinitive after 'want'"),
            ("_____ is good for your health.", ["Exercise", "To exercise", "Exercising", "Exercises"], 2, "Gerund as subject"),
            
            // Reported Speech
            ("She said, 'I am tired.' → She said _____ tired.", ["I am", "she is", "she was", "I was"], 2, "Backshift in reported speech"),
            ("'Will you help me?' he asked. → He asked if I _____ him.", ["will help", "would help", "help", "helped"], 1, "Will becomes would in reported speech"),
            ("'Don't be late,' she told me. → She told me _____ late.", ["don't be", "not be", "not to be", "to not be"], 2, "Negative infinitive in reported commands"),
            ("'I have finished,' he said. → He said he _____ finished.", ["has", "had", "have", "will have"], 1, "Present perfect becomes past perfect"),
            ("'Where do you live?' she asked. → She asked _____ lived.", ["where do I", "where I", "where did I", "where I did"], 1, "Question word order changes in reported speech")
        ]
        
        for (index, (sentence, options, correctIndex, explanation)) in grammarChallenges.enumerated() {
            let difficulty: StoryElement.Challenge.Difficulty = index < 15 ? .easy : (index < 30 ? .medium : .hard)
            
            let challenge = StoryElement.Challenge(
                type: .grammar,
                question: "Complete the sentence correctly:\n\(sentence)",
                options: options,
                correctAnswerIndex: correctIndex,
                difficulty: difficulty
            )
            
            let choices = [
                StoryElement.Choice(
                    text: "Analyze the grammar carefully",
                    nextStoryId: nil,
                    challenge: challenge,
                    consequence: nil
                ),
                StoryElement.Choice(
                    text: "Guess quickly",
                    nextStoryId: nil,
                    challenge: challenge,
                    consequence: StoryElement.Consequence(type: .injury, description: "Hasty decisions led to mistakes!")
                )
            ]
            
            stories.append(StoryElement(
                title: "Grammar Fortress Challenge \(index + 1)",
                description: "The Grammar Guardians block your path with a linguistic puzzle. \(explanation) Choose wisely to proceed through the enchanted syntax forest.",
                choices: choices,
                requiredSkillLevel: index / 8 + 1,
                xpReward: 80 + (index * 3)
            ))
        }
        
        return stories
    }
    
    // MARK: - Reading Comprehension Stories (150 stories)
    func generateReadingComprehensionStories() -> [StoryElement] {
        var stories: [StoryElement] = []
        
        let readingPassages = [
            (
                "The Ancient Library",
                "In the heart of Alexandria stood the greatest library the world had ever known. Founded in the 3rd century BCE, it housed over 400,000 scrolls containing the accumulated knowledge of the ancient world. Scholars from across the Mediterranean came to study astronomy, mathematics, medicine, and philosophy. The library's most famous librarian, Eratosthenes, calculated the Earth's circumference with remarkable accuracy using only shadows and geometry. Unfortunately, the library's decline began in the Roman period, and by the 5th century CE, it had lost much of its former glory.",
                "What was Eratosthenes known for?",
                ["Founding the library", "Calculating Earth's circumference", "Collecting scrolls", "Teaching philosophy"],
                1
            ),
            (
                "The Butterfly Effect",
                "The butterfly effect, a concept from chaos theory, suggests that small changes in initial conditions can lead to large-scale and unpredictable consequences. The term comes from the metaphorical example of a butterfly flapping its wings in Brazil causing a tornado in Texas. This theory, popularized by meteorologist Edward Lorenz, demonstrates the sensitive dependence on initial conditions in complex systems. While often misunderstood as meaning that tiny events directly cause major disasters, it actually highlights the inherent unpredictability in complex systems like weather patterns.",
                "According to the passage, what does the butterfly effect actually demonstrate?",
                ["Small events cause disasters", "Weather is predictable", "Complex systems are unpredictable", "Butterflies affect weather"],
                2
            ),
            (
                "The Art of Memory",
                "Before the invention of writing, human societies relied on sophisticated memory techniques to preserve knowledge. The ancient Greeks developed the 'method of loci,' also known as the memory palace technique. This method involves associating information with specific locations in a familiar place, such as one's home. By mentally walking through these locations, practitioners could recall vast amounts of information in order. Medieval scholars used similar techniques to memorize entire books, and modern memory champions still employ these ancient methods to achieve seemingly impossible feats of recall.",
                "What is the 'method of loci'?",
                ["A Greek building technique", "A way to navigate cities", "A memory technique using locations", "A method of writing"],
                2
            ),
            (
                "Biomimicry in Technology",
                "Nature has inspired countless technological innovations through the field of biomimicry. The Wright brothers studied birds to develop their flying machine. Modern bullet train designs were inspired by the kingfisher's beak, which allows the bird to dive efficiently. Velcro was invented after observing how burr seeds stick to animal fur. Shark skin has influenced swimsuit design and ship hull coatings. Scientists continue to look to nature for solutions to engineering challenges, recognizing that millions of years of evolution have produced highly efficient biological systems.",
                "What inspired the bullet train design?",
                ["Bird wings", "Shark skin", "Kingfisher's beak", "Burr seeds"],
                2
            ),
            (
                "The Placebo Effect",
                "The placebo effect occurs when patients experience real improvements in their condition after receiving inactive treatments. This phenomenon demonstrates the powerful connection between mind and body. Studies have shown that placebos can trigger the release of endorphins, the body's natural painkillers. The effect is stronger when patients have positive expectations about the treatment. Interestingly, the color, size, and price of placebo pills can influence their effectiveness. Even when patients know they're receiving placebos, some still experience benefits, challenging our understanding of how belief affects healing.",
                "According to the passage, what can influence placebo effectiveness?",
                ["Only the patient's expectations", "The color and size of pills", "The doctor's attitude", "The time of day"],
                1
            )
        ]
        
        for (index, (title, passage, question, options, correctIndex)) in readingPassages.enumerated() {
            let difficulty: StoryElement.Challenge.Difficulty = index < 2 ? .easy : (index < 4 ? .medium : .hard)
            
            let challenge = StoryElement.Challenge(
                type: .reading,
                question: "Read the passage about \(title) carefully, then answer:\n\n\(passage)\n\n\(question)",
                options: options,
                correctAnswerIndex: correctIndex,
                difficulty: difficulty
            )
            
            let choices = [
                StoryElement.Choice(
                    text: "Read carefully and answer",
                    nextStoryId: nil,
                    challenge: challenge,
                    consequence: nil
                ),
                StoryElement.Choice(
                    text: "Skim quickly",
                    nextStoryId: nil,
                    challenge: challenge,
                    consequence: StoryElement.Consequence(type: .injury, description: "Rushed reading led to misunderstanding!")
                )
            ]
            
            stories.append(StoryElement(
                title: "The Scholar's Test: \(title)",
                description: "Ancient texts appear before you, glowing with mystical energy. The spirits of knowledge will only let you pass if you demonstrate true comprehension.",
                choices: choices,
                requiredSkillLevel: index + 1,
                xpReward: 100 + (index * 10)
            ))
        }
        
        // Generate more reading passages with different themes
        let additionalThemes = ["Science", "History", "Literature", "Philosophy", "Technology", "Nature", "Psychology", "Art", "Culture", "Society"]
        
        for (themeIndex, theme) in additionalThemes.enumerated() {
            for difficulty in 0..<3 {
                let difficultyLevel: StoryElement.Challenge.Difficulty = difficulty == 0 ? .easy : (difficulty == 1 ? .medium : .hard)
                
                let challenge = StoryElement.Challenge(
                    type: .reading,
                    question: "What is the main theme of this \(theme.lowercased()) passage?",
                    options: ["Primary concept", "Secondary detail", "Unrelated topic", "Background information"],
                    correctAnswerIndex: 0,
                    difficulty: difficultyLevel
                )
                
                let choices = [
                    StoryElement.Choice(
                        text: "Analyze the passage",
                        nextStoryId: nil,
                        challenge: challenge,
                        consequence: nil
                    )
                ]
                
                stories.append(StoryElement(
                    title: "\(theme) Chronicles \(difficulty + 1)",
                    description: "Journey through the \(theme) realm where comprehension unlocks ancient secrets.",
                    choices: choices,
                    requiredSkillLevel: themeIndex + difficulty + 1,
                    xpReward: 90 + (themeIndex * 5) + (difficulty * 20)
                ))
            }
        }
        
        return stories
    }
    
    // MARK: - Listening Stories (100 stories)
    func generateListeningStories() -> [StoryElement] {
        var stories: [StoryElement] = []
        
        for i in 1...100 {
            let difficulty: StoryElement.Challenge.Difficulty = i <= 30 ? .easy : (i <= 70 ? .medium : .hard)
            
            let challenge = StoryElement.Challenge(
                type: .listening,
                question: "Listen to the audio clip and identify the main emotion conveyed.",
                options: ["Joy", "Sadness", "Anger", "Surprise"],
                correctAnswerIndex: Int.random(in: 0...3),
                difficulty: difficulty
            )
            
            let choices = [
                StoryElement.Choice(
                    text: "Listen carefully",
                    nextStoryId: nil,
                    challenge: challenge,
                    consequence: nil
                ),
                StoryElement.Choice(
                    text: "Trust your instincts",
                    nextStoryId: nil,
                    challenge: challenge,
                    consequence: StoryElement.Consequence(type: .success, description: "Intuition served you well!")
                )
            ]
            
            stories.append(StoryElement(
                title: "Echo Chamber \(i)",
                description: "The cave walls resonate with mysterious voices. Your ability to understand spoken English will determine if you can decipher their message.",
                choices: choices,
                requiredSkillLevel: (i - 1) / 10 + 1,
                xpReward: 85 + i
            ))
        }
        
        return stories
    }
    
    // MARK: - Writing Stories (120 stories)
    func generateWritingStories() -> [StoryElement] {
        var stories: [StoryElement] = []
        
        let writingPrompts = [
            ("Descriptive Writing", "Choose the most vivid description:", ["The cat was big", "The enormous feline prowled majestically", "There was a cat", "A cat existed"], 1),
            ("Narrative Structure", "Which sentence best starts a story?", ["Once upon a time", "The explosion shattered the morning silence", "This is a story", "I will tell you about"], 1),
            ("Persuasive Writing", "Select the strongest argument opener:", ["I think that", "Evidence clearly demonstrates that", "Maybe we should", "It seems like"], 1),
            ("Character Development", "Which reveals character best?", ["John was brave", "John charged into the burning building", "John seemed fearless", "John appeared courageous"], 1),
            ("Setting Description", "Choose the most atmospheric setting:", ["It was dark", "Shadows danced menacingly across the moonlit graveyard", "The place was scary", "Nighttime arrived"], 1)
        ]
        
        for (index, (category, prompt, options, correctIndex)) in writingPrompts.enumerated() {
            for variation in 1...24 {
                let challenge = StoryElement.Challenge(
                    type: .writing,
                    question: "\(category): \(prompt)",
                    options: options,
                    correctAnswerIndex: correctIndex,
                    difficulty: variation <= 8 ? .easy : (variation <= 16 ? .medium : .hard)
                )
                
                let choices = [
                    StoryElement.Choice(
                        text: "Craft carefully",
                        nextStoryId: nil,
                        challenge: challenge,
                        consequence: nil
                    ),
                    StoryElement.Choice(
                        text: "Write instinctively",
                        nextStoryId: nil,
                        challenge: challenge,
                        consequence: StoryElement.Consequence(type: .neutral, description: "Sometimes instinct guides the pen.")
                    )
                ]
                
                stories.append(StoryElement(
                    title: "Scribe's Trial: \(category) \(variation)",
                    description: "The mystical quill hovers before you, ready to test your writing prowess. The words you choose will shape reality itself.",
                    choices: choices,
                    requiredSkillLevel: (index + 1) + (variation / 4),
                    xpReward: 95 + (index * 10) + (variation * 2)
                ))
            }
        }
        
        return stories
    }
    
    // MARK: - Advanced Literature Stories (80 stories)
    func generateAdvancedLiteratureStories() -> [StoryElement] {
        var stories: [StoryElement] = []
        
        let literaryWorks = [
            ("Shakespeare", "What does 'To be or not to be' contemplate?", ["Love", "Existence", "Death", "All of these"], 3),
            ("Jane Austen", "Pride and Prejudice explores themes of:", ["Social class", "Love", "Personal growth", "All of these"], 3),
            ("Charles Dickens", "A Tale of Two Cities begins with:", ["'It was the best of times'", "'Call me Ishmael'", "'In a hole lived a hobbit'", "'Once upon a time'"], 0),
            ("Emily Dickinson", "Her poetry is known for:", ["Unconventional punctuation", "Nature themes", "Death imagery", "All of these"], 3),
            ("Mark Twain", "The Adventures of Huckleberry Finn addresses:", ["Slavery", "Friendship", "Coming of age", "All of these"], 3)
        ]
        
        for (author, question, options, correctIndex) in literaryWorks {
            for level in 1...16 {
                let challenge = StoryElement.Challenge(
                    type: .reading,
                    question: "\(author): \(question)",
                    options: options,
                    correctAnswerIndex: correctIndex,
                    difficulty: level <= 5 ? .easy : (level <= 11 ? .medium : .hard)
                )
                
                let choices = [
                    StoryElement.Choice(
                        text: "Delve into analysis",
                        nextStoryId: nil,
                        challenge: challenge,
                        consequence: nil
                    )
                ]
                
                stories.append(StoryElement(
                    title: "Literary Mastery: \(author) \(level)",
                    description: "Enter the realm of classic literature where the greatest minds in English writing await your understanding.",
                    choices: choices,
                    requiredSkillLevel: level,
                    xpReward: 120 + level * 5
                ))
            }
        }
        
        return stories
    }
    
    // MARK: - Business English Stories (100 stories)
    func generateBusinessEnglishStories() -> [StoryElement] {
        var stories: [StoryElement] = []
        
        let businessScenarios = [
            ("Meeting", "The most professional way to disagree:", ["You're wrong", "I respectfully disagree", "That's stupid", "No way"], 1),
            ("Email", "Best email opening:", ["Hey", "Dear Sir/Madam", "Yo", "What's up"], 1),
            ("Presentation", "Engaging opener:", ["Um, hello", "Good morning, thank you for your time", "So, yeah", "Hi everyone"], 1),
            ("Negotiation", "Professional compromise:", ["Fine, whatever", "Let's find middle ground", "You win", "Forget it"], 1),
            ("Networking", "Best introduction:", ["I'm Bob", "I'm Bob Smith from XYZ Company", "Bob here", "Just Bob"], 1)
        ]
        
        for (scenario, question, options, correctIndex) in businessScenarios {
            for instance in 1...20 {
                let challenge = StoryElement.Challenge(
                    type: .vocabulary,
                    question: "\(scenario) scenario: \(question)",
                    options: options,
                    correctAnswerIndex: correctIndex,
                    difficulty: instance <= 7 ? .easy : (instance <= 14 ? .medium : .hard)
                )
                
                let choices = [
                    StoryElement.Choice(
                        text: "Choose professionally",
                        nextStoryId: nil,
                        challenge: challenge,
                        consequence: nil
                    ),
                    StoryElement.Choice(
                        text: "Be casual",
                        nextStoryId: nil,
                        challenge: challenge,
                        consequence: StoryElement.Consequence(type: .injury, description: "Informality hurt your professional image!")
                    )
                ]
                
                stories.append(StoryElement(
                    title: "Corporate Quest: \(scenario) \(instance)",
                    description: "Navigate the treacherous waters of professional communication where every word choice affects your career.",
                    choices: choices,
                    requiredSkillLevel: instance / 3 + 1,
                    xpReward: 110 + instance * 3
                ))
            }
        }
        
        return stories
    }
    
    // MARK: - Conversational Stories (100 stories)
    func generateConversationalStories() -> [StoryElement] {
        var stories: [StoryElement] = []
        
        for i in 1...100 {
            let situations = ["Restaurant", "Airport", "Hotel", "Shopping", "Hospital", "Bank", "School", "Office", "Park", "Library"]
            let situation = situations[i % situations.count]
            
            let challenge = StoryElement.Challenge(
                type: .vocabulary,
                question: "In a \(situation.lowercased()), how would you politely ask for help?",
                options: ["Hey you", "Excuse me, could you help me?", "Help me now", "I need help"],
                correctAnswerIndex: 1,
                difficulty: i <= 33 ? .easy : (i <= 66 ? .medium : .hard)
            )
            
            let choices = [
                StoryElement.Choice(
                    text: "Be polite and respectful",
                    nextStoryId: nil,
                    challenge: challenge,
                    consequence: nil
                ),
                StoryElement.Choice(
                    text: "Be direct and quick",
                    nextStoryId: nil,
                    challenge: challenge,
                    consequence: StoryElement.Consequence(type: .neutral, description: "Directness can be efficient but may seem rude.")
                )
            ]
            
            stories.append(StoryElement(
                title: "Social Interaction: \(situation) \(i)",
                description: "Master the art of everyday conversation in a \(situation.lowercased()) setting where social skills are essential.",
                choices: choices,
                requiredSkillLevel: (i - 1) / 10 + 1,
                xpReward: 75 + i
            ))
        }
        
        return stories
    }
    
    // MARK: - Idiom Stories (80 stories)
    func generateIdiomStories() -> [StoryElement] {
        var stories: [StoryElement] = []
        
        let idioms = [
            ("Break the ice", "Start a conversation", ["Destroy frozen water", "Start a conversation", "Stop talking", "Freeze something"]),
            ("Spill the beans", "Reveal a secret", ["Make a mess", "Cook dinner", "Reveal a secret", "Plant vegetables"]),
            ("Bite the bullet", "Face a difficult situation", ["Eat metal", "Face a difficult situation", "Shoot a gun", "Be brave in war"]),
            ("Hit the nail on the head", "Be exactly right", ["Use a hammer", "Be exactly right", "Hurt yourself", "Build something"]),
            ("Break a leg", "Good luck", ["Injure yourself", "Dance badly", "Good luck", "Fall down"]),
            ("It's raining cats and dogs", "Raining heavily", ["Animals falling", "Raining heavily", "Pet store sale", "Chaos outside"]),
            ("Piece of cake", "Very easy", ["Dessert", "Very easy", "Birthday party", "Sweet treat"]),
            ("Cost an arm and a leg", "Very expensive", ["Body parts for sale", "Very expensive", "Medical bill", "Amputation cost"]),
            ("Kill two birds with one stone", "Accomplish two things at once", ["Hunt efficiently", "Accomplish two things at once", "Be cruel to animals", "Use a slingshot"]),
            ("Let the cat out of the bag", "Reveal a secret", ["Free a pet", "Reveal a secret", "Make a mess", "Go shopping"])
        ]
        
        for (idiom, meaning, options) in idioms {
            let correctIndex = options.firstIndex(of: meaning) ?? 0
            
            for variation in 1...8 {
                let challenge = StoryElement.Challenge(
                    type: .vocabulary,
                    question: "What does the idiom '\(idiom)' mean?",
                    options: options,
                    correctAnswerIndex: correctIndex,
                    difficulty: variation <= 3 ? .easy : (variation <= 6 ? .medium : .hard)
                )
                
                let choices = [
                    StoryElement.Choice(
                        text: "Think figuratively",
                        nextStoryId: nil,
                        challenge: challenge,
                        consequence: nil
                    ),
                    StoryElement.Choice(
                        text: "Take it literally",
                        nextStoryId: nil,
                        challenge: challenge,
                        consequence: StoryElement.Consequence(type: .injury, description: "Literal thinking missed the figurative meaning!")
                    )
                ]
                
                stories.append(StoryElement(
                    title: "Idiom Island: \(idiom) \(variation)",
                    description: "Navigate the mysterious realm where words mean more than they seem. Understanding idioms is key to cultural fluency.",
                    choices: choices,
                    requiredSkillLevel: variation,
                    xpReward: 85 + variation * 5
                ))
            }
        }
        
        return stories
    }
    
    // MARK: - Pronunciation Stories (70 stories)
    func generatePronunciationStories() -> [StoryElement] {
        var stories: [StoryElement] = []
        
        let pronunciationChallenges = [
            ("Thorough", "Which is correct?", ["/θʌroʊ/", "/θɜroʊ/", "/θoroʊ/", "/θʊroʊ/"], 1),
            ("Colonel", "How is it pronounced?", ["/kolənel/", "/kɜrnəl/", "/kolonel/", "/kolɒnəl/"], 1),
            ("Archipelago", "Stress pattern:", ["ar-chi-PEL-a-go", "AR-chi-pel-a-go", "ar-CHI-pel-a-go", "ar-chi-pel-A-go"], 0),
            ("Worcestershire", "Pronunciation:", ["/wʊstərʃər/", "/wɔrsestərʃaɪər/", "/wɜrsɪstərʃər/", "/wɔrtsɪstərʃaɪər/"], 0),
            ("Epitome", "How to say it:", ["/epɪtoʊm/", "/ɪpɪtəmi/", "/epɪtəmi/", "/epɪtoʊmi/"], 1)
        ]
        
        for (word, question, options, correctIndex) in pronunciationChallenges {
            for level in 1...14 {
                let challenge = StoryElement.Challenge(
                    type: .listening,
                    question: "Pronunciation of '\(word)': \(question)",
                    options: options,
                    correctAnswerIndex: correctIndex,
                    difficulty: level <= 5 ? .easy : (level <= 10 ? .medium : .hard)
                )
                
                let choices = [
                    StoryElement.Choice(
                        text: "Listen carefully",
                        nextStoryId: nil,
                        challenge: challenge,
                        consequence: nil
                    ),
                    StoryElement.Choice(
                        text: "Sound it out",
                        nextStoryId: nil,
                        challenge: challenge,
                        consequence: StoryElement.Consequence(type: .neutral, description: "Phonetic thinking helped!")
                    )
                ]
                
                stories.append(StoryElement(
                    title: "Pronunciation Portal: \(word) \(level)",
                    description: "The guardians of spoken English test your ability to master the sounds that unlock clear communication.",
                    choices: choices,
                    requiredSkillLevel: level,
                    xpReward: 90 + level * 4
                ))
            }
        }
        
        return stories
    }
}
