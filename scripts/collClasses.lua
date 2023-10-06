function chargeClasses()
	world:addCollisionClass('Terrain')--terreno barrera

    world:addCollisionClass('Player', {ignores = {'Player'}}) --player
	world:addCollisionClass('PDown', {ignores = {'Player', 'Terrain'}})--checkdown
    world:addCollisionClass('Bullet1', {ignores = {'Player', 'Terrain', 'PDown', 'Bullet1'}})
    world:addCollisionClass('Object', {ignores = {'PDown'}})
    world:addCollisionClass('Zombie', {ignores = {'PDown', 'Bullet1', 'Object'}})
    world:addCollisionClass('ZombieCheck', {ignores = {'PDown', 'ZombieCheck', 'Bullet1', 'Player', 'Terrain', 'Object', 'Zombie'}})
    world:addCollisionClass('Danger1R', {ignores = {'PDown', 'ZombieCheck', 'Bullet1', 'Player', 'Danger1R', 'Terrain', 'Object', 'Zombie'}})
    world:addCollisionClass('Danger1L', {ignores = {'PDown', 'ZombieCheck', 'Bullet1', 'Player', 'Danger1L', 'Danger1R', 'Terrain', 'Object', 'Zombie'}})
    world:addCollisionClass('SDanger1R', {ignores = {'PDown', 'ZombieCheck', 'Bullet1', 'Player', 'Danger1R', 'Object', 'Zombie'}})
    world:addCollisionClass('SDanger1L', {ignores = {'PDown', 'ZombieCheck', 'Bullet1', 'Player', 'Danger1L', 'Danger1R', 'Object', 'Zombie'}})
end