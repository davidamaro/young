# Young 1.0 David Amaro-Alcalá
# 25 IV 2016

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
        coef :: Array{Any,1}
        sign :: Int64
    end

    type tablón
        a :: Array{Any,1}
        b :: Array{Any,1}
    end

    doc"""
    `lista` es el **vector** a *modificar*. `permutación`
    es el **vector** *permutador*.
    """
    function crater(lista,permutacion,indices)
        for i in 1:length(indices)
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
        estados = []
        paraSerPermutados = []
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
        listitas = []
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

    doc"""
    `signo(-1)` o `signo(1)`.
    Si tiene -1 lo cambia a 1 y vice versa.
    """
    function determinarSigno(signo)
        signo,-signo
    end


    doc"""
    Recibe una `avellana` y `arriba` `abajo`.
    Utiliza a `antiSemita` y a `generar`.
    """
    function recibeAvellanaAnti(avellana,arriba,abajo)
        signos = determinarSigno(avellana.sign)
        listas = antiSemita(arriba,abajo,avellana.coef)
        generador(signos,listas)
    end

    doc"""
    Utiliza a `razzamatazz` para generar el estado
    **simétrico**.
    """
    function recibeAvellanaSim(avellana,indices)
        listas = razzamatazz(avellana.coef,indices)
        generadorSim(listas)
    end

    doc"""
    Genera los dos estados resultado de **antisimetrizar**.
    Simplemente genera las dos *avellanas*; con el
    signo y la lista correcta.
    """
    function generador(signos,listas)
        [avellana(listas[1],signos[1]),avellana(listas[2],signos[2])]
    end

    doc"""
    Toma todos los *vectores* resultado de **simetrizar**
    y forma las *avellanas* correspondiente.
    """
    function generadorSim(listas)
        estados = avellana[]
        for i in 1:length(listas)
            push!(estados,avellana(listas[i],+1))
        end
        estados
    end

    doc"""
    Aplana una lista. De rosetta code.
    """
    function flat(A)
       result = Any[]
       grep(a) = for x in a 
                   isa(x,Array) ? grep(x) : push!(result,x)
                 end
       grep(A)
       result
     end

    doc"""
    Versión del producto de Kronecker pero
    usando **avellanas**.
    """
    function superkron(avellana)
        avellana.sign*kron(avellana.coef...)
    end

    doc"""
    El primer estado resultado de las permutaciones
    tiene la consideración de que puede dar varios
    tablones de Young. Aquí se calculan todos.
    """
    function primero(lista)
        quita = []
        push!(quita,tablón(lista,Int64[]))
        for i in convert(Int,ceil(length(lista)/2))+1:length(lista)
            push!(quita,tablón(lista[1:i-1],lista[i:length(lista)]))
        end
        quita
    end

    doc"""
    `validez` utiliza la observación de que todos los
    diagramas de Young que podemos obtener del resultado
    de las **permutaciones** siempre tienen que iniciar
    con un **uno** y un **dos** o **tres**.
    """
    function validez(lista)
        if (lista[1] == 1 && lista[2] == 2) || (lista[1] == 1 && lista[2] == 3)
            return true
        end
        return false
    end

    doc"""
    Utilizamos a `iterador2` *junto con* `validez`
    para obtener, de las permutaciones, los prototabloides
    de Young. sólo recorre los necesarios.
    """
    function iterador2(coleccion)
        válidos = []
        estadoActual = start(coleccion)
        while validez(estadoActual[1:2])
            push!(válidos, estadoActual)
            estadoActual = next(coleccion,estadoActual)[2]
        end
        válidos
    end

    doc"""
    `orden2` revisa y mutila las permutaciones para
    que puedan formar una tabla de Young.
    """
    function orden2(lista)
        longMin = 1
        if length(lista) == longMin
            return Array[lista]
        end
        a = lista[1]
        b = lista[2]
        
        for i in 2:length(lista)
            # Este primer criterio se refiere
            # al hecho de que seguimos en orden
            # y además todavía no estamos en el último
            if a<b && i < length(lista)
                a = lista[i]
                b = lista[i+1]
                continue
            # Si todos están en orden significa
            # que estamos ante la primera permutación
            # por lo que llamamos a `primero` para
            # que nos genere a todos los estados.
            elseif a<b && i+1 > length(lista)
                return primero(lista)
            # Hay desorden y ya tienen el tamño necesario
            # que es que la parte de arriba ya tiene
            # más de la mitad de la tabla por lo que
            # es un buen candidato para generar
            # una tabla de Young.
            elseif a>b && i-1 >= length(lista)/2
                return tablón(lista[1:i-1],lista[i:length(lista)])
            else
                (null)
            end
        end
        (null)
    end

    doc"""
    Revisa que los elementos de una lista
    estén completamente ordenados: 1,2,3,4,5
    etc. Lo usamos con `stephen` para que
    los protooYoung sean evaluados para ser
    un buen tablón de Young.
    """
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

    doc"""
    `loca` revisa que los de arriba sean mayores
    que los de abajo.
    """
    function loca(lista1,lista2)
        mínimo = min(length(lista1),length(lista2))
        for i in 1:mínimo
            if lista1[i] > lista2[i]
                return false
            end
        end
        true
    end

    doc"""
    Verifica que todas las condiciones se cumplan para
    ser un tabloide de Young. Lo que pasa es que
    puuede que después del primer desorden existe todavía
    desorden en la fila de abajo.
    """
    function stephen(tabla::tablón)
        if orden(tabla.a) && orden(tabla.b) && loca(tabla.a,tabla.b)
            return tabla
        end
        ()
    end
    doc"""
    Utiliza las permutaciones y los test para ver si una 
    prototabla es una buena tabla.
    """
    function generarTablas(numero)
        a = map(orden2,iterador2(permutations(1:numero)))
        a = flat(a)
        a = map(stephen,a)
    end

    doc"""
    Obtiene en un solo vector los valores que se
    pasaran al antisimetrizador para antismetrizar
    el estado.
    """
    function alborotador(tabla::tablón)
        todos = []
        for i in 1:length(tabla.b)
            push!(todos, tabla.a[i],tabla.b[i])
        end
        todos
    end

    doc"""
    Aplica todas las simetrías al estado.
    """
    function trail(nuez::avellana, tabla::tablón)
        sal = recibeAvellanaSim(nuez,tabla.a)
        if length(tabla.b) == 0
            return sal
        end
        sal = map(x->recibeAvellanaSim(x,tabla.b),sal)
        sal
    end

    doc"""
    Dada una avellana y un tablón, le aplica este último a
    la avellana.
    """
    function aplicarTabla(nuez::avellana,tabla::tablón)
        a = trail(nuez,tabla)
        a = flat(a)
        a = anti(a, tabla)
        a = flat(a)
        a = map(superkron,a)
        sum(a)
    end
    doc"""
    Dado que para antisimetrizar son varias veces
    se utiliza una lista y a cada uno de esas
    listas se aplica el antisimetrizador a este resultado
    se le aplica el antisimetrizador y así.
    """
    function anti(lista, tabla::tablón)
        estados =[]
        valores = alborotador(tabla)
        a = lista
        for i in 1:2:length(valores)
            a = map(x->recibeAvellanaAnti(x,valores[i],valores[i+1]), a)
            a=flat(a)
        end
        a
    end
end
