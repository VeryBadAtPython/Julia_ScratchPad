using Plots


a(n) = (n^2+10*n+35)*(sin(n^3))/(n^2+n+1)


function series(fin)
    A = [1 a(1)]
    for i in 2:1:fin
        Ai = [i a(i)]
        A = vcat(A,Ai)
    end
    return(A)
end


function producePlot(n)
    A = series(n)
    pyplot()
    plot(A[:,1], A[:,2],
        seriestype = :scatter,
        title = "Your series",
        markercolor = "Red")
end