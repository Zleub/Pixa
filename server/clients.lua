local clients = {
	list = {}
}

function clients:get(id)
	for k, client in ipairs(self.list) do
		if tonumber(client.id) == tonumber(id) then
			return client
		end
	end
end

function clients:is_id(id)
	for k,v in pairs(self.list) do
		if v.id == id then
			print('id: '..id..' is already in use')
			return true
		end
	end
	return false
end

function clients:add(ip, port)
	nbr = love.math.random(0, 42)
	while self:is_id(nbr) do
		nbr = love.math.random(0, 42)
	end

	print('adding a new client to list: ', ip, port, nbr)
	table.insert(self.list, {
		id = nbr,
		ip = ip,
		port = port
	})
	return nbr
end

function clients:position(id, args)
	print('position callback', id, args)
	-- client = self:get(id)
	return 1
end

function clients:die(id)
	print(id..' is die')
	for k,client in ipairs(self.list) do
		if tonumber(client.id) == tonumber(id) then
			table.remove(self.list, k)
		end
	end
	return 1
end

function clients:dump()
	print(inspect(self.list))
end

return clients
