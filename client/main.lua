-----
-- Copyright [2018] [SKZ]
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--     http://www.apache.org/licenses/LICENSE-2.0
-- 
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
----

ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(35)
    end
end)

function VehicleInFront() -- Check vehicle in front
    local pos = GetEntityCoords(PlayerPedId())
    local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 6.0, 0.0)
    local rayHandle = CastRayPointToPoint(pos.x,pos.y,pos.z - 0.8,entityWorld.x,entityWorld.y,entityWorld.z,7,PlayerPedId(),0)
    local a, b, c, d, result = GetRaycastResult(rayHandle)
    return result
end

Citizen.CreateThread(function() -- If there are no vehicles in front of you, it close the menu.
    while true do
        Citizen.Wait(50)

        local playerPed = PlayerPedId()
        local vehicle = VehicleInFront()
        local closecar = GetClosestVehicle(x, y, z, 6.0, 0, 71)

        if vehicle == 0 and closecar == 0 then
            ESX.UI.Menu.Close('default',GetCurrentResourceName(),'vehicle_infos')
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if IsControlJustPressed(1, 38) and not IsPedInAnyVehicle(PlayerPedId(), true) then

            local playerPed = PlayerPedId()

            local vehicle = VehicleInFront()
            
            local closecar = GetClosestVehicle(x, y, z, 6.0, 0, 71)

            local plate = GetVehicleNumberPlateText(vehicle)

            if closecar ~= nil and plate ~= nil then

                local healthMeca = GetVehicleEngineHealth(vehicle)

                local categ = GetVehicleClass(vehicle)

                local model = GetEntityModel(vehicle)
                
                local modelName = GetDisplayNameFromVehicleModel(model)

                if vehicle > 0 and  model ~= 0 and modelName ~= "CARNOTFOUND" then -- If there is a vehicle in front of you then

                    if categ == 0 then
                        categ = _U('Compacts')
                    elseif categ == 1 then
                        categ = _U('Sedans')
                    elseif categ == 2 then
                        categ = _U('SUVs')
                    elseif categ == 3 then
                        categ = _U('Coupes')
                    elseif categ == 4 then
                        categ = _U('Muscle')
                    elseif categ == 5 then
                        categ = _U('Sports Classics')
                    elseif categ == 6 then
                        categ = _U('Sports')
                    elseif categ == 7 then
                        categ = _U('Super')
                    elseif categ == 8 then
                        categ = _U('Motorcycles')
                    elseif categ == 9 then
                        categ = _U('Off-road')
                    elseif categ == 10 then
                        categ = _U('Industrial')
                    elseif categ == 11 then
                        categ = _U('Utility')
                    elseif categ == 12 then
                        categ = _U('Vans')
                    elseif categ == 13 then
                        categ = _U('Cycles')
                    elseif categ == 14 then
                        categ = _U('Boats')
                    elseif categ == 15 then
                        categ = _U('Helicopters')
                    elseif categ == 16 then
                        categ = _U('Planes')
                    elseif categ == 17 then
                        categ = _U('Service')
                    elseif categ == 18 then
                        categ = _U('Emergency')
                    elseif categ == 19 then
                        categ = _U('Military')
                    elseif categ == 20 then
                        categ = _U('Commercial')
                    else
                        categ = _U('notfound')
                    end

                    if healthMeca >= 850 then
                        healthMeca = "<span style=\"color:#22780F;\">" .. _U('verygood') .. "</span>"
                    elseif healthMeca >= 600 then
                        healthMeca = "<span style=\"color:#D1B606;\">" .. _U('good') .. "</span>"
                    elseif healthMeca >= 300 then
                        healthMeca = "<span style=\"color:#ED7F10;\">" .. _U('medium') .. "</span>"
                    else
                        healthMeca = "<span style=\"color:#B82010;\">" .. _U('bad') .. "</span>"
                    end

                    local elements = {}
                    table.insert(elements,{
                        label = '' .. _U('model') .. '<span style="color:#CC5500;">' .. modelName .. '</span>',
                        value = nil
                    })
                    table.insert(elements,{
                        label = '' .. _U('category') .. '<span style="color:#DFAF2C;">' .. categ .. '</span>',
                        value = nil
                    })
                    if plate ~= nil then
                        table.insert(elements,{
                            label = '' .. _U('plate') .. '<span style="color:#318CE7;">' .. plate .. '</span>',
                            value = nil
                        })
                    end
                    table.insert(elements,{
                        label = '' .. _U('vehicleState') .. ' ' .. healthMeca .. '</span>',
                        value = nil
                    })

                    ESX.UI.Menu.Open('default',GetCurrentResourceName(),'vehicle_infos',{
                        css = "vehicle_infos",
                        title = _U('title'),
                        align = 'top-left',
                        elements = elements
                    },function(data, menu) 

                    end,function(data, menu) 
                        menu.close() 
                    end)

                end
            end
        end

    end
end)
