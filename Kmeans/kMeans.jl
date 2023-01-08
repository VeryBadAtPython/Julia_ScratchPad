using LinearAlgebra
using Statistics



#= This function takes arrays of datapoints and centroids arranged in rows and 
    then returns a list of integers associating each datapoint with
    it's closest centroid=#
function associateNearestMeans(rowIndexedData :: Array, initialMeans :: Array)
    N = size(rowIndexedData)[1]
    K = size(initialMeans)[1]
    
    assocs = Int[]
    
    for i ∈ 1:N
        dists = Float64[]
        for k ∈ 1:K 
            append!(dists, norm(rowIndexedData[i,:] .- initialMeans[k,:]))
        end
        append!(assocs,findmin(dists)[2])
    end

    return(assocs)
end




#= Given a number and a vector/list this returns a list of the indicies at
    which that element occurs in the list =#
function elemsList(element, list::Vector)
    out = []
    for i ∈ 1:size(list)[1]
        if list[i]==element
            append!(out,i)
        end
    end
    return(out)
end



#= Takes the row-sorted dataset, the orded list of which mean/centroid each datapoint
    is associated with and the initial guess means, sorts data into clusters for each centroid
    then takes the mean of each giving the new centroids/means =#
function newMeans(rowIndexedData,meanIndexes,guessMeans)
    (points,attributes) = size(rowIndexedData)
    (K,_) = size(guessMeans)

    indicies = 1:K
    
    i = 1
    indicies = elemsList(i,meanIndexes)

    if indicies == []
        means = guessMeans[i,:]
    else
        sample = rowIndexedData[indicies,:]
        means  = zeros(1,attributes)
        for j ∈ 1:attributes
            means[j] = mean(sample[:,j])
        end
    end


    while i < K
        i += 1
        indicies = elemsList(i,meanIndexes)
        means2  = zeros(1,attributes)

        if indicies == []
            means2 = print(dists)
        else
            sample  = rowIndexedData[indicies,:]
            for j ∈ 1:attributes
                means2[j] = mean(sample[:,j])
            end
        end     
       
        means = vcat(means,means2)
    end
    
    return(means)
end



#= Calculates the error/inertia between the two guess means as a +tive real number=#
function error(firstGuess, updatedGuess)
    (K,_) = size(firstGuess)
    if size(firstGuess) != size(updatedGuess)
        return(inf(typeof(firstGuess[1,1])))
    else
        subtract = firstGuess .- updatedGuess
        x = 0
        for i ∈ 1:K
            x += norm(subtract[i,:])
        end
        return(x)
    end
end



#= Performs the newMeans process with some initial guess means untill the means stabilise
    to an error/inertia less that some ϵ =#
function kMeans(rowIndexedData,rowIndexedGuessMeans, ϵ)
    (K,_)        = size(rowIndexedGuessMeans)
    oldGuess     = rowIndexedGuessMeans

    meanIndexes  = associateNearestMeans(rowIndexedData, rowIndexedGuessMeans)
    newGuess     = newMeans(rowIndexedData, meanIndexes, rowIndexedGuessMeans)

    δ = error(oldGuess, newGuess)

    inertias = [δ]

    while δ >= ϵ
        oldGuess    = copy(newGuess)
        meanIndexes = associateNearestMeans(rowIndexedData, oldGuess)
        newGuess    = newMeans(rowIndexedData, meanIndexes, oldGuess)
        δ = error(oldGuess, newGuess)
        inertias    = append!(inertias,δ)
    end

    return(newGuess,inertias)
end

