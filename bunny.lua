
-- Bunny by ExeterDad

mobs:register_mob("mobs:bunny", {
	-- animal, monster, npc
	type = "animal",
	-- is it aggressive
	passive = true,
	-- health & armor
	hp_min = 1, hp_max = 4, armor = 200, 
	-- textures and model
	collisionbox = {-0.268, -0.5, -0.268,  0.268, 0.167, 0.268},
	visual = "mesh",
	mesh = "mobs_bunny.b3d",
	drawtype = "front",
	textures = {
		{"mobs_bunny_grey.png"},
		{"mobs_bunny_brown.png"},
		{"mobs_bunny_white.png"},
	},
	-- sounds
	sounds = {},
	makes_footstep_sound = false,
	-- speed and jump
	walk_velocity = 1, run_velocity = 2,
	jump = true,
	-- drops meat when dead
	drops = {
		{name = "mobs:meat_raw",
		chance = 1, min = 1, max = 2,},
	},
	-- damaged by
	water_damage = 1,
	lava_damage = 4,
	light_damage = 0,
	-- model animation
	animation = {
		speed_normal = 15,
		stand_start = 1,		stand_end = 15,
		walk_start = 16,		walk_end = 24,
		punch_start = 16,		punch_end = 24,
	},
	-- follows carrot from farming redo
	follow = "farming:carrot",
	view_range = 5,
	-- eat carrots
	replace_rate = 80,
	replace_what = {"farming:carrot_7", "farming:carrot_8", "farming_plus:carrot"},
	replace_with = "air",
	-- right click to pick up rabbit
	on_rightclick = function(self, clicker)
		local item = clicker:get_wielded_item()
		local name = clicker:get_player_name()

		if item:get_name() == "farming_plus:carrot_item"
		or item:get_name() == "farming:carrot" then
			-- take item
			if not minetest.setting_getbool("creative_mode") then
				item:take_item()
				clicker:set_wielded_item(item)
			end
			-- feed and tame
			self.food = (self.food or 0) + 1
			if self.food > 3 then
				self.food = 0
				self.tamed = true
				-- make owner
				if not self.owner or self.owner == "" then
					self.owner = name
				end
			end
			return
		end
		-- Monty Python tribute
		if item:get_name() == "mobs:lava_orb" then
			-- take item
			if not minetest.setting_getbool("creative_mode") then
				item:take_item()
				clicker:set_wielded_item(item)
			end
			self.object:set_properties({
				textures = {"mobs_bunny_evil.png"},
			})
			self.type = "monster"
			self.state = "attack"
			self.object:set_hp(20)
			return
		end

		if clicker:is_player()
		and clicker:get_inventory()
		and self.child == false
		and clicker:get_inventory():room_for_item("main", "mobs:bunny") then

			-- pick up if owner
			if self.owner == name then
				clicker:get_inventory():add_item("main", "mobs:bunny")
				self.object:remove()
			-- cannot pick up if not tamed
			elseif not self.owner or self.owner == "" then
				minetest.chat_send_player(name, "Not tamed!")
			-- cannot pick up if not owner
			elseif self.owner ~= name then
				minetest.chat_send_player(name, "Not owner!")
			end
		end
	end,
	attack_type = "dogfight",
	damage = 5,
})

mobs:register_spawn("mobs:bunny", {"default:dirt_with_grass", "ethereal:prairie_dirt"}, 20, 10, 15000, 1, 31000)
mobs:register_egg("mobs:bunny", "Bunny", "mobs_bunny_inv.png", 0)
