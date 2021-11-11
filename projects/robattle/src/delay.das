module delay private

require daslib/media
require math

require frametime

struct Delayed
    time : float
    func : lambda<():void>

var awaited : array<Delayed>
var immediate : array<Delayed>

def public act()
    awaited |> resize(length(awaited) + length(immediate))
    for i in range(immediate |> length())
        awaited[i] <- immediate[i]
    immediate |> clear()

    for act in awaited
        if frametime() >= act.time
            invoke(act.func)

    awaited <- [{for act in awaited; act; where frametime() < act.time}]

def public delay(dt: float; var func : lambda<():void>)
    immediate |> resize(length(immediate) + 1)
    var last : Delayed & = immediate[length(immediate) - 1]
    last.time = frametime() + dt
    last.func <- func
