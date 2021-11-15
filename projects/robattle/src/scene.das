module scene private

require random

enum public GameMode
    menu
    pvp
    pve

var public game_mode = GameMode pvp

enum public NESW
    north
    east
    south
    west

var seed = random_seed(42)

enum public UnitType
    empty
    minimare
    dark_minimare
    minimare_robot_01
    minimare_robot_02

enum public Team
    empty
    left
    right

var public another_team <- {{
    Team left => Team right;
    Team right => Team left
}}

enum public MoveAnimationType
    disabled
    linear
    linear_attack

struct public MoveAnimation
    t = MoveAnimationType disabled
    from, to : float2
    start, duration : float
    direction = NESW south

struct public Unit
    t = UnitType empty
    direction = NESW south
    dt = random_float(seed)
    team = Team empty
    animation = MoveAnimation()
    hp = 0

enum public Level
    ground
    sky
    empty

struct public Row
    level = Level empty
    units : array<Unit>
    lu_corner : float2

struct public Position
    level = Level empty
    pos = -1

struct Scene
    levels : table<Level; Row>

var public scene <- [[Scene
    levels <- {{
        Level ground => [[Row level=Level ground, units <- [{auto
            [[Unit() t=UnitType minimare, team=Team left, hp=3]];
            [[Unit() t=UnitType dark_minimare, team=Team left, hp=3]];
            Unit();
            Unit();
            Unit();
            Unit();
            Unit();
            Unit();
            [[Unit() t=UnitType minimare_robot_02, team=Team right, hp=3]];
            [[Unit() t=UnitType minimare_robot_01, team=Team right, hp=3]]
        }] ]];

        Level sky => [[Row level=Level sky, units <- [{auto
            [[Unit() t=UnitType dark_minimare, team=Team left, hp=3]];
            [[Unit() t=UnitType minimare, team=Team left, hp=3]];
            Unit();
            Unit();
            Unit();
            Unit();
            Unit();
            Unit();
            [[Unit() t=UnitType minimare_robot_02, team=Team right, hp=3]];
            [[Unit() t=UnitType minimare_robot_01, team=Team right, hp=3]]
        }] ]]
    }}
]]

var public active_player = Team left
