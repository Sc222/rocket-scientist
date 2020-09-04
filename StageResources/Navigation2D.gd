extends Navigation2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const PATH_TO_MAP = "../Map/"
const NAVIGATION_POLYGON = "NavigationPolygon2D"
const NAV_POLYGONS_VISIBLE = false
var nav_polygon = null

# Called when the node enters the scene tree for the first time.
func _ready():
	nav_polygon = $NavigationPolygon.get_navigation_polygon()
	#add_polygons_from_map_objects("Rocks")
	add_polygons_from_map_objects("Plants/Trees/Large")
	#add_polygons_from_map_objects("Plants/Trees/Medium")
	#nav_polygon.make_polygons_from_outlines()
	nav_polygon.make_polygons_from_outlines()
	$NavigationPolygon.set_navigation_polygon(nav_polygon)
	
	#reenable polygon to make it work
	$NavigationPolygon.enabled=false
	$NavigationPolygon.enabled=true


func add_polygons_from_map_objects(group):
	var objects = get_node(PATH_TO_MAP+group).get_children()
	for object in objects:
		add_polygon_from_map_object(object.get_node(NAVIGATION_POLYGON))

	#add_polygon_from_map_object(objects[0].get_node(NAVIGATION_POLYGON))
	#add_polygon_from_map_object(objects[1].get_node(NAVIGATION_POLYGON))
	#	print("add stone: ",object)
		#print(object)


func add_polygon_from_map_object(object):
	object.visible = NAV_POLYGONS_VISIBLE
	var res_polygon = PoolVector2Array()
	#nav_polygon = $NavigationPolygon.get_navigation_polygon()
	var polygon_transform = object.get_global_transform()
	#polygon_transform.x[0]=1
	#polygon_transform.y[0]=1
	var polygon = object.get_polygon()
	for vector in polygon:
		#print("orig vector:",vector)
		
		var changed_vector = polygon_transform.xform(vector)
		#print("changed vector:",changed_vector)
		changed_vector.x=changed_vector.x/5
		changed_vector.y=changed_vector.y/5
		res_polygon.append(changed_vector)
	nav_polygon.add_outline(res_polygon)
	#nav_polygon.make_polygons_from_outlines()
	#todo optimize nav_polygon
	#$NavigationPolygon.set_navigation_polygon(nav_polygon)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
