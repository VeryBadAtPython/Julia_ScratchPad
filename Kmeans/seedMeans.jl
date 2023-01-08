using LinearAlgebra
using Statistics

#= Randomly generates initial means from randomly chosen datapoints =#
function randomMeans(rowIndexedData :: Array, K :: Int)
    (points, attributes) = size(rowIndexedData)
    randomIndexes = zeros(K)
    randomIndexes = map( x -> rand(1:points), randomIndexes)
    randoms = zeros(K,attributes)

    for i ∈ 1:K
        randoms[i,:] = rowIndexedData[randomIndexes[i], :]
    end
    return(randoms)
end




function kpMeans(rowIndexedData :: Array, K :: Int)
    (points, attributes)  = size(rowIndexedData)
    means = rowIndexedData[rand(1:points), 1:attributes] |> transpose |> Array

    while size(means)[1] < K
        means = addNextRoid(rowIndexedData,means)
    end

    return(means)
end


function addNextRoid(rowIndexedData :: Array, currentCentroids :: Array)
    (points, attributes)  = size(rowIndexedData)
    minDists = []
    for i ∈ 1:points
        mnDst = minDist(transpose(rowIndexedData[i,:]),currentCentroids)
        append!(minDists, mnDst )
    end
    
    depth   = findmax(minDists)[2]
    newRoid = rowIndexedData[depth,:]

    return(vcat(currentCentroids,transpose(newRoid)))
end


function minDist(row, currentCentroids :: Array)
    dists = []
    roids = copy(currentCentroids)
    for i ∈ 1:size(roids)[1]
        roids[i,:] -= transpose(row)
        append!(dists, norm(roids[i,:]))
    end
    return(minimum(dists))
end