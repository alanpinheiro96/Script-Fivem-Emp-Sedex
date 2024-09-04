local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
func = Tunnel.getInterface("emp_sedex")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = false
local servico = false
local selecionado = 0
--local entrar em serviço
local CoordenadaX = 78.78 
local CoordenadaY = 111.96
local CoordenadaZ = 81.16 


-----------------------------------------------------------------------------------------------------------------------------------------
-- RESIDENCIAS
-----------------------------------------------------------------------------------------------------------------------------------------
local locs = {
	[1] = { ['x'] = 155.85, ['y'] = -43.10, ['z'] = 67.71 },
	[2] = { ['x'] = 313.35, ['y'] = -245.31, ['z'] = 53.89 },
	[3] = { ['x'] = -52.17, ['y'] = -103.74, ['z'] = 57.63 },
	[4] = { ['x'] = -269.36, ['y'] = 27.27, ['z'] = 54.65 },
	[5] = { ['x'] = -598.12, ['y'] = 5.68, ['z'] = 43.07 },
	[6] = { ['x'] = -795.49, ['y'] = 40.80, ['z'] = 48.25 },
	[7] = { ['x'] = -843.95, ['y'] = 87.22, ['z'] = 51.96 },
	[8] = { ['x'] = -831.32, ['y'] = -227.58, ['z'] = 37.09 },
	[9] = { ['x'] = -682.37, ['y'] = -374.73, ['z'] = 34.15 },
	[10] = { ['x'] = -295.17, ['y'] = -617.44, ['z'] = 33.31 },
	[11] = { ['x'] = -553.23, ['y'] = -649.75, ['z'] = 33.08 },
	[12] = { ['x'] = -934.24, ['y'] = -456.49, ['z'] = 37.15 },
	[13] = { ['x'] = -1078.39, ['y'] = -267.97, ['z'] = 37.61 },
	[14] = { ['x'] = -1437.76, ['y'] = -412.62, ['z'] = 35.79 },
	[15] = { ['x'] = -1669.03, ['y'] = -541.66, ['z'] = 34.98 },
	[16] = { ['x'] = -1392.47, ['y'] = -580.91, ['z'] = 30.05 },
	[17] = { ['x'] = -1042.79, ['y'] = -387.18, ['z'] = 37.57 },
	[18] = { ['x'] = -255.13, ['y'] = -756.19, ['z'] = 32.63 },
	[19] = { ['x'] = 13.42, ['y'] = -972.96, ['z'] = 29.30 },
	[20] = { ['x'] = 257.70, ['y'] = -1062.13, ['z'] = 29.10 },
	[21] = { ['x'] = 792.41, ['y'] = -944.58, ['z'] = 25.55 },
	[22] = { ['x'] = 120.44, ['y'] = -926.42, ['z'] = 29.73 },
	[23] = { ['x'] = 2.53, ['y'] = -1127.96, ['z'] = 28.09 },
	[24] = { ['x'] = -582.63, ['y'] = -867.52, ['z'] = 25.63 },
	[25] = { ['x'] = -1047.00, ['y'] = -779.63, ['z'] = 18.93 },
	[26] = { ['x'] = -1061.55, ['y'] = -495.26, ['z'] = 36.24 },
	[27] = { ['x'] = -1071.15, ['y'] = -433.65, ['z'] = 36.45 },
	[28] = { ['x'] = -1203.82, ['y'] = -131.74, ['z'] = 40.70 },
	[29] = { ['x'] = -932.33, ['y'] = 326.64, ['z'] = 71.25 },
	[30] = { ['x'] = -587.70, ['y'] = 250.66, ['z'] = 82.26 },
	[31] = { ['x'] = -478.28, ['y'] = 223.87, ['z'] = 83.02 },
	[32] = { ['x'] = -310.77, ['y'] = 226.85, ['z'] = 87.78 },
	[33] = { ['x'] = 75.20, ['y'] = 229.06, ['z'] = 108.70 },
	[34] = { ['x'] = 296.00, ['y'] = 147.55, ['z'] = 103.77 },
	[35] = { ['x'] = 978.79, ['y'] = -117.71, ['z'] = 73.99 },
	[36] = { ['x'] = 1187.01, ['y'] = -431.18, ['z'] = 67.02 },
	[37] = { ['x'] = 1260.03, ['y'] = -582.09, ['z'] = 68.88 },
	[38] = { ['x'] = 1360.39, ['y'] = -570.32, ['z'] = 74.22 }
} 
-- Locs você pode selecionar as de sua preferência --
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRABALHAR
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local sleep = 1000
		if not servico then
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))

			if Vdist(x,y,z,CoordenadaX,CoordenadaY,CoordenadaZ) <= 15 then
				sleep = 10
				DrawMarker(27,CoordenadaX,CoordenadaY,CoordenadaZ-0.97,0,0,0,0,0,0,1.0,1.0,0.5,240,200,80,50,0,0,0,1)
				DrawMarker(2,CoordenadaX,CoordenadaY,CoordenadaZ-0.4,0,0,0,0.0,0,0,0.4,0.4,0.4,255,255,255,70,1,0,0,1)
				if Vdist(x,y,z,CoordenadaX,CoordenadaY,CoordenadaZ) <= 1.5 then
					sleep = 1
					if IsControlJustPressed(0,38) then
						TriggerEvent("Notify","sucesso","Pegue encomendas e utilize o veiculo da companhia para realizar as entregas!")
						servico = true
						entregas()
						offservice()
						process()
						selecionado = math.random(38)
						CriandoBlip(locs,selecionado)
					end
				end
			end
		end
		Citizen.Wait(sleep)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENTREGAS
-----------------------------------------------------------------------------------------------------------------------------------------
function entregas()
	Citizen.CreateThread(function()
		while true do
			local sleep = 1000
			if servico then
				local ped = PlayerPedId()
				local x,y,z = table.unpack(GetEntityCoords(ped))
				local valorencomenda = math.random(80,90)

				if Vdist(x,y,z,locs[selecionado].x,locs[selecionado].y,locs[selecionado].z) <= 20.0 then
					sleep = 5
					DrawMarker(21,locs[selecionado].x,locs[selecionado].y,locs[selecionado].z+0.30,0,0,0,0,180.0,130.0,2.0,2.0,1.0,240,200,80,20,1,0,0,1)
					if Vdist(x,y,z,locs[selecionado].x,locs[selecionado].y,locs[selecionado].z) <= 2.5 then
						drawTxt("PRESSIONE  ~b~E~w~  PARA ENTREGAR ENCOMENDAS",4,0.5,0.93,0.50,255,255,255,180)
						sleep = 1
						if IsControlJustPressed(0,38) then
							if IsVehicleModel(GetVehiclePedIsUsing(ped),GetHashKey("boxville")) then								
								if func.checkPayment1() then
									RemoveBlip(blips)
									backentrega = selecionado
										while true do
											if backentrega == selecionado then
												selecionado = math.random(38)
											else
												break
											end
											Citizen.Wait(1)
										end
									
									CriandoBlip(locs,selecionado)
								end
							else
								TriggerEvent("Notify","negado","Você deve usar o veiculo da companhia para realizar as entregas!")
							end
						end
					end
				end
			else
				break
			end
			Citizen.Wait(sleep)
		end
	end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCELAR
-----------------------------------------------------------------------------------------------------------------------------------------
function offservice()
	Citizen.CreateThread(function()
		while true do
			local sleep = 1000
			if servico then
				sleep = 1
				drawTxt("~y~PRESSIONE ~r~F7 ~w~SE DESEJA FINALIZAR A ROTA ",4,0.270,0.905,0.45,255,255,255,200)
				if IsControlJustPressed(0,168) then
					servico = false
					RemoveBlip(blips)
				end
			else
				break
			end
			Citizen.Wait(sleep)
		end
	end)
end


-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local processo = false
local CoordenadaX = 78.93
local CoordenadaY = 112.45
local CoordenadaZ = 81.19
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROCESSO
-----------------------------------------------------------------------------------------------------------------------------------------
function process()
	Citizen.CreateThread(function()
		while true do
			local sleep = 1000
			if servico then
				local ped = PlayerPedId()
				local x,y,z = table.unpack(GetEntityCoords(ped))

				if Vdist(x,y,z,CoordenadaX,CoordenadaY,CoordenadaZ) <= 5 and not processo then
					sleep = 5
					DrawMarker(27,CoordenadaX,CoordenadaY,CoordenadaZ-1.0,0,0,0,0.0,0,0,0.9,0.9,0.8,240,200,80,70,0,1,0,1)
					DrawMarker(39,CoordenadaX,CoordenadaY,CoordenadaZ-0.4,0,0,0,0.0,0,0,0.8,0.8,0.7,240,200,200,40,1,0,0,1)
					if Vdist(x,y,z,CoordenadaX,CoordenadaY,CoordenadaZ) <= 1.5 then
						drawTxt("PRESSIONE  ~b~E~w~  PARA EMPACOTAR ENCOMENDA",4,0.5,0.93,0.50,255,255,255,180)
						sleep = 1
						if IsControlJustPressed(0,38) then
							if func.checkPayment() then
								processo = true
								SetTimeout(10000,function()
									processo = false
									TriggerEvent('cancelando',false)
								end)
							else 
								TriggerEvent("Notify","sucesso","Mochila cheia!")
							end
						end
					end
				end
			else 
				break
			end
			Citizen.Wait(sleep)
		end
	end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

function CriandoBlip(locs,selecionado)
	blips = AddBlipForCoord(locs[selecionado].x,locs[selecionado].y,locs[selecionado].z)
	SetBlipSprite(blips,1)
	SetBlipColour(blips,5)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Entrega de Encomenda")
	EndTextCommandSetBlipName(blips)
end
