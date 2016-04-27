# Aqui viene una explicación de lo que se hace en el módulo, los autores y la fecha

# La siguiente instrucción sirve para *precompilar* el módulo
__precompile__(true)

module YO

    export crater, razzamatazz, formato, antiSemita, x, y, avellana
    export determinarSigno, recibeAvellanaAnti, recibeAvellanaSim
    export generador, generadorSim, flat, superkron
    export tablón, primero, validez, iterador2, orden2
    export orden, loca, stephen, generarTablas
    export alborotador, anti, trail, aplicarTabla

    x = [1,0]
    y = [0,1]

    type avellana
        coef :: Array{Array{Int,1},1}
        sign :: Int64
    end

    type tablón
        a :: Array{Int,1}
        b :: Array{Int,1}
    end

    doc"""
    `lista` es el **vector** a *modificar*. `permutación`
    es el **vector** *permutador*.
    """
    function crater(lista,permutacion,indices)
        for i in eachindex(indices)
	    lista[indices[i]] = permutacion[i]
        end
        lista
    end
    doc"""
    Recibe una lista `lista` y le pasamos una lista
    con los elementos `indices` que serán permutados.
    Es decir, se calculan todas las permutaciones
    con el número de índices y se aplican las permutaciones
    a los elementos que corresponden a los índices que les dimos.
    """
    function razzamatazz(lista,indices)
        estados = Array{Int,1}[]
        paraSerPermutados = Array{Int64,1}[]
        # paraSerPermutados = Array{}(length(indices))
        for i in 1:length(indices)
            push!(paraSerPermutados, lista[indices[i]])
        end
        permutaciones = collect(permutations(paraSerPermutados))
        for i in 1:length(permutaciones)
            push!(estados, crater(lista,permutaciones[i],indices)...)
        end
        estados
        formato(reshape(estados, (length(lista), div(length(estados), length(lista)))))
    end
    doc"""
    De una **matriz** de $n\times m$ obtenemos $n$ **vectores** de longitud $m$.
    """
    function formato(array)
        a,b = size(array)
        listitas = Array{Array{Int64,1},1}[]
        for i in 1:b
            push!(listitas, array[:,i])
        end
        listitas
    end
    doc"""
    Si iniciamos con la lista [1,2,3,4,5] y lanzamos
    antisemita(1,3,lista) nos devuelve
    [1,2,3,4,5] y -[3,2,1,4,5]
    """
    function antiSemita(arriba,abajo,lista)
        sec = []
        liss = copy(lista)
        temp = lista[arriba]
        lista[arriba] = lista[abajo]
        lista[abajo] = temp
        juntador = [liss;lista]
        formato(reshape(juntador, (length(lista), div(length(juntador), length(lista)))))
    end

    function determinarSigno(signo)
        signo,-signo
    end

    function recibeAvellanaAnti(avellana,arriba,abajo)
        signos = determinarSigno(avellana.sign)
        listas = antiSemita(arriba,abajo,avellana.coef)
        generador(signos,listas)
    end

    function recibeAvellanaSim(avellana,indices)
        listas = razzamatazz(avellana.coef,indices)
        generadorSim(listas)
    end

    function generador(signos,listas)
        [avellana(listas[1],signos[1]),avellana(listas[2],signos[2])]
    end

    function generadorSim(listas)
        estados = avellana[]
        for i in 1:length(listas)
            push!(estados,avellana(listas[i],+1))
        end
        estados
    end

    function flat(A)
       result = []
       grep(a) = for x in a 
                   isa(x,Array) ? grep(x) : push!(result,x)
                 end
       grep(A)
       result
     end

    function superkron(avellana)
        avellana.sign*kron(avellana.coef...)
    end

    function primero(lista)
        quita = tablón[]
        push!(quita,tablón(lista,Int64[]))
        for i in convert(Int,ceil(length(lista)/2))+1:length(lista)
            push!(quita,tablón(lista[1:i-1],lista[i:length(lista)]))
        end
        quita
    end

    function validez(lista)
        if (lista[1] == 1 && lista[2] == 2) || (lista[1] == 1 && lista[2] == 3)
            return true
        end
        return false
    end
    function iterador2(coleccion)
        válidos = Array{Int64,1}[]
        estadoActual = start(coleccion)
        while validez(estadoActual[1:2])
            push!(válidos, estadoActual)
            estadoActual = next(coleccion,estadoActual)[2]
        end
        válidos
    end

    function orden2(lista)
        longMin = 1
        if length(lista) == longMin
            return Array[lista]
        end
        a = lista[1]
        b = lista[2]
        
        for i in 2:length(lista)
            if a<b && i < length(lista)
                a = lista[i]
                b = lista[i+1]
                continue
            elseif a<b && i+1 > length(lista)
                return primero(lista)
            elseif a>b && i-1 >= length(lista)/2
                return tablón(lista[1:i-1],lista[i:length(lista)])
            else
                (null)
            end
        end
        (null)
    end
    function orden(lista)
        if length(lista) == 0
            return true
        end
        longMin = 1
        if length(lista) == longMin
            return true
        end
        a = lista[1]
        b = lista[2]
        for i in 2:length(lista)
            if a<b && i < length(lista)
                a = lista[i]
                b = lista[i+1]
            elseif a<b && i+1 > length(lista)
                return true
            else
                return false
            end
        end
        return true
    end

    function loca(lista1,lista2)
        mínimo = min(length(lista1),length(lista2))
        for i in 1:mínimo
            if lista1[i] > lista2[i]
                return false
            end
        end
        true
    end

    function stephen(tabla::tablón)
        if orden(tabla.a) && orden(tabla.b) && loca(tabla.a,tabla.b)
            return tabla
        end
        ()
    end
    function generarTablas(numero)
        a = map(orden2,iterador2(permutations(1:numero)))
        a = flat(a)
        a = map(stephen,a)
    end

    function alborotador(tabla::tablón)
        todos = Int64[]
        for i in 1:length(tabla.b)
            push!(todos, tabla.a[i],tabla.b[i])
        end
        todos
    end

    #function anti(nuez::avellana,tabla::tablón)
        #if length(tabla.b) == 0
            #return nuez
        #end
        #valores = alborotador(tabla)
        #demas = []
        #for i in 1:2:length(valores-1)
            #push!(demas,recibeAvellanaAnti(nuez,valores[i],valores[i+1]))
        #end
        #demas
    #end

    function trail(nuez::avellana, tabla::tablón)
        sal = recibeAvellanaSim(nuez,tabla.a)
        if length(tabla.b) == 0
            return sal
        end
        sal = map(x->recibeAvellanaSim(x,tabla.b),sal)
        sal
    end

    function aplicarTabla(nuez::avellana,tabla)
#if typeof(tabla) != tablón
#  return nothing
#end
        if typeof(tabla) == tablón
            #println("tipo del arg. ", typeof(trail(nuez,tabla)))
            a = flat(trail(nuez,tabla))
            a = anti(a, tabla)
            a = flat(a)
            a = map(superkron,a)
            return sum(a)
        end
    end
    function anti(lista, tabla::tablón)
        valores = alborotador(tabla)
        a = lista
        for i in 1:2:length(valores)
            a = flat(map(x->recibeAvellanaAnti(x,valores[i],valores[i+1]), a))
        end
        a
    end
end
