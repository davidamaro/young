include("locoroco.jl")
include("gramschmidt.jl")
using YO
using GM
blah = Array{Complex{Float64},2}[]
vecs = Array{Float64,1}[]
#dim
tablas = generarTablas(5)
# primero
todos = Array{Array{Float64,1},1}[]
#dim
for i in 0:5
#dim
b = avellana(estado(5,i), 1)
for tabla in tablas
	vec = aplicarTabla(b,tabla)
	if vec == zeros(vec)
		continue
	end
	push!(vecs, vec)
end
otros = gramschmidt(vecs)
push!(todos, otros)
vecs = Array{Float64,1}[]
end
#@show todos
tontita = flatVecs(todos)
#dim
n = 2^5
esto = reshape(tontita,(n,div(length(tontita), n)))
mas = Array{Float64,1}[]
#dim
for i in 1:2^5
	push!(mas, esto[:,i])
end
#@show mas
resultado = Array{Complex{Float64},2}[]
for vec in mas
	g = eval(parse(replace(chop(readall(`./young $vec`)), r"i", s"im")))
	push!(resultado, g)
end
#@show resultado
#@show typeof(dot(vec(mas[1]),vec(resultado[1])))
#@show dot(vec(mas[1]),vec(resultado[1]))
matriz = zeros(Complex{Float64}, 2^5, 2^5)
for j in 1:2^5
for i in 1:2^5
matriz[j,i] =  dot(vec(mas[j]), vec(resultado[i]))
end
end
@show matriz
