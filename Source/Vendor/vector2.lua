local vector2 = { }

vector2.type = "Vector2"

vector2.interface = { }
vector2.prototype = { }

function vector2.prototype:toString()
	return string.format("%s<X:%s, Y:%s>", vector2.type, self.x, self.y)
end

function vector2.prototype:cross(vector2)
	return (self.x * vector2.y) - (self.y * vector2.x)
end

function vector2.prototype:dot(vector2)
	return (self.x * vector2.x) + (self.y * vector2.y)
end

function vector2.prototype:lerp(vector2, alpha)
	return vector2.interface.new(
		self.x * (1 - alpha) + vector2.x * alpha,
		self.y * (1 - alpha) + vector2.y * alpha
	)
end

function vector2.interface.new(x, y)
	local self = setmetatable({
		x = x,
		y = y
	}, {
		__index = vector2.prototype,
		__type = vector2.type,

		__tostring = function(self)
			return self:toString()
		end,

		__add = function(self, vector)
			return vector2.interface.new(self.x + vector.x, self.y + vector.y)
		end,

		__sub = function(self, vector)
			return vector2.interface.new(self.x - vector.x, self.y - vector.y)
		end,

		__mul = function(self, vectorOrNum)
			if type(vectorOrNum) == "number" then
				return vector2.interface.new(self.x * vectorOrNum, self.y * vectorOrNum)
			end

			return vector2.interface.new(self.x * vectorOrNum.x, self.y * vectorOrNum.y)
		end,

		__div = function(self, vectorOrNum)
			if type(vectorOrNum) == "number" then
				return vector2.interface.new(self.x / vectorOrNum, self.y / vectorOrNum)
			end

			return vector2.interface.new(self.x / vectorOrNum.x, self.y / vectorOrNum.y)
		end
	})

	self.magnitude = math.sqrt(self.x ^ 2 + self.y ^ 2)

	if self.x > 1 or self.y > 1 then
		self.normal = vector2.interface.new(self.x / self.magnitude, self.y / self.magnitude)
	else
		self.normal = self
	end

	return self
end

vector2.interface.zero = vector2.interface.new(0, 0)
vector2.interface.one = vector2.interface.new(1, 1)

return vector2.interface