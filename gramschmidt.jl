module GM

export resta, gramschmidt, proy

function resta(listaVecs, vec)
    res = vec
    for proyector in listaVecs
        res -= proy(proyector,vec)
    end
    res
end

function gramschmidt(lista)
    vectores = []
    for i in 1:length(lista)
	@show typeof(lista[1:i])
        push!(vectores, resta(vectores, lista[i]))
    end
    vectores
end

function proy(u,v)
    dot(v,u)* u /dot(u,u)
end

end
