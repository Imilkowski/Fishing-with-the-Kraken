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
    [AddComponentMenu("Lua/TutorialModule")]
    [LuaRegisterType(0xb1451560b92d023b, typeof(LuaBehaviour))]
    public class TutorialModule : LuaBehaviourThunk
    {
        private const string s_scriptGUID = "7902d563387287646be5a13673b0d1f1";
        public override string ScriptGUID => s_scriptGUID;

        [SerializeField] public System.Double m_tutorialVersion = 0;
        [SerializeField] public UnityEngine.GameObject m_arrowPrefab = default;
        [SerializeField] public UnityEngine.GameObject m_headArrowPrefab = default;
        [SerializeField] public UnityEngine.Transform m_cannonBallCratesParent = default;
        [SerializeField] public UnityEngine.Transform m_cannonsParent = default;

        protected override SerializedPropertyValue[] SerializeProperties()
        {
            if (_script == null)
                return Array.Empty<SerializedPropertyValue>();

            return new SerializedPropertyValue[]
            {
                CreateSerializedProperty(_script.GetPropertyAt(0), m_tutorialVersion),
                CreateSerializedProperty(_script.GetPropertyAt(1), m_arrowPrefab),
                CreateSerializedProperty(_script.GetPropertyAt(2), m_headArrowPrefab),
                CreateSerializedProperty(_script.GetPropertyAt(3), m_cannonBallCratesParent),
                CreateSerializedProperty(_script.GetPropertyAt(4), m_cannonsParent),
            };
        }
        
#if HR_STUDIO
        [MenuItem("CONTEXT/TutorialModule/Edit Script")]
        private static void EditScript()
        {
            VisualStudioCodeOpener.OpenPath(AssetDatabase.GUIDToAssetPath(s_scriptGUID));
        }
#endif
    }
}

#endif
