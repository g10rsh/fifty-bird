PlayState = Class{__includes = BaseState}

PIPE_SPEED = 60
PIPE_HEIGHT = 288
PIPE_WIDTH=70

BIRD_WIDTH=38
BIRD_HEIGHT=24

function PlayState:init()
  self.bird=Bird()
  self.pipepairs = {}
  self.timer=0

  self.lastY=-PIPE_HEIGHT-math.random(80)+20
end

function PlayState:update(dt)
  self.timer=self.timer+dt
  if self.timer>2 then
    local y = math.max(-PIPE_HEIGHT+10,math.min(self.lastY+math.random(-20, 20),VIRTUAL_HEIGHT-90-PIPE_HEIGHT))
    self.lastY=y
    table.insert(self.pipepairs,PipePair(y))
    self.timer=self.timer%2
  end

  self.bird:update(dt)

  for k,pair in pairs(self.pipepairs) do
    pair:update(dt)

    for l, pipe in pairs(pair.pipes) do
      if self.bird:collides(pipe) then
        gStateMachine:change('title')
      end
    end

    if pair.remove then
      table.remove(pipepairs,k)
    end
  end

  if self.bird.y>VIRTUAL_HEIGHT-15 then
    gStateMachine:change('title')
  end
end

function PlayState:render()
  for k,pair in pairs(self.pipepairs) do
    pair:render()
  end

  self.bird:render()
end
