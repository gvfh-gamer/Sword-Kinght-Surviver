extends Node2D

const FOAM: PackedScene = preload("res://prefabs/itens/foam.tscn")
const LEVELDEFAULT: int = 0


@onready var grassTilemap:= $terreno as TileMapLayer
@onready var waterTilemap:= $agua as TileMapLayer

var grassUsedCells : Array
var waterUserCells : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	var usedGrassRect: Rect2 = grassTilemap.get_used_rect()
	grassUsedCells = grassTilemap.get_used_cells()
	gererateWaterTiles(usedGrassRect)
	generateFoamTiles()

func  gererateWaterTiles(usedRect: Rect2) -> void:
	for x in range(usedRect.position.x - 10, usedRect.size.x + 10):
		for y in range(usedRect.position.y -10, usedRect.size.y + 10):
			if grassUsedCells.has(Vector2i(x, y)):
				continue
				
			waterTilemap.set_cell(Vector2i(x , y), LEVELDEFAULT, Vector2i(0, 0),  LEVELDEFAULT)
			
	waterUserCells = waterTilemap.get_used_cells()
	

func generateFoamTiles() -> void:
	for cell in grassUsedCells:
		if checkGrassNeighbors(cell):
			spawnFoan(cell)
		

func checkGrassNeighbors(cell: Vector2i) -> bool:
	var left_neighbor: Vector2i = Vector2i(cell.x -1, cell.y)
	var right_neighbor: Vector2i = Vector2i(cell.x +1, cell.y)
	var up_neighbor: Vector2i = Vector2i(cell.x, cell.y -1)
	var botton_neighbor: Vector2i = Vector2i(cell.x, cell.y +1)
	var neighborsList: Array =[left_neighbor, right_neighbor, up_neighbor, botton_neighbor]
	
	for neighbor in neighborsList:
		if waterUserCells.has(neighbor):
			return true
			
	return false

func spawnFoan(foamCell: Vector2i) -> void:
	var foam = FOAM.instantiate()
	add_child(foam)
	foam.position = (foamCell * 64.0) + Vector2(32, 32)
	
