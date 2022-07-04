using Plots

f(x) = x^2 + 2*x + 1


function trapIntegral(start,finish,step)
    if start == finish
        println("The area is")
        return(0)
    elseif start > finish
        return( -1*trapIntegral(finish,start,step) )
    else
        Area = 0
        for x in (start+step):step:finish
            Area = Area + step*0.5*( f(x) + f(x-step) )
        end
        println("The area is")
        return(Area)
    end
end


function midPntIntegral(start,finish,step)
    if start == finish
        println("The area is")
        return(0)
    elseif start > finish
        return( -1*midPntIntegral(finish,start,step) )
    else
        mid = 0.5*step
        Area = 0
        x = start
        while x < finish
            Area = Area + step*f(x+mid)
            x    = x + step
        end
    println("The area is")
    return(Area)
    end
end


function plotDeriv(start,finish,step)
    if abs(start - finish) < step
        println("Choose smaller step")
    elseif start > finish
        return( plotDeriv(finish,start,step) )
    else
        xs  = start:step:finish
        dfs = []
        for x in xs
            df = (f(x+step)-f(x))/step
            append!(dfs,df)
        end
        pyplot()
        plot(xs, dfs, title = "df/dx", markercolor = "Red")
    end
end