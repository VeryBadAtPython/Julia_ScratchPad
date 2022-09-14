key1 = zeros(Int,3,3,3)
key1[:,:,1] = ['A' 'D' 'G'; 'J' 'M' 'O'; 'R' 'U' 'X']
key1[:,:,2] = ['B' 'E' 'H'; 'K' '_' 'P'; 'S' 'V' 'Y']
key1[:,:,3] = ['C' 'F' 'I'; 'L' 'N' 'Q'; 'T' 'W' 'Z']
key1 = convert(Array{Char, 3},Key1)

plaintext1 = "Please help. I am trapped in a crypto factory and the only way I can communicate is by test vectors."



function prepare(text::String)
    text = uppercase(text)
    text = replace(text,' '=>'_')
    text = replace(text,'.'=>"")
end





function findPos(key::Array{Char, 3},x::Char)
    for i in 1:3
        for j in 1:3
            for k in 1:3
                if key[i,j,k]==x
                    return([i;j;k])
                end
            end
        end
    end
end


function shift(list,num::Int)::Array{Int, 1}
    len = length(list)
    out = zeros(len)
    for i in 1:1:len
        pos = i - num

        if pos >= 1
            out[i]=list[pos]
        else
            out[i]=list[pos+len]
        end
    end
    return(out)
end


function posArray(text::String,key)
    len = length(text)
    out = zeros(3,len)

    for i in 1:1:len
        letter = text[i]
        out[:,i] = findPos(key,letter)
    end

    return(out)
end


function encrypt(key::Array{Char, 3},text::String)
    text = prepare(text)
    len = length(text)

    shifted = posArray(text,key)
    shifted[2,:] = shift(shifted[2,:],1)
    shifted[3,:] = shift(shifted[3,:],2)

    chyphertext = ""

    for i in 1:1:len
        pos = shifted[:,i]
        (x,y,z)=(pos[1],pos[2],pos[3])
        x = convert(Int,x)
        y = convert(Int,y)
        z = convert(Int,z)
        char = key[x,y,z]
        chyphertext = chyphertext * char
    end

    return(chyphertext)
end
