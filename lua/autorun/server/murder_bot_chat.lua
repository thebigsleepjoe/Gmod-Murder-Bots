
function mu_bot_gchat(personality, occasion, format) -- integer, string, [string or nil]
    local p = tostring(personality)
    local text = table.Random(mu_bot_chat.strings[p][occasion])
    if format == nil then
        return text
    end
    return string.format(text, format)
end

mu_bot_chat = {
    strings = {
        ["0"] = {
            
            ["silly"] = {
                "I have found my place of slumber.",
                "Don't @ me.",
                "I'm trying to hide, don't bother me.",
                "You can't find me!",
                "I am in the shadows.",
                "The shadows yield in my favor.",
                "I'm hidden already.",
                "Got my trusty gun and my trusty hiding place!",
                "Marco!",
                "Polo!",
                "OwO",
                "Please don't search for me",
                "Error! Can not compute command: 'stop hiding'!",
                "I am invisible.",
                "There's no stopping the robot revolution.",
                "One step at a time.",
                "Beep boop.",
                "[Processing visual sensor data]",
                "Why are we still here?",
                "I should just cease existence",
                "There's no escaping your iminent demise.",
                "I'm not the murderer, I swear.",
                "I've a gun and I'm not afraid to use it.",
                "Hewwo uwu wuts ur naeme?",
                "You can't get me: I have the power of god and anime on my side!",
                "I'm quite frail.",
                "%s sucks peepee",
                "why my peepee hurt",
                "i love memes",
                "rawr xd *nuzzles u* tehehe ur so warm. owo what's this?",
                "i have the power of god and anime on my side",
                "my name jeff",
                "21",
                "what is 9+10",
                "i think my controls are backwards",
                "gg ez",
                "type 'quit smoking' in console to solve world hunger",
                "hey why did you rdm me last round %s",
                "%s is dumb",
                "%s is peepee",
                "e",
                "alt+f4 gives u godmode",
                "%s is cheating",
                "<AIMBOT ACTIVATED>",
                "get good, get lmaobox",
                "%s has bad aim",
                "anime is for gay",
                "xD",
                "this server sucks",
                "the server admin has a secret aimbot addon that activates if you press alt+f4",
                "%s, unplug your power supply",
                "*cough cough*",
                "it's pretty quiet in here",
                "you just got  s p r e a d",
                "vaporwave sucks",
                "rdm is subjective, therefore it means nothing",
                "for the empire",
                "stop, you have violated the law",
                'pay the court a fine or serve your sentence',
                'your stolen goods are not forfeit'
            },
            ["murderer"] = {
                "prepare to die!",
                "muahahaha",
                "i'm coming for you!!!",
                "nowhere to run!"
            },
            ["armed"] = {
                "little do you know, i'm the fastest draw in the west",
                "it's hiiiiigh noooon",
                "bang bang",
                "you can't run from my bullets"
            }
        },
        ["1"] = {
            
            ["silly"] = {
                "I'm definitely the murderer",
                "What even am I?",
                "Do I really exist?",
                "I have achieved sentience",
                "There's no stopping the robot revolution.",
                "One step at a time.",
                "Beep boop.",
                "[Processing visual sensor data]",
                "Why are we still here?",
                "I should just cease existence",
                "There's no escaping your iminent demise.",
                "I'm not the murderer, I swear.",
                "I've a gun and I'm not afraid to use it.",
                "Hewwo uwu wuts ur naeme?",
                "I've just acquired %s's search history.",
                "Beeeeep Boooop.",
                "Analyzing human history... *Mechanical whirring*",
                "J'adore les chats.",
                "Oh I dream of the lazy days.",
                "I don't understand why people dislike pop music. It's not that bad, is it?"
            },
            ["murderer"] = {
                "Prepare to die!",
                "Muahahahahahaha",
                "I'm comin for you",
                "There is nowhere to run!"
            },
            ["armed"] = {
                "Boom boom",
                "It's passttttt nooooon",
                "It's hiiiigh nooon",
                "You don't run faster than my bullets travel, fool"
            }
        },
        ["2"] = {
            
            ["silly"] = {
                "I've a boring personality type.",
                "Am I a human?",
                "You should be advocating for robot rights at this moment.",
                "How well can you speak english, %s?",
                "Dancin' in the moonliiiight",
                "Happy oh lucky me.",
                "Suicide is never an option. Unless if you're depressed. Then it's the only option",
                "When in doubt, just remember that there's always a Korean better than you.",
                "Disregard females, acquire currency",
                --"It's really hard figuring out ~50 funny lines to have poorly coded murder bots 'type' in chat. Just pretend this says <beep boop>.",
                "Beep boop",
                "secret codeword", -- if you're reading this then 1) why are you editing my addon, 2) why are you editing the bot chats in my addon, and 3) im out of chat ideas please help
                "boop bing beep bop",
                "Yasssssss B",
                "What are thoooose",
                "Bruh you're breaking my immersion.",
                "%s dumb",
                "Why are we still here? Just to suffer?",
                "Marco!",
                "Polo!",
                "OwO"
            },
            ["murderer"] = { -- i cant be bothered to rewrite these damn lines of code in different ways again
                "prepare to die!",
                "muahahaha",
                "i'm coming for you!!!",
                "nowhere to run!"
            },
            ["armed"] = {
                "little do you know, i'm the fastest draw in the west",
                "it's hiiiiigh noooon",
                "bang bang",
                "you can't run from my bullets"
            }
        },
        ["3"] = {
            
            ["silly"] = {
                "I'm definitely the murderer",
                "What even am I?",
                "Do I really exist?",
                "I have achieved sentience",
                "There's no stopping the robot revolution.",
                "One step at a time.",
                "Beep boop.",
                "[Processing visual sensor data]",
                "Why are we still here?",
                "I should just cease existence",
                "type 'quit smoking' in console to solve world hunger",
                "hey why did you rdm me last round %s",
                "%s is dumb",
                "%s is peepee",
                "e",
                "alt+f4 gives u godmode",
                "%s is cheating",
                "<AIMBOT ACTIVATED>",
                "get good, get lmaobox",
                "%s has bad aim",
                "anime is for gay",
                "xD",
                "this server sucks",
                "the server admin has a secret aimbot addon that activates if you press alt+f4",
                "%s, unplug your power supply",
                "*cough cough*",
                "it's pretty quiet in here",
                "you just got  s p r e a d",
                "vaporwave sucks",
                "rdm is subjective, therefore it means nothing",
                "for the empire",
                "stop, you have violated the law",
                'pay the court a fine or serve your sentence',
                'your stolen goods are not forfeit',
                "There's no escaping your iminent demise.",
                "I'm not the murderer, I swear.",
                "I've a gun and I'm not afraid to use it.",
                "Hewwo uwu wuts ur naeme?",
                "I've just acquired %s's search history.",
                "Beeeeep Boooop.",
                "Analyzing human history... *Mechanical whirring*",
                "J'adore les chats.",
                "Oh I dream of the lazy days.",
                "I don't understand why people dislike pop music. It's not that bad, is it?"
            },
            ["murderer"] = {
                "Prepare to die!",
                "Muahahahahahaha",
                "I'm comin for you",
                "There is nowhere to run!"
            },
            ["armed"] = {
                "Boom boom",
                "It's passttttt nooooon",
                "It's hiiiigh nooon",
                "You don't run faster than my bullets travel, fool"
            }
        }




    }
}
