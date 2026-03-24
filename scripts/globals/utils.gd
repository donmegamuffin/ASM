class_name MathUtils

static func _cmp_ind(acc, cur) -> Array:
	if acc.is_empty():
		return [cur, 0]
	elif cur < acc[0]:
		return [cur, acc[1] + 1]
	else:
		return acc

static func argmin(array: Array) -> int:
	return array.reduce(_cmp_ind, [])[0]
