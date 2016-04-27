include("locoroco.jl")
using YO
milista = Array{Int,1}[y,y,y,y,y,x,x,x]
b = avellana(milista,1)
@time map(x->aplicarTabla(b,x),generarTablas(8))
