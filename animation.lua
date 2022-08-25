PASTEBIN
API
TOOLS
FAQ
paste
LOGIN SIGN UP
SHARE
TWEET
Gamecodeur
 Untitled
GAMECODEUR
AUG 24TH, 2022
4
NEVER
Not a member of Pastebin yet? Sign Up, it unlocks many cool features!
 0.76 KB | None
      
-- title:   game title
-- author:  game developer, email, etc.
-- desc:    short description
-- site:    website link
-- license: MIT License (change this to your license of choice)
-- version: 0.1
-- script:  lua
 
lstExplosion={}
 
function boum(px,py)
    local ex={}
    ex.x=px
    ex.y=py
    ex.frame=1
    table.insert(lstExplosion,ex)
end
 
timer=math.random(20)
 
function TIC()
 
    cls(0)
    
    timer=timer-1
    if timer<=0 then
        boum(math.random(0,340),math.random(0,136))
        timer=math.random(20)
    end
    
    for e=#lstExplosion,1,-1 do
        local expl=lstExplosion[e]
        expl.frame=expl.frame+0.2
        if expl.frame>5+1 then
            table.remove(lstExplosion,e)
        else
            spr(math.floor(expl.frame),expl.x, expl.y)
        end
    end
    
    print(#lstExplosion,1,1,11)
    
end
 
RAW Paste Data 
-- title:   game title
-- author:  game developer, email, etc.
-- desc:    short description
-- site:    website link
-- license: MIT License (change this to your license of choice)
-- version: 0.1
-- script:  lua

lstExplosion={}

function boum(px,py)
	local ex={}
	ex.x=px
	ex.y=py
	ex.frame=1
	table.insert(lstExplosion,ex)
end

timer=math.random(20)

function TIC()

	cls(0)
	
	timer=timer-1
	if timer<=0 then
		boum(math.random(0,340),math.random(0,136))
		timer=math.random(20)
	end
	
	for e=#lstExplosion,1,-1 do
		local expl=lstExplosion[e]
		expl.frame=expl.frame+0.2
		if expl.frame>5+1 then
			table.remove(lstExplosion,e)
		else
			spr(math.floor(expl.frame),expl.x, expl.y)
		end
	end
	
	print(#lstExplosion,1,1,11)
	
end

Public Pastes
Spid_rr's Data
JSON | 2 min ago | 11.80 KB
Ailaai (Remix) Ailaai (Remix) - Pank | Hoat...
HTML 5 | 4 min ago | 1.79 KB
CSS Audio bars animation
HTML | 23 min ago | 3.30 KB
How To Create a User Profile Card Using HTML...
HTML | 26 min ago | 3.36 KB
Object-oriented programming applied to audio...
HTML | 29 min ago | 3.36 KB
Untitled
PHP | 39 min ago | 0.02 KB
Number to Roman Numerals & Reverse
Python | 51 min ago | 0.77 KB
Arduino joystick e 3 servos
C++ | 58 min ago | 1.88 KB
create new paste  /  syntax languages  /  archive  /  faq  /  tools  /  night mode  /  api  /  scraping api  /  news  /  pro
privacy statement  /  cookies policy  /  terms of serviceupdated  /  security disclosure  /  dmca  /  report abuse  /  contact

By using Pastebin.com you agree to our cookies policy to enhance your experience.
Site design & logo © 2022 Pastebin
We use cookies for various purposes including analytics. By continuing to use Pastebin, you agree to our use of cookies as described in the Cookies Policy.  OK, I Understand
Not a member of Pastebin yet?
Sign Up, it unlocks many cool features! 