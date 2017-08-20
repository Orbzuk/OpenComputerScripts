local robot = require("robot")

------Global Vars------
treeGridX = 3
treeGridY = 6
treeGridDistance = 2

invPosSapling = 16
invPosCompare = 15
invPosFuel = 14


------Helper Methods------
function fwd ()
  while robot.forward() == nil do
    robot.swing()
  end
end

function bck ()
  if robot.back() == nil then
    robot.turnArounnd()
    robot.swing()
	
    while robot.forward() == nil do
      robot.swing()
    end
	robot.turnAround()
  end
end

function up ()
  while robot.up() == nil do
    robot.swingUp()
  end
end

function dwn ()
  while robot.down() == nil do
    robot.swingDown()
  end
end



function NextTree ()
  print("Debug: NextTree() activated.")
  for i = 1, treeGridDistance - 1, 1 do
    fwd()
  end
end

--Fells a tree, digging up until comparison block is detected. then replants and move infront of the tree.
function ChopTree ()
  print("Debug: ChopTree() activated.")
  robot.swing()
  robot.forward()
  robot.swingDown()
  robot.select(invPosSapling)
  robot.placeDown()
  robot.select(invPosCompare)
  
  --Digs up until comparison block is true
  while robot.compareUp() == false do
    robot.swingUp()
    up()
  end
  
  --Moves down to 1 block above sapling 
  b = true
  repeat b = robot.down()
  until (b == nil)
  
  fwd()
end

--When a sapling is detected, robot 'steps over' sapling to reposition on other side
function StepOver ()
  print("Debug: StepOver() activated.")
  fwd()
  bDet, sDet = robot.detectDown()
  if sDet == "air" then
    robot.select(invPosSapling)
	robot.placeDown()
  end
  fwd()
end

--Return to Star
function Return ()
  --If on an odd line, travel sideways then down
    --Otherwise just travel sideways
end

print("Debug: Core loop began.")

--Core loop
while true do
  locX = 1
  while locX <= treeGridX do
    locY = 1
	
	
	while locY <= treeGridY do
	  detBool, detString = robot.detect()
	  if detString == "solid" then
		ChopTree()
	  else
		StepOver()
	  end
	  
	  NextTree()
	  
	  locY = locY + 1
	end
	
	
	print("One")
	--After column is complete, move to next
	if locX % 2 == 1 then --turn right
	  print("Two")
	  robot.turnRight()
	  print("Three")
	  for i = 0, treeGridDistance, 1 do
	    fwd()
	  end
	  print("Four")
	  robot.turnRight()
	  print("Five")
	else --turn left
	  print("Six")
	  robot.turnLeft()
	  print("Seven")
	  for i = 0, treeGridDistance, 1 do
	    fwd()
	  end
	  robot.turnLeft()
	end
	
	locX = locX + 1
	NextTree()
	
  end
  --return to start
  --deposit items
  --os.sleep(1800)
end