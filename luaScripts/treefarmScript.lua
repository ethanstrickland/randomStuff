-- Tree Farm Program for ComputerCraft Turtle

-- Define area size (width and length of the farm)
local width = 6
local length = 6

-- Define slot indexes for saplings and fuel
local saplingSlot = 1
local fuelSlot = 2
local chestSlot = 16 -- Slot to store collected items temporarily before dumping

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

-- Function to harvest a single spot
function checkSpot()
    if turtle.detect() then
        chopTree()
    end
    plantSapling()
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

-- Function to deposit items into a chest (except fuel, saplings, and axe)
function depositItems()
    print("Depositing items into chest...")

    for slot = 1, 16 do
        if slot ~= saplingSlot and slot ~= fuelSlot then
            turtle.select(slot)
            local item = turtle.getItemDetail()
            if item then
                -- Check if it's saplings, skip if we have 1 stack already
                if item.name == "minecraft:sapling" then
                    -- Move extra saplings to the chest
                    if turtle.getItemCount(saplingSlot) >= 64 then
                        turtle.dropDown()
                    end
                else
                    -- Dump everything else
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
        for i = 1, width do
            for j = 1, length - 1 do
                checkSpot()
                turtle.forward()
            end
            checkSpot()
            if i < width then
                nextRow(direction)
                direction = direction + 1
            end
        end
        -- Return to starting point
        if width % 2 == 1 then
            turtle.turnRight()
        else
            turtle.turnLeft()
        end
        for k = 1, width - 1 do
            turtle.forward()
        end
        turtle.turnRight()
        for l = 1, length - 1 do
            turtle.forward()
        end
        turtle.turnRight()
        
        -- Dump items in chest after a cycle
        depositItems()
        
        -- Wait for trees to grow
        print("Waiting for trees to grow...")
        os.sleep(300) -- Wait for 5 minutes before checking again
    end
end

-- Start the tree farm loop
treeFarmLoop()