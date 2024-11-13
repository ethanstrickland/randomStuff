-- Tree Farm Program for ComputerCraft Turtle

-- Define area size (width and length of the farm)
local width = 6
local length = 6

-- Define slot indexes for saplings, fuel, and axe
local saplingSlot = 1
local fuelSlot = 2
local axeSlot = 3 -- Define the slot dedicated to the axe

-- Function to check and refuel the turtle
function refuel()
    turtle.select(fuelSlot)
    if turtle.getFuelLevel() < 50 then
        turtle.refuel(1)
    end
end

-- Function to plant a sapling
function plantSapling()
    turtle.select(saplingSlot)
    turtle.placeDown()
end

-- Function to chop down the tree
function chopTree()
    while turtle.detectUp() do
        turtle.digUp()
        turtle.up()
    end

    -- Descend back down
    while not turtle.detectDown() do
        turtle.down()
    end
end

-- Function to mine the full tree (all logs)
function mineTree()
    -- Mine upwards from the current position until no more logs are detected
    while turtle.detectUp() do
        local success, block = turtle.inspectUp()
        if success and (block.name == "minecraft:log" or block.name == "minecraft:log2") then
            turtle.digUp()
            turtle.up()
        else
            break
        end
    end
    
    -- Descend back down after mining logs
    while not turtle.detectDown() do
        turtle.down()
    end
end

-- Function to move forward while checking for trees and leaves
function moveForwardWithLeafCheck()
    local success, block = turtle.inspect()  -- Inspect the block in front of the turtle

    if success then
        -- If the block is a tree (log), mine the entire tree
        if block.name == "minecraft:log" or block.name == "minecraft:log2" then
            print("Tree detected, mining entire tree...")
            mineTree()  -- Mine the full tree (logs)
        -- If the block is a leaf, break it
        elseif block.name == "minecraft:leaves" or block.name == "minecraft:leaves2" then
            print("Leaf detected, breaking leaf...")
            turtle.dig()  -- Break the leaf
        end
    end

    -- Move forward after checking the block
    turtle.forward()
end

-- Function to move to the next row
function nextRow(direction)
    if direction % 2 == 0 then
        turtle.turnRight()
        turtle.forward()
        turtle.turnRight()
    else
        turtle.turnLeft()
        turtle.forward()
        turtle.turnLeft()
    end
end

-- Function to return the turtle to the starting position
function returnToStart()
    print("Returning to starting position...")

    turtle.forward()

    -- Turn to move back along the length of the farm (6 rows)
    turtle.turnRight()
    for j = 1, length - 1 do
        turtle.forward()
    end

    -- Turn to face the original direction
    turtle.turnRight()
end

-- Function to deposit items into the chest (below starting point)
function depositItems()
    print("Depositing items into chest...")

    for slot = 1, 16 do
        if slot ~= saplingSlot and slot ~= fuelSlot and slot ~= axeSlot then
            turtle.select(slot)
            local item = turtle.getItemDetail()
            if item then
                -- Check if it's saplings, skip if we have 1 stack already
                if item.name == "minecraft:sapling" then
                    if turtle.getItemCount(saplingSlot) >= 64 then
                        turtle.dropDown()
                    end
                else
                    -- Dump everything else except axe
                    turtle.dropDown()
                end
            end
        end
    end
end

-- Main loop to manage the tree farm
function treeFarmLoop()
    local direction = 0
    while true do
        refuel()

        -- Start at (1, 1) instead of (0, 0)
        moveForwardWithLeafCheck()

        for i = 1, width do
            for j = 1, length - 1 do
                moveForwardWithLeafCheck()
            end
            if i < width then
                nextRow(direction)
                direction = direction + 1
            end
        end

        -- Return to starting point
        returnToStart()

        -- Dump items in chest after returning to starting point
        depositItems()

        -- Move back to starting position
        turtle.back() 

        -- Wait for trees to grow
        print("Waiting for trees to grow...")
        os.sleep(300) -- Wait for 5 minutes before checking again
    end
end

-- Start the tree farm loop
treeFarmLoop()