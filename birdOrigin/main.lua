push = require 'push'
Class = require 'class'
require 'Bird'
require 'Pipe'
require 'PipePair'

require 'StateMachine'
require 'states/BaseState'
require 'states/PlayState'
require 'states/ScoreState'
require 'states/CountDownState'
require 'states/TitleScreenState'


WINDOW_WIDTH=1280
WINDOW_HEIGHT=720
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT=288
local pause=false

local background = love.graphics.newImage("background.png")
local backgroundScroll =0
local BACKGROUND_SCROLL_SPEED=30
local BACKGROUND_LOOPING_POINT=413

local ground = love.graphics.newImage("ground.png")
local groundScroll=0
local GROUND_SCROLL_SPEED=60
local GROUND_LOOPING_POINT= VIRTUAL_WIDTH

function love.load()
  love.graphics.setDefaultFilter('nearest','nearest')

  love.window.setTitle('Dummy Bird')

  --initialize fonts
  smallFont = love.graphics.newFont('font.ttf',8)
  mediumFont = love.graphics.newFont('flappy.ttf',14)
  flappyFont = love.graphics.newFont('flappy.ttf',28)
  hugeFont = love.graphics.newFont('flappy.ttf',56)
  love.graphics.setFont(flappyFont)

  push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT,WINDOW_WIDTH,WINDOW_HEIGHT,{
    vsync=true,fullscreen=false,resizable=true
  })

  gStateMachine = StateMachine{
    ['title'] = function() return TitleScreenState() end,
    ['play'] = function() return PlayState() end,
    ['score'] = function() return ScoreState() end,
    ['countdown'] = function() return CountDownState() end,
  }

  gStateMachine:change('title')

  love.keyboard.keysPressed={}
  math.randomseed(os.time())
end

function love.resize(w,h)
  push:resize(w,h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
    if key == 'escape' then
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
  return love.keyboard.keysPressed[key]
end

function love.update(dt)
  if not pause then
    backgroundScroll=(backgroundScroll+BACKGROUND_SCROLL_SPEED*dt)%BACKGROUND_LOOPING_POINT
    groundScroll=(groundScroll+GROUND_SCROLL_SPEED*dt)%GROUND_LOOPING_POINT

    gStateMachine:update(dt)
  end
  if love.keyboard.wasPressed('p')then
    pause=not pause
  end
  love.keyboard.keysPressed={}
end

function love.draw()
  push:start()
  love.graphics.draw(background,-backgroundScroll,0)
  gStateMachine:render()
  love.graphics.draw(ground, -groundScroll,VIRTUAL_HEIGHT-16)
  if pause then
    love.graphics.setFont(flappyFont)
    love.graphics.printf('PAUSED', 0, 64, VIRTUAL_WIDTH, 'center')
  end
  push:finish()
end
