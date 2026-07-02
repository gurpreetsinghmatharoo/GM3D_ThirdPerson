#macro DELTA_SECONDS delta_time / 1000000


/// @func findAnimIndex(_scene, _name)
///
/// @desc Resolves an animation index by exact name match, then substring
/// match, otherwise falls back to index 0.
///
/// @param {Struct.GM3D_Scene} _scene Scene containing animation clips.
/// @param {String} _name Preferred animation name.
///
/// @return {Real} Selected animation index in the scene animation list.
function findAnimIndex(_scene, _name)
{
	var _animCount = _scene.animationCount;
	var _targetName = string_lower(string(_name));
	var _containsIdx = -1;

	for (var _animIndex = 0; _animIndex < _animCount; ++_animIndex)
	{
		var _anim = _scene.getAnimation(_animIndex);
		var _animName = string(_anim.path);

		var _nameLower = string_lower(_animName);
		if (_nameLower == _targetName)
		{
			return _animIndex;
		}

		if (_containsIdx < 0 && string_pos(_targetName, _nameLower) > 0)
		{
			_containsIdx = _animIndex;
		}
	}

	if (_containsIdx >= 0)
	{
		return _containsIdx;
	}

	return 0;
}


/// @func findAnimComponent(_node)
///
/// @desc Recursively searches a node subtree for the first animation
/// component.
///
/// @param {Struct.GM3D_Node|Undefined} _node Root node to inspect.
///
/// @return {Struct.GM3D_AnimationComponent|Undefined} First animation component
/// found, or undefined when none exists.
function findAnimComponent(_node)
{
	if (_node == undefined)
	{
		return undefined;
	}

	var _directComp = _node.getAnimationComponent();
	if (_directComp != undefined)
	{
		return _directComp;
	}

	var _children = _node.getChildren();
	for (var i = 0; i < array_length(_children); ++i)
	{
		var _nestedComp = findAnimComponent(_children[i]);
		if (_nestedComp != undefined)
		{
			return _nestedComp;
		}
	}

	return undefined;
}

/// @func orbitCamera(_camNode, _orbitCenter, _orbitRadius, _orbitHeight, _orbitAngle)
///
/// @desc Positions and orients a camera in an orbit pattern around a center
/// point.
///
/// @param {Struct.GM3D_Node} _camNode The camera node to position.
/// @param {Struct.GM3D_Vec3} _orbitCenter Center point of the orbit.
/// @param {Real} _orbitRadius Radius distance from center.
/// @param {Real} _orbitHeight Height offset above center.
/// @param {Real} _orbitAngle Angle around the center in degrees.
function orbitCamera(
	_camNode,
	_orbitCenter,
	_orbitRadius,
	_orbitHeight,
	_orbitAngle
)
{
	var _camX = _orbitCenter.x + lengthdir_x(_orbitRadius, _orbitAngle);
	var _camY = _orbitCenter.y + _orbitHeight;
	var _camZ = _orbitCenter.z + lengthdir_y(_orbitRadius, _orbitAngle);

	var _camPos = new GM3D_Vec3(_camX, _camY, _camZ);
	_camNode.setLocalPosition(_camPos);

	var _lookDir = (new GM3D_Vec3()).subVectors(_camPos, _orbitCenter);
	alignNode(_camNode, _lookDir);
}

/// @func alignNode(_node, _direction)
///
/// @desc Rotates a scene node so its forward axis points toward the provided
/// direction.
///
/// @param {Struct.GM3D_Node} _node The node to rotate.
/// @param {Struct.GM3D_Vec3} _direction Direction vector.
function alignNode(_node, _direction)
{
	var _forward = _direction.clone();
	_forward.normalize();

	var _up = GM3D_Vec3.up();
	if (abs(_forward.dot(_up)) >= 0.999)
	{
		_up = GM3D_Vec3.forward();
	}

	var _rotation = GM3D_Quaternion.fromLookRotation(_forward, _up);
	_node.setLocalRotation(_rotation.normalizeSafe(0.000001));
}

/// @func getForwardVec(_yaw, _pitch)
///
/// @desc Builds a forward direction vector from yaw and pitch angles.
///
/// @param {Real} _yaw Yaw angle in degrees.
/// @param {Real} _pitch Pitch angle in degrees.
///
/// @return {Struct.GM3D_Vec3} Forward unit direction derived from yaw and pitch.
///
/// @self objSample
function getForwardVec(_yaw, _pitch)
{
	var _yawRad = degtorad(_yaw);
	var _pitchRad = degtorad(_pitch);
	var _cosPitch = cos(_pitchRad);

	return new GM3D_Vec3(
		sin(_yawRad) * _cosPitch,
		sin(_pitchRad),
		-cos(_yawRad) * _cosPitch
	);
}

////////////////////////////////////////////////////////////////////////////////
// Scene

/// @func loadScene(_fileName)
///
/// @desc Loads a glTF scene from disk, assigns sample shaders, freezes the
/// scene source, and tracks it for cleanup.
///
/// @param {String} _fileName Relative path to the glTF file.
///
/// @return {Struct.GM3D_Scene|Undefined} Frozen loaded scene, or undefined
/// if loading failed.
///
/// @self objSample
function loadScene(_fileName)
{
	var _filePath = working_directory + _fileName;
	var _scene = GM3D_Scene.loadGltf(_filePath);
	if (_scene == undefined)
	{
		return undefined;
	}

	assignShaders(_scene);
	_scene.freeze();
	array_push(obj_scene.assets, _scene);
	return _scene;
}

/// @func assignShaders(_scene)
///
/// @desc Assigns shaders to all materials in a scene. Optionally uses
/// instanced shader variants.
///
/// @param {Struct.GM3D_Scene} _scene Scene to assign shaders to.
/// @param {Bool} [_instanced] Whether to use instanced shader variants.
/// Defaults to false.
///
/// @self objSample
function assignShaders(_scene, _instanced = false)
{
	var _nodes = _scene.getNodes();
	var _materials = _scene.getMaterials();

	var _staticShader = _instanced ? shStaticInstanced : shStatic;
	var _animatedShader = _instanced ? shAnimatedInstanced : shAnimated;

	// Assign static shader to all materials by default
	for (var _matIdx = 0; _matIdx < array_length(_materials); ++_matIdx)
	{
		var _material = _materials[_matIdx];
		_material.setShader(_staticShader);
	}

	// Override with animated shader for nodes with skinned mesh components
	for (var _nodeIdx = 0; _nodeIdx < array_length(_nodes); ++_nodeIdx)
	{
		var _node = _nodes[_nodeIdx];
		var _skinnedComp = _node.getSkinnedMeshComponent();
		if (_skinnedComp != undefined)
		{
			var _skinnedMat = _skinnedComp.getMaterial();
			if (_skinnedMat != undefined)
			{
				_skinnedMat.setShader(_animatedShader);
			}
		}
	}
}

/// @func getBounds(_scene)
///
/// @desc Computes an axis-aligned bounding box, center, extent, and radius for
/// all mesh geometry in the provided scene.
///
/// @param {Struct.GM3D_Scene} _scene Scene to evaluate.
///
/// @return {Struct} Bounds result containing min, max, center, extent, and
/// radius.
function getBounds(_scene)
{
	var _boundsMin = new GM3D_Vec3(infinity, infinity, infinity);
	var _boundsMax = new GM3D_Vec3(-infinity, -infinity, -infinity);

	var _nodes = _scene.getNodes();
	for (var _nodeIdx = 0; _nodeIdx < array_length(_nodes); ++_nodeIdx)
	{
		var _node = _nodes[_nodeIdx];
		var _worldMatrix = _node.getWorldMatrix();
		var _meshes = _node.getMeshes();

		for (var _meshIdx = 0; _meshIdx < array_length(_meshes); ++_meshIdx)
		{
			var _mesh = _meshes[_meshIdx];
			var _localMin = _mesh.getBoundingBoxMin();
			var _localMax = _mesh.getBoundingBoxMax();
			if (_localMin == undefined || _localMax == undefined)
			{
				continue;
			}

			for (var ix = 0; ix < 2; ++ix)
			{
				for (var iy = 0; iy < 2; ++iy)
				{
					for (var iz = 0; iz < 2; ++iz)
					{
						var _localX = (ix == 0) ? _localMin.x : _localMax.x;
						var _localY = (iy == 0) ? _localMin.y : _localMax.y;
						var _localZ = (iz == 0) ? _localMin.z : _localMax.z;
						var _worldPoint = _worldMatrix.transformPoint(new GM3D_Vec3(_localX, _localY, _localZ));

						_boundsMin.x = min(_boundsMin.x, _worldPoint.x);
						_boundsMin.y = min(_boundsMin.y, _worldPoint.y);
						_boundsMin.z = min(_boundsMin.z, _worldPoint.z);
						_boundsMax.x = max(_boundsMax.x, _worldPoint.x);
						_boundsMax.y = max(_boundsMax.y, _worldPoint.y);
						_boundsMax.z = max(_boundsMax.z, _worldPoint.z);
					}
				}
			}
		}
	}

	if (_boundsMin.x == infinity)
	{
		_boundsMin = new GM3D_Vec3(-1.0, -1.0, -1.0);
		_boundsMax = new GM3D_Vec3(1.0, 1.0, 1.0);
	}

	var _center = new GM3D_Vec3(
		(_boundsMin.x + _boundsMax.x) * 0.5,
		(_boundsMin.y + _boundsMax.y) * 0.5,
		(_boundsMin.z + _boundsMax.z) * 0.5
	);

	var _extent = new GM3D_Vec3(
		_boundsMax.x - _boundsMin.x,
		_boundsMax.y - _boundsMin.y,
		_boundsMax.z - _boundsMin.z
	);

	var _radius = _extent.length() * 0.5;

	return {
		min: _boundsMin,
		max: _boundsMax,
		center: _center,
		extent: _extent,
		radius: _radius,
	};
}
