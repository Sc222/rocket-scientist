extends Navigation2D


const PATH_TO_MAP = "../Map/"
const NAVIGATION_POLYGON = "NavigationPolygon2D"
const NAV_POLYGONS_VISIBLE = false

#objects which are instanced before game launch
const STATIC_OBJECT_GROUPS = [
	"Rocks",
	"Plants/Trees/Large",
	"Plants/Trees/Medium",
	"OrangeTotems",
	"Buildings/Containers",
	"Buildings/Tents",
	"Buildings/Boxes",
	"Buildings/Fences",
	"Buildings/Pillars",
	"Buildings/Other"
] 

# chests are instanced only when signal is emitted so they are separate
const CHESTS_GROUP = ["Chests"]

func _ready():
	update_navigation_polygon_with_map_groups(STATIC_OBJECT_GROUPS)


func on_chests_placed():
	update_navigation_polygon_with_map_groups(CHESTS_GROUP)

# group is the name of ysort node where objects with polygons are located
# at first we add all outlines and then update the whole polygon
func update_navigation_polygon_with_map_groups(groups):
	var nav_polygon = $NavigationPolygon.get_navigation_polygon()
	for group in groups:
		add_polygon_outlines_from_map_group(nav_polygon, group)
	set_new_polygon(nav_polygon)


func add_polygon_outlines_from_map_group(nav_polygon, group):
	var objects = get_node(PATH_TO_MAP+group).get_children()
	for object in objects:
		add_polygon_outline(nav_polygon, object.get_node(NAVIGATION_POLYGON))


func add_polygon_outline(nav_polygon:NavigationPolygon, object:Polygon2D):
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


func set_new_polygon(nav_polygon):
	# convert outlines into polygons
	nav_polygon.make_polygons_from_outlines()
	$NavigationPolygon.set_navigation_polygon(nav_polygon)
	# reenable polygon to update its state
	$NavigationPolygon.enabled=false
	$NavigationPolygon.enabled=true

