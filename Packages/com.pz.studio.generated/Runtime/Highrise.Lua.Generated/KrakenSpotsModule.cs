/*

    Copyright (c) 2025 Pocketz World. All rights reserved.

    This is a generated file, do not edit!

    Generated by com.pz.studio
*/

#if UNITY_EDITOR

using System;
using System.Linq;
using UnityEngine;
using Highrise.Client;
using Highrise.Studio;
using Highrise.Lua;
using UnityEditor;

namespace Highrise.Lua.Generated
{
    [AddComponentMenu("Lua/KrakenSpotsModule")]
    [LuaRegisterType(0xb394979f17a65fe0, typeof(LuaBehaviour))]
    public class KrakenSpotsModule : LuaBehaviourThunk
    {
        private const string s_scriptGUID = "5482d24130ed0e34ca22d230899d161a";
        public override string ScriptGUID => s_scriptGUID;

        [SerializeField] public UnityEngine.GameObject m_tentaclePrefab = default;
        [SerializeField] public System.Double m_spawnRate = 0;
        [SerializeField] public System.Double m_tentacleAttackRate = 0;
        [SerializeField] public System.Double m_tentaclesMaxCount = 0;
        [SerializeField] public UnityEngine.Transform m_cannonsParent = default;

        protected override SerializedPropertyValue[] SerializeProperties()
        {
            if (_script == null)
                return Array.Empty<SerializedPropertyValue>();

            return new SerializedPropertyValue[]
            {
                CreateSerializedProperty(_script.GetPropertyAt(0), m_tentaclePrefab),
                CreateSerializedProperty(_script.GetPropertyAt(1), m_spawnRate),
                CreateSerializedProperty(_script.GetPropertyAt(2), m_tentacleAttackRate),
                CreateSerializedProperty(_script.GetPropertyAt(3), m_tentaclesMaxCount),
                CreateSerializedProperty(_script.GetPropertyAt(4), m_cannonsParent),
            };
        }
        
#if HR_STUDIO
        [MenuItem("CONTEXT/KrakenSpotsModule/Edit Script")]
        private static void EditScript()
        {
            VisualStudioCodeOpener.OpenPath(AssetDatabase.GUIDToAssetPath(s_scriptGUID));
        }
#endif
    }
}

#endif
