-- these comments are outdated AF but y'know i'll keep them here anyway

--[[
    profile generation javascript script; botnames is an array that must be defined
var st = "";
for (var i = 0; i < 122; i++ ) {
    var x = botnames[i];
    st = st + "{name = "+x+", accuracy = "+Math.round(10+Math.random()*10)/20+", personality = "+Math.round(Math.random()*3)+"},\n";
}
console.log(st);

---------------------------

Personalities:
    { -- 0, nbghserd
        hide=true,
        groups=false,
        mean=true
    },
    { -- 1, mean teamer
        hide=false,
        groups=true,
        mean=true
    },
    { -- 2, semi nbghserd
        hide=false,
        groups=false,
        mean=false
    },
    { -- 3, team player
        hide=false,
        groups=true,
        mean=false
    }

]]

bot_profiles_murder = {
    {name = "Nibbs", accuracy = 1, personality = 1},
    {name = "Weapons are useless", accuracy = 0.85, personality = 2},
    {name = "Jimbo Slice", accuracy = 0.75, personality = 1},
    {name = "Pinkie Trouble", accuracy = 0.8, personality = 1},
    {name = "Mildly Menacing Flower Pot", accuracy = 0.95, personality = 0 --[[ changed from 1]]},
    {name = "Charles Nuttington", accuracy = 0.7, personality = 1},
    {name = "John Zanus", accuracy = 0.95, personality = 1},
    {name = "I'm still alive", accuracy = 1, personality = 1},
    {name = "murderer", accuracy = 0.65, personality = 1},
    {name = "loser", accuracy = 0.8, personality = 1},
    {name = "Nobody", accuracy = 0.55, personality = 2},
    {name = "Beep Boop", accuracy = 0.8, personality = 0 --[[ changed from 1]]},
    {name = "Maggot", accuracy = 0.8, personality = 2},
    {name = "Starcraft", accuracy = 0.6, personality = 1},
    {name = "real nbghserd", accuracy = 0.85, personality = 3},
    {name = "my friend", accuracy = 0.5, personality = 3},
    {name = "Akill7600", accuracy = 0.75, personality = 3},
    {name = "Head Full of Eyeballs", accuracy = 0.9, personality = 1},
    {name = "Hoovy", accuracy = 0.6, personality = 3},
    {name = "Sandvich", accuracy = 0.7, personality = 3},
    {name = "Little Tiny Baby Man", accuracy = 0.65, personality = 1},
    {name = "Babies", accuracy = 0.85, personality = 0 --[[ changed from 1]]},
    {name = "Entire Team", accuracy = 0.95, personality = 1},
    {name = "Totally Not a Bot", accuracy = 0.6, personality = 2},
    {name = "Sausage", accuracy = 0.95, personality = 3},
    {name = "Sandstone", accuracy = 0.85, personality = 1},
    {name = "Sonic Fan", accuracy = 0.55, personality = 3},
    {name = "Headache", accuracy = 0.6, personality = 2},
    {name = "mr spielburg", accuracy = 0.6, personality = 1},
    {name = "god", accuracy = 0.9, personality = 0 --[[ changed from 1]]},
    {name = "Flashing Deadeye", accuracy = 0.85, personality = 1},
    {name = "Shadowysn", accuracy = 0.95, personality = 1},
    {name = "channel four", accuracy = 0.7, personality = 3},
    {name = "1v1 me m8", accuracy = 0.95, personality = 0 --[[ changed from 1]]},
    {name = "Dweeb Power", accuracy = 0.55, personality = 3},
    {name = "Mr. Rusty booty", accuracy = 0.9, personality = 0 --[[ changed from 1]]},
    {name = "Noxious Tank", accuracy = 0.85, personality = 1},
    {name = "Ewitt69", accuracy = 0.9, personality = 1},
    {name = "Hike Munt", accuracy = 0.7, personality = 0 --[[ changed from 1]]},
    {name = "Dame Fiery", accuracy = 0.65, personality = 1},
    {name = "Miyah Sesbig", accuracy = 0.75, personality = 2},
    {name = "Mike Hunt", accuracy = 0.55, personality = 2},
    {name = "The Trashman", accuracy = 0.95, personality = 2},
    {name = "Dinglebop", accuracy = 0.75, personality = 2},
    {name = "Shrek", accuracy = 0.95, personality = 1},
    {name = "Unstable Finger", accuracy = 0.55, personality = 0 --[[ changed from 1]]},
    {name = "Small baby head", accuracy = 0.95, personality = 1},
    {name = "Thicc boi", accuracy = 0.55, personality = 2},
    {name = "booty Robber", accuracy = 0.95, personality = 2},
    {name = "He", accuracy = 0.9, personality = 1},
    {name = "that dude", accuracy = 0.85, personality = 2},
    {name = "no one", accuracy = 0.75, personality = 3},
    {name = "myself", accuracy = 1, personality = 1},
    {name = "mean dood", accuracy = 0.9, personality = 2},
    {name = "derriere smasher", accuracy = 0.55, personality = 2},
    {name = "derriere pummeler", accuracy = 0.6, personality = 3},
    {name = "The Exodus", accuracy = 0.65, personality = 1},
    {name = "Biglong Shlongdong", accuracy = 0.6, personality = 0 --[[ changed from 1]]},
    {name = "REEEEEeee", accuracy = 0.7, personality = 2},
    {name = "Nate", accuracy = 0.8, personality = 1},
    {name = "LoLzL3GIT", accuracy = 0.55, personality = 2},
    {name = "Nicobot 6000", accuracy = 0.75, personality = 2},
    {name = "Le Fuher Potato", accuracy = 0.9, personality = 2},
    {name = "S.S. Potato", accuracy = 0.8, personality = 3},
    {name = "Maxtron 5000", accuracy = 0.65, personality = 3},
    {name = "Webber", accuracy = 1, personality = 0 --[[ changed from 1]]},
    {name = "Wilson", accuracy = 0.9, personality = 2},
    {name = "Willow", accuracy = 0.7, personality = 1},
    {name = "your mom", accuracy = 0.55, personality = 0 --[[ changed from 1]]},
    {name = "bigbootygirl420", accuracy = 0.55, personality = 0 --[[ changed from 1]]},
    {name = "Garbage Day", accuracy = 0.95, personality = 3},
    {name = "Defuser", accuracy = 0.95, personality = 1},
    {name = "a dead dude", accuracy = 0.8, personality = 2},
    {name = "I'm not a nerd", accuracy = 0.7, personality = 3},
    {name = "I am a nerd", accuracy = 0.65, personality = 1},
    {name = "Bingle Deblooper", accuracy = 0.7, personality = 2},
    {name = "CRITRAWKETS", accuracy = 0.8, personality = 0 --[[ changed from 1]]},
    {name = "trashman is spy", accuracy = 0.75, personality = 1},
    {name = "Ben Dover", accuracy = 0.9, personality = 2},
    {name = "Mike Literus", accuracy = 0.9, personality = 3},
    {name = "Bringle Borp", accuracy = 0.7, personality = 3},
    {name = "Zingle Dorf", accuracy = 0.6, personality = 2},
    {name = "Bajingle Shmorf", accuracy = 0.8, personality = 1},
    {name = "Ringle Morph", accuracy = 0.65, personality = 1},
    {name = "Dinkleburg", accuracy = 0.8, personality = 2},
    {name = "Timmy T.", accuracy = 0.85, personality = 2},
    {name = "Turner", accuracy = 0.95, personality = 2},
    {name = "Cavebob Spongeman", accuracy = 0.7, personality = 2},
    {name = "Pomme", accuracy = 0.7, personality = 0 --[[ changed from 1]]},
    {name = "Terre", accuracy = 0.95, personality = 1},
    {name = "Vintage Sandvich", accuracy = 0.9, personality = 2},
    {name = "Pooty", accuracy = 0.7, personality = 0 --[[ changed from 1]]},
    {name = "ERROR 404", accuracy = 0.9, personality = 2},
    {name = "Сука Блядь", accuracy = 0.65, personality = 2},
    {name = "Michael De Santa", accuracy = 0.65, personality = 3},
    {name = "Potato", accuracy = 0.7, personality = 2},
    {name = "John Cena", accuracy = 0.95, personality = 0 --[[ changed from 1]]},
    {name = "CuteDogXD", accuracy = 0.95, personality = 0},
    {name = "RIOT", accuracy = 0.85, personality = 0},
    {name = "Chairdof Sitler", accuracy = 0.55, personality = 2},
    {name = "Daddy", accuracy = 0.55, personality = 3},
    {name = "Communist Manifesto", accuracy = 0.8, personality = 2},
    {name = "You", accuracy = 0.55, personality = 1},
    {name = "Yourself", accuracy = 0.95, personality = 2},
    {name = "Daddy", accuracy = 0.5, personality = 1},
    {name = "Pewdiepie", accuracy = 0.85, personality = 1},
    {name = "Therealpewdiepie4321", accuracy = 0.6, personality = 2},
    {name = "de_way", accuracy = 0.6, personality = 0},
    {name = "Dead Meme", accuracy = 0.65, personality = 0},
    {name = "Han Shot First", accuracy = 0.9, personality = 2},
    {name = "Broseph Stalin", accuracy = 0.95, personality = 1},
    {name = "Colonel Sanders", accuracy = 0.85, personality = 2},
    {name = "Big Smoke", accuracy = 0.8, personality = 2},
    {name = "Smig Boke", accuracy = 0.7, personality = 1},
    {name = "Mohammad", accuracy = 0.7, personality = 2},
    {name = "Literally Hitler", accuracy = 0.65, personality = 1},
    {name = "xXxminecraftkidxXx", accuracy = 0.55, personality = 1},
    {name = "Vladimir Pootis", accuracy = 0.55, personality = 2},
    {name = "Achmed", accuracy = 0.5, personality = 1},
    {name = "Medic", accuracy = 1, personality = 3},
    {name = "Doug Dimmadome", accuracy = 0.75, personality = 2},
    {name = "Dougsdale Dimmadome", accuracy = 0.65, personality = 1},
    {name = "Berlock Shmomes", accuracy = 0.7, personality = 1},
}