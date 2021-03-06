local whirlwind = {
	name = 'whirlwind',
	rate = 10,
	delay = 0,
	n_delay = 0,
	delaymax = 7.85,

	update = function (self, dt, heros)
		if love.keyboard.isDown(' ') and self.delay <= 0 then
			self.delay = self.delaymax
		end

		if self.delay > 0 then
			heros.rotation = heros.rotation + self.delay * dt
			self.delay = self.delay - self.rate * dt
		else
			heros.rotation = 0
		end

		if self.n_delay > 0 and self.n_delay < self.delaymax then
			self.shader:send("max_white", self.n_delay / self.delaymax)
		else
			self.shader:send("max_white", 0)
		end

		self.n_delay = self.delay
		self.n_delay = self.delaymax - self.n_delay
	end,

	image = love.graphics.newImage("img/01.png"),
	effect = love.graphics.newImage("img/01_effect.png"),
	shader = love.graphics.newShader([[
		extern Image eff;
		extern number max_white;

		vec4 effect( vec4 color, Image tex, vec2 tc, vec2 sc )
		{
			vec4 eff_color = Texel(eff,tc);
			vec4 tex_color = Texel(tex, tc);
			number white_level = (eff_color.r + eff_color.g + eff_color.b) / 3;

			if (white_level <= max_white && white_level >= max_white - 0.4)
				return eff_color * color;

			tex_color.a = 0;
			return tex_color;
		}
	]]),

	draw = function (self, heros)
		love.graphics.setColor(heros.color.number[heros.color.color])
		love.graphics.setShader(self.shader)
			love.graphics.draw(self.image,
				heros.x, heros.y,
				0 + self.n_delay,
				1 * (self.n_delay / 4) + 0.1, 1 * (self.n_delay / 4) + 0.1,
				47, 47)
			love.graphics.draw(self.image,
				heros.x, heros.y,
				3.14 + self.n_delay,
				1 * (self.n_delay / 4) + 0.1, 1 * (self.n_delay / 4) + 0.1,
				47, 47)
		love.graphics.setShader()
		love.graphics.setColor(255, 255, 255)
	end
}

whirlwind.shader:send('eff', whirlwind.effect)

return whirlwind
