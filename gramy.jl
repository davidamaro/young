include("locoroco.jl")
include("gramschmidt.jl")
using YO
using GM
dim = 4
blah = Array{Complex{Float64},2}[]
vecs = Array{Float64,1}[]
#dim
tablas = generarTablas(dim)
# primero
todos = Array{Array{Float64,1},1}[]
#dim
for i in 0:dim
#dim
b = avellana(estado(dim,i), 1)
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
n = 2^dim
esto = reshape(tontita,(n,div(length(tontita), n)))
mas = Array{Float64,1}[]
#dim
for i in 1:2^dim
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
matriz = zeros(Complex{Float64}, 2^dim, 2^dim)
for j in 1:2^dim
for i in 1:2^dim
matriz[j,i] =  dot(vec(mas[j]), vec(resultado[i]))
end
end
@show matriz
