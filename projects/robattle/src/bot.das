module bot private

require daslib/media
require math
require random

require scene
require actions
require delay

var seed = random_seed(42)

def distance(p1, p2: Position)
    return (p1.level != p2.level ? 1 : 0) + abs(p1.pos - p2.pos) / 2

def minimal_distance(unit: Position; target: Team)
    var res = 30
    for level in [[Level Level ground; Level sky]]
        for pos in range(length(scene.levels[level].units))
            if scene.levels[level].units[pos].team == target
                res = min(res, unit |> distance([[Position level=level, pos=pos]]))
    return res

def shuffle(inp: array<Position>)
    var inside := inp
    return <- generator<Position>[[<-inside]]() <| $()
        for i in range(length(inside))
            let j = random_int(seed) % inside |> length()
            yield inside[j]
            inside |> erase(j)

        return false

struct Move
    unit, target: Position

def public make_move(bot_player: Team; var cb: lambda<(): void>)
    var unit_list : array<Position>
    for level in [[Level Level ground; Level sky]]
        for pos in range(length(scene.levels[level].units))
            if scene.levels[level].units[pos].team == bot_player
                unit_list |> push([[Position level=level, pos=pos]])

    var moves : array<Move>

    for unit in shuffle(unit_list)
        let u : Unit& = scene.levels[unit.level].units[unit.pos]

        for level in [[Level Level ground; Level sky]]
            for pos in range(length(scene.levels[level].units))
                let target = [[Position level=level, pos=pos]]
                let t : Unit& = scene.levels[target.level].units[target.pos]
                if t.team == another_team[bot_player] && unit |> can_unit_attack(target)
                    moves |> push([[Move unit=unit, target=target]])

    if !moves |> empty()
        let selected_move : Move& = moves[random_int(seed) % moves |> length()]
        let dt = selected_move.unit |> attack(selected_move.target)
        delay(dt) <| @[[<-cb]]
            invoke(cb)
        return

    for unit in shuffle(unit_list)
        for level in [[Level Level ground; Level sky]]
            for pos in range(length(scene.levels[level].units))
                let target = [[Position level=level, pos=pos]]
                if (unit |> can_unit_move(target)
                    && target |> minimal_distance(another_team[bot_player])
                        < unit |> minimal_distance(another_team[bot_player]))
                    moves |> push([[Move unit=unit, target=target]])

    if !moves |> empty()
        let selected_move : Move& = moves[random_int(seed) % moves |> length()]
        let dt = selected_move.unit |> move_unit(selected_move.target)
        delay(dt) <| @[[<-cb]]
            invoke(cb)
        return

    invoke(cb)
