extends RigidBody3D
 
@export var explosion_decal : Resource
@export var explosion_praticles : Resource
@export var explosion_force : int = 500
 
var items_in_radius : Array[RigidBody3D]
 
 
func _ready():
	randomize()
 


func explosion():
	print("explosion")
	var force_dir : Vector3
	var random_vector : Vector3
	
	#Breaking all the breakables.
	for i in items_in_radius:
		if i.is_in_group("breakable"):
			#Calling the break_object function from the breakable script.
			i.break_object()
			
	#Here the code waits before all the breakables break.
	#You can set the yield timer to 0.05 or higher if you will have issues with the explosion force. 
	#await(get_tree().create_timer(0.04), "timeout")
	
	#Applying the explosion force for every Rigidbody in the array.
	for j in items_in_radius:
	#Getting a direction vector between the bomb and all nearby RigidBodies. This line of code later helps to calculate a trajectory    for the Rigidbodies.
		force_dir = self.global_position.direction_to(j.global_position)
		#Generating a position on the object where the force will be applied. This line of code makes the Rigidbodies randomly rotate after the explosion.
		random_vector = Vector3(randf_range(0, 1), randf_range(0, 1), randf_range(0, 1)) * force_dir
		j.apply_central_impulse(force_dir * explosion_force)
 		



func _on_area_body_entered(body: Node3D) -> void:
	if body.name != self.name:
		print(body.name + "entrou na area de explosao")

		if body is RigidBody3D:
			items_in_radius.append(body)


func _on_area_body_exited(body: Node3D) -> void:
	if body is RigidBody3D:
		items_in_radius.erase(body)


func _on_timer_timeout() -> void:
	explosion()
	
	#Explosion effects 
	#var decal = explosion_decal.instance()
	#self.get_parent().add_child(decal)
	#decal.translation = self.translation
	#decal.translation.y = 0.2
	
	#Explosion particles made by drcd1. Here is the link: https://github.com/drcd1/GodotSimpleExplosionVFX
	#var particles = explosion_praticles.instance()
	#self.get_parent().add_child(particles)
	#particles.translation = self.translation
	#particles.emitting = true
