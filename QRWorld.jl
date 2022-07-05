using CairoMakie
using Random

# =======================
# ==== Test Patterns ====
# =======================
function initial1100()
    return(
        [
        1 0 1 0 1 1 1 0 1 1 1;
        1 0 1 0 1 0 1 0 1 0 1;
        1 0 1 0 1 0 1 0 1 0 1;
        1 0 1 0 1 1 1 0 1 1 1
        ]
    )
end

function initial1130()
    return(
        [
        1 0 1 0 1 1 1 0 1 1 1;
        1 0 1 0 0 0 1 0 1 0 1;
        1 0 1 0 1 1 1 0 1 0 1;
        1 0 1 0 0 0 1 0 1 0 1;
        1 0 1 0 1 1 1 0 1 1 1
        ]
    )
end

function diagonalGrid()
    return(
        [
        1 0 0 0 0 0 0 1 0 0 0;
        0 1 0 0 0 0 0 0 1 0 0;
        0 0 1 0 0 0 0 0 0 1 0;
        0 0 0 1 0 0 0 0 0 0 1;
        0 0 0 0 1 0 0 0 0 0 0
        ]
    )
end

function randomGrid(rows,cols)
    grid = zeros(rows,cols)
    for i in 1:1:rows
        for j in 1:1:cols
            grid[i,j] = rand((0,1))
        end
    end
    return(grid)
end






# =======================
# ==== Automata      ====
# =======================

#Gets a cell's value
function getVal(row,col,grid)
    (m,n) = size(grid)
    if (row <= 0) || (row > m) || (col <= 0) || (col > n)
        return(0)
    else
        return(grid[row,col])
    end
end

#Count alive direct neighbours
function countAlive(row,col,grid)
    return(
        getVal(row-1,col,grid)
        +getVal(row,col-1,grid)
        +getVal(row+1,col,grid)
        +getVal(row,col+1,grid)
    )
end

#Decide evolution of cell
function decideEvolve(row,col,grid)
    cell = getVal(row,col,grid)
    hood = countAlive(row,col,grid)

    if cell <= 0
        if (hood < 2) || (hood == 4)
            return(0)
        else
            return(1)
        end
    else
        if (hood == 2) || (hood == 4)
            return(1)
        else
            return(0)
        end
    end
end

#Evolve whole grid
function evolve(grid)
    (m,n) = size(grid)
    new   = zeros(m,n)
    for i in 1:1:m
        for j in 1:1:n
            new[i,j] = decideEvolve(i,j,grid)
        end
    end
    return(new)
end

#iterate evolution n times
function evolveNTimes(n,grid)
    if n<=0
        return(grid)
    else
        return(evolveNTimes(n-1, evolve(grid)))
    end
end


# =======================
# ==== Render Grid   ====
# =======================
function render(cells)
    data  = transpose(cells)
    (m,n) = size(data)

    f = Figure()

    Axis(f[1,1]).aspect = AxisAspect(m/n)  #Renders in equal aspect
    heatmap!(data) 

    return(f)
end

# Sample function call ==>> render(evolveNTimes(100,initial1130()))