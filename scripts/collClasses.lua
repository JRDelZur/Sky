function chargeClasses()
	world:addCollisionClass('Terrain')--terreno
    world:addCollisionClass('Player', {ignores = {'Player'}}) --player
	world:addCollisionClass('PDown', {ignores = {'Player', 'Terrain'}})--checkdown
    world:addCollisionClass('Bullet', {ignores = {'Player', 'Terrain', 'PDown', 'Bullet'}})
    world:addCollisionClass('Object', {ignores = {'PDown'}})
    world:addCollisionClass('Zombie', {ignores = {'PDown', 'Bullet'}})
    world:addCollisionClass('ZombieCheck', {ignores = {'PDown', 'Bullet', 'Player', 'Terrain', 'Object', 'Zombie'}})
end