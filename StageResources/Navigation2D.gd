extends Navigation2D


const PATH_TO_MAP = "../Map/"
const NAVIGATION_POLYGON = "NavigationPolygon2D"
const NAV_POLYGONS_VISIBLE = false
var nav_polygon = null
const OBJECTS_GROUPS = [
	"Rocks",
	"Plants/Trees/Large",
	"Plants/Trees/Medium",
	"OrangeTotems",
	"Buildings/Containers",
	"Buildings/Tents",
	"Buildings/Boxes",
	"Buildings/Crosses",
	"Buildings/Fences",
	"Buildings/Pillars",
	"Buildings/Other"
] 
const CHESTS_GROUP = "Chests"

# Called when the node enters the scene tree for the first time.
func _ready():
	nav_polygon = $NavigationPolygon.get_navigation_polygon()
	for group in OBJECTS_GROUPS:
		add_polygons_from_map_objects(group)
	nav_polygon.make_polygons_from_outlines()
	$NavigationPolygon.set_navigation_polygon(nav_polygon)
	
	#reenable polygon to make it work
	$NavigationPolygon.enabled=false
	$NavigationPolygon.enabled=true

func on_chests_placed():
	print("chests placed")
	nav_polygon = $NavigationPolygon.get_navigation_polygon()
	add_polygons_from_map_objects(CHESTS_GROUP)
	nav_polygon.make_polygons_from_outlines()
	$NavigationPolygon.set_navigation_polygon(nav_polygon)
	
	#reenable polygon to make it work
	$NavigationPolygon.enabled=false
	$NavigationPolygon.enabled=true


func add_polygons_from_map_objects(group):
	var objects = get_node(PATH_TO_MAP+group).get_children()
	for object in objects:
		add_polygon_from_map_object(object.get_node(NAVIGATION_POLYGON))


func add_polygon_from_map_object(object):
	object.visible = NAV_POLYGONS_VISIBLE
	var res_polygon = PoolVector2Array()
	var polygon_transform = object.get_global_transform()
	var polygon = object.get_polygon()
	for vector in polygon:
		var changed_vector = polygon_transform.xform(vector)
		changed_vector.x=changed_vector.x/5
		changed_vector.y=changed_vector.y/5
		res_polygon.append(changed_vector)
	nav_polygon.add_outline(res_polygon)

