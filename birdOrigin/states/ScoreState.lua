ScoreState=Class{__includes=BaseState}

function ScoreState:enter(params)
  self.score =params.score
end

function ScoreState:update(dt)
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    gStateMachine:change('play')
  end
end

function ScoreState:render()
  love.graphics.setFont(flappyFont)
  love.graphics.printf('YOU LOSE', 0,64,VIRTUAL_WIDTH,'center')

  love.graphics.setFont(mediumFont)
  love.graphics.printf('SCORE: ' .. tostring(self.score),0,100,VIRTUAL_WIDTH,'center')

  love.graphics.printf('Hit Enter to play again', 0,160,VIRTUAL_WIDTH,'center')
end
