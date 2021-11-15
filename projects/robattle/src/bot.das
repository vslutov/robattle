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
    score: int

def run_move(moves: array<Move>; cb: block<(Move): void>)
    var max_score = moves[0].score
    for act in moves
        max_score = max(max_score, act.score)

    let filtered_moves <- [{for act in moves; act; where act.score == max_score}]
    let selected_move : Move& = filtered_moves[random_int(seed) % filtered_moves |> length()]
    invoke(cb, selected_move)

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
                    moves |> push([[Move unit=unit, target=target, score=-t.hp]])

    if !moves |> empty()
        moves |> run_move() <| $(selected_move: Move)
            let dt = selected_move.unit |> attack(selected_move.target)
            delay(dt) <| @[[<-cb]]
                invoke(cb)
        return

    for unit in shuffle(unit_list)
        let unit_distance = unit |> minimal_distance(another_team[bot_player])

        for level in [[Level Level ground; Level sky]]
            for pos in range(length(scene.levels[level].units))
                let target = [[Position level=level, pos=pos]]
                let target_distance = target |> minimal_distance(another_team[bot_player])

                if (unit |> can_unit_move(target) && target_distance < unit_distance)
                    moves |> push([[Move unit=unit, target=target, score=target_distance]])

    if !moves |> empty()
        moves |> run_move() <| $(selected_move: Move)
            let dt = selected_move.unit |> move_unit(selected_move.target)
            delay(dt) <| @[[<-cb]]
                invoke(cb)
        return

    invoke(cb)
