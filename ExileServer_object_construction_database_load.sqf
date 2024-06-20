/**
 * ExileServer_object_construction_database_load
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 * 64Bit Conversion File Header (Extdb3) - Validatior
 */
private["_constructionID", "_data", "_position", "_vectorDirection", "_vectorUp", "_constructionObject", "_damageLevel", "_public", "_pinCode"];
_constructionID = _this;
_data = format ["loadConstruction:%1", _constructionID] call ExileServer_system_database_query_selectSingle;
_position = [_data select 4, _data select 5, _data select 6];
_vectorDirection = [_data select 7, _data select 8, _data select 9];
_vectorUp = [_data select 10, _data select 11, _data select 12];
_constructionObject = createVehicle [(_data select 1), _position, [], 0, "CAN_COLLIDE"];
_constructionObject setPosATL _position;
_constructionObject setVectorDirAndUp [_vectorDirection, _vectorUp];
_constructionObject setVariable ["ExileDatabaseID", _data select 0];
_constructionObject setVariable ["ExileOwnerUID", (_data select 2)];
_constructionObject setVariable ["ExileIsPersistent", true];
_constructionObject setVariable ["ExileTerritoryID", (_data select 15)];
_damageLevel = (_data select 17);
_public = _damageLevel > 0;
_constructionObject setVariable ["ExileConstructionDamage",_damageLevel,_public];
if(_public)then
{
	_constructionObject call ExileServer_util_setDamageTexture;
};
_pinCode = _data select 14;
if !(_pinCode isEqualTo "000000") then
{
	_constructionObject setVariable ["ExileAccessCode", _pinCode];
	_constructionObject setVariable ["ExileIsLocked", (_data select 13), true];
};
if (getNumber(configFile >> "CfgVehicles" >> (_data select 1) >> "exileRequiresSimulation") isEqualTo 1) then
{
	if (getNumber(missionConfigFile >> "CfgSimulation" >> "enableDynamicSimulation") isEqualTo 1) then 
	{
		_constructionObject enableDynamicSimulation true;
	}
	else
	{
		_constructionObject enableSimulationGlobal true;
		_constructionObject call ExileServer_system_simulationMonitor_addVehicle;
	};
}
else 
{
	_constructionObject enableSimulationGlobal false;
};
_constructionObject setVelocity [0, 0, 0];
_constructionObject setPosATL _position;
_constructionObject setVelocity [0, 0, 0];
_constructionObject setVectorDirAndUp [_vectorDirection, _vectorUp];
_constructionObject setVelocity [0, 0, 0];

//// Filtering objects without assigned terrain type
// Provide data for the function. You can add as many _extraFilterXX as you want. Be sure to call them down the line
private _extraFilterVegetation = ["fallenbranch"];
private _extraFilterRocks = ["cliff_stone_big_lc_f"];
private _radius = 25;

// let it cook
private _allTerrainObjects = nearestTerrainObjects [_position, [], _radius];
private _objectsToStrings = _allTerrainObjects apply { format ["%1", _x] };
filterObjectsByNamePatterns = {

	params ["_objectNames","_allTerrainObjects","_objectsToStrings"];
    private _matchingIndices = [];
    {
        private _pattern = _x;
        {
            private _index = _forEachIndex;
            private _objectString = _x;
            if (_objectString find _pattern != -1) then {
                _matchingIndices pushBack _index;
            };
        } forEach _objectsToStrings;
    } forEach _objectNames;
    private _filteredObjects = _matchingIndices apply { _allTerrainObjects select _x };
    _filteredObjects
};

// If you added any _extraFilters, include them here. 
private _filteredObjects01 = [_extraFilterVegetation, _allTerrainObjects, _objectsToStrings] call filterObjectsByNamePatterns;
private _filteredObjects02 = [_extraFilterRocks, _allTerrainObjects, _objectsToStrings] call filterObjectsByNamePatterns;
//// Filtering objects without assigned terrain type END

private _gpotrib = (_data select 1);
private _case = {};
if (_gpotrib == "Land_Camping_Light_F") then {_case = 1};  					// this classname requires EBM
if (_gpotrib == "Land_Small_Stone_02_F") then {_case = 2};  				// this classname requires EBM
if (_gpotrib == "PortableHelipadLight_01_green_F") then {_case = 3};  		// this classname requires EBM

switch (_case) do {
	default		{}; 
	case 1: 	{
		private _terrainobjects = nearestTerrainObjects [_position, ["TREE", "SMALL TREE", "BUSH"], _radius];
		if !(isNil "_filteredObjects01") then {_terrainobjects append _filteredObjects01};		// This is how you add filtered objects without assigned terrain type to be hidden
		{
			hideObjectGlobal _x
		} foreach _terrainobjects;
	};
	
	case 2: 	{
	private _terrainobjects = nearestTerrainObjects [_position, ["ROCK", "ROCKS"], _radius];
	if !(isNil "_filteredObjects02") then {_terrainobjects append _filteredObjects02};
		{
			hideObjectGlobal _x
		} foreach _terrainobjects;
	};
	
	case 3: 	{
	private _terrainobjects = nearestTerrainObjects [_position, ["TREE", "SMALL TREE", "BUSH", "ROCK", "ROCKS"], _radius];
	if !(isNil "_filteredObjects01") then {_terrainobjects append _filteredObjects01};
	if !(isNil "_filteredObjects02") then {_terrainobjects append _filteredObjects02};
		{
			hideObjectGlobal _x
		} foreach _terrainobjects;
	};
};

_constructionObject
