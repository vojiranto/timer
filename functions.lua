function round (n, i)
    if i then
        return round(n*i)/i
    else
        return n - n%1
end end

