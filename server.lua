local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
func = {}
Tunnel.bindInterface("emp_sedex",func)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local quantidade = {}
function func.Quantidade()
	local source = source
	if quantidade[source] == nil then
		quantidade[source] = math.random(4,8)
	end
end


-----------------------------------------------------------------------------------------------------------------------------------------
-- ENTREGA ENCOMENDA
-----------------------------------------------------------------------------------------------------------------------------------------
function func.checkPayment1()
	func.Quantidade()
	local source = source
	local user_id = vRP.getUserId(source)
	local valorencomenda = math.random(80,90)
	local pagamento = valorencomenda*quantidade[source]
	if user_id then
		if vRP.tryGetInventoryItem(user_id,"encomenda",quantidade[source]) then
			--vRP.giveMoney(user_id,math.random(80,90)*quantidade[source])
			vRP.giveMoney(user_id,parseInt(pagamento))
			TriggerClientEvent("Notify",source,"sucesso","<b>Encomenda</b> entregue, você recebeu <b>$"..pagamento.."</b>!")
			quantidade[source] = nil
			return true
		else
			TriggerClientEvent("Notify",source,"aviso","Você precisa de <b>"..quantidade[source].."x Encomendas</b>.")
		end
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- EMPACOTAR ENCOMENDAS
-----------------------------------------------------------------------------------------------------------------------------------------
function func.checkPayment()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("encomenda")*3 <= vRP.getInventoryMaxWeight(user_id) then
			TriggerClientEvent("progress",source,10000,"Empacontando Encomenda")
			
			vRPclient._playAnim(source,false,{{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"}},true)
			SetTimeout(10000,function()
				vRPclient._stopAnim(source,false)
				vRP.giveInventoryItem(user_id,"encomenda",3)
				TriggerClientEvent("Notify",source,"sucesso","Você empacotou 3x encomendas.")
			end)
			return true
		end
	end
end