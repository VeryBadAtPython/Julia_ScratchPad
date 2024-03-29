using Plots
using Random
e=2.7182818
v(t)=(1600*t+1)*e^(-800*t)
i(t)=50*e^(-800*t)*10^(-3)

f(x) = v(x)*i(x)

# trapezoid rule integral calculatior
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



# midPoint integral calculator
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



# derivative plotter
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



# calculate area using simpson's rule
function simpsRuleInt(start,finish,n) :: Float64
    if isodd(n)
        simpsRuleInt(start,finish,n+1)
    elseif n < 0
        simpsRuleInt(start,finish,abs(n))
    else
        dx = (finish-start)/n
        x = start
        simp = 0
        for i in 1:2:(n-2)
            x = x + dx
            simp = simp + 4*f(x)
            x = x + dx
            simp = simp + 2*f(x)
        end
        area = (dx/3)*( f(start) + simp + 4*f(finish-dx) + f(finish) )
        return(area)
    end
end



#Slow antiderivative plotter but more accurate using simpsons rule
function slowAntidev(start,finish,step)
    xs    = start:step:finish
    intFs = []
    for x in xs
        ad = simpsRuleInt(0,x,16)
        append!(intFs,ad)
    end
    pyplot()
    plot(xs, intFs, title = "antiderivative of f", markercolor = "Blue")
end



#Faster antiderivative using trap method
#Seems quite innacurate
function fastAD(start,finish,step)
    a  = convert(Float64,start)
    b  = convert(Float64,finish)
    dx = convert(Float64,step)
    return(fastADhelp(a,b,dx))
end

function fastADhelp(start::Float64,finish::Float64,step::Float64)
    if abs(step) > abs(finish - start)
        println("Choose smaller step")
    elseif finish < start
        return(fastADhelp(finish,start,step))
    else
        xs    = [start]
        init  = simpsRuleInt(0,start,16)
        intFs = [init]

        cumm  = init
        prevf = f(start)
        x = start + step :: Float64

        while x <= finish
            append!(xs,x)
            feval = f(x)
            cumm = cumm + (feval + prevf)*0.5*step
            append!(intFs,cumm)
            x = x + step
        end

        pyplot()
        plot(xs, intFs, title = "antiderivative of f", markercolor = "Blue")
    end
end


#Monte Carlo Integration calculator
#Uses rough bounds from a sample of 100 points
#Only for positive valued functions
function monteCarloPos(start, finish, points::Int)
    dx     = abs(finish - start)/10000
    xs     = start:dx:finish
    fs     = map((x) -> f(x), xs)

    maxB   = maximum(fs)
    bound = (finish - start)*(maxB)

    below::Int = 0
    ys         = 0:dx:maxB
    i::Int     = 1

    while i <= points
        i = i+1
        x = rand(xs)
        y = rand(ys)
        if y <= f(x)
            below = below + 1
        end
    end

    eval = (below/points)*bound
    return(eval)
end